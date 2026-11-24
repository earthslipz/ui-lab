// QP-01: A custom pizza reaches the admin list.
// Goal: test the restricted pizza, the login requirement for ratings,
// and the result shown to an administrator.

function dateStamp() {
  const d = new Date()
  const two = (value) => String(value).padStart(2, '0')
  return `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}-` +
    `${two(d.getHours())}${two(d.getMinutes())}${two(d.getSeconds())}`
}

describe('QP-01 custom pizza', () => {
  it('keeps the requested restrictions and appears in the admin list', () => {
    const pizzaName = `Lab Pizza ${dateStamp()}`
    cy.log(`Pizza name: ${pizzaName}`)

    // Step 1: home page
    cy.visit('https://quickpizza.grafana.com')
    cy.get('h1').should('have.text', 'Looking to break out of your pizza routine?')

    // Step 2: show the advanced settings
    cy.contains('label', 'Advanced').click()
    cy.contains('label', 'Max Calories per Slice').should('be.visible')
    cy.contains('label', 'Excluded tools').should('be.visible')
    cy.contains('label', 'Must be vegetarian').should('be.visible')
    cy.contains('label', 'Custom Pizza Name').should('be.visible')

    // Step 3: enter the restrictions
    cy.contains('label', 'Max Calories per Slice')
      .siblings('input').clear().type('600').should('have.value', '600')
    cy.get('select').select('Knife')
    cy.contains('option', 'Knife').should('be.selected')
    cy.get('#default-checkbox').check().should('be.checked')
    cy.get('input#pizza-name').type(pizzaName).should('have.value', pizzaName)

    // Step 4: verify both the API response and the displayed pizza
    cy.intercept('POST', '/api/pizza').as('pizza')
    cy.get('button[name="pizza-please"]').click()
    cy.wait('@pizza').its('response.statusCode').should('eq', 200)
    cy.get('@pizza').then(({ request, response }) => {
      expect(request.body.maxCaloriesPerSlice).to.equal(600)
      const { pizza, calories } = response.body
      cy.contains('#recommendations p', 'Tool:')
        .should('have.text', `Tool: ${pizza.tool}`)
      cy.contains('#recommendations p', 'Calories per slice:')
        .should('have.text', `Calories per slice: ${calories}`)
      cy.log(`Recommended tool: ${pizza.tool}; Calories: ${calories}`)
      cy.wrap(pizza.tool).as('chosenTool')
    })
    cy.get('#recommendations').should('contain', `Name: ${pizzaName}`)
    cy.contains('#recommendations p', 'Tool:').should('not.contain', 'Knife')
    cy.contains('#recommendations p', 'Calories per slice:')
      .invoke('text').then((value) => {
        const calories = Number(value.replace('Calories per slice:', '').trim())
        expect(calories).to.be.at.most(600)
      })
    cy.screenshot('qp01-step4-recommendation')

    // Step 5: rating needs a login
    cy.get('button[name="rate-5"]').click()
    cy.get('#rate-result').should('have.text', 'Please log in first.')
    cy.screenshot('qp01-step5-login-needed')

    // Step 6: admin login (same browser, keeps the server cookie)
    cy.adminLogin('admin', 'admin')
    cy.contains('Latest pizza recommendations').should('be.visible')

    // Step 7: find this pizza and check its cutting tool
    cy.get('@chosenTool').then((tool) => {
      cy.contains('li', pizzaName).should('contain', `(tool=${tool},`)
    })
    cy.screenshot('qp01-step7-admin-list')
  })
})
