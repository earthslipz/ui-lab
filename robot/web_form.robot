*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers

*** Variables ***
${FORM_URL}    https://www.selenium.dev/selenium/web/web-form.html
${BROWSER}     chrome

*** Test Cases ***
Fill In The Web Form
    [Documentation]    Enter different field types, submit, and check the confirmation page.
    Open Browser    ${FORM_URL}    ${BROWSER}
    ...    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
    Input Text    id:my-text-id    Robot
    Textfield Value Should Be    id:my-text-id    Robot
    Input Password    name:my-password    Secret123
    Input Text    name:my-textarea    This is my UI test
    Select From List By Label    name:my-select    Two
    List Selection Should Be    name:my-select    Two
    Select Checkbox    id:my-check-2
    Checkbox Should Be Selected    id:my-check-2
    Select Radio Button    my-radio    my-radio-2
    Input Text    name:my-date    11/05/2026
    Textfield Value Should Be    name:my-date    11/05/2026
    Click Button    css:button[type=submit]
    Wait Until Element Is Visible    id:message
    Title Should Be    Web form - target page
    Element Text Should Be    id:message    Received!
