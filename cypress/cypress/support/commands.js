// QP-01, step 6. Keep the page details out of the main test.
Cypress.Commands.add('adminLogin', (username, password) => {
  cy.visit('https://quickpizza.grafana.com/admin')
  cy.get('#svelte-announcer').should('exist')
  cy.get('#username').clear().type(username)
  cy.get('#password').clear().type(password)
  cy.get('button[type="submit"]').click()
})
