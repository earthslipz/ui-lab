*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers

*** Variables ***
${FORM_URL}    https://www.selenium.dev/selenium/web/web-form.html
${BROWSER}     chrome

*** Test Cases ***
The Web Form Opens
    [Documentation]    Check that Selenium's practice web form has the right title.
    Open Browser    ${FORM_URL}    ${BROWSER}
    ...    service=executable_path=r'%{CHROMEDRIVER}'
    Title Should Be    Web form