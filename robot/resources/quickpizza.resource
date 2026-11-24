*** Settings ***
Documentation    Page actions used by the QuickPizza QP-01 test.
Library    SeleniumLibrary    timeout=10s
Library    String

*** Variables ***
${URL}                https://quickpizza.grafana.com
${BROWSER}            chrome
${HEADING}            Looking to break out of your pizza routine?
${MAX CALORIES}       xpath://label[contains(.,'Max Calories')]/../input

*** Keywords ***
Open QuickPizza
    [Documentation]    Step 1: open the home page and check its heading.
    Open Browser    ${URL}    ${BROWSER}
    ...    service=executable_path=r'%{CHROMEDRIVER}'
    Set Window Size    1280    1600
    Wait Until Element Is Visible    css:h1
    Element Text Should Be    css:h1    ${HEADING}

Turn On Advanced
    [Documentation]    Step 2: show the advanced input fields.
    Click Element    xpath://label[.//span[normalize-space()='Advanced']]
    Wait Until Page Contains Element    xpath://option[.='Knife']
    Element Should Be Visible    ${MAX CALORIES}
    Element Should Be Visible    css:select
    Element Should Be Visible    id:default-checkbox
    Element Should Be Visible    css:input#pizza-name

Fill In The Pizza Request
    [Documentation]    Step 3: fill in the restrictions and check all values.
    [Arguments]    ${calories}    ${tool}    ${name}
    Input Text    ${MAX CALORIES}    ${calories}
    Select From List By Label    css:select    ${tool}
    Select Checkbox    id:default-checkbox
    Input Text    css:input#pizza-name    ${name}
    Textfield Value Should Be    ${MAX CALORIES}    ${calories}
    List Selection Should Be    css:select    ${tool}
    Checkbox Should Be Selected    id:default-checkbox
    Textfield Value Should Be    css:input#pizza-name    ${name}

Ask For A Pizza
    [Documentation]    Step 4: request a pizza and wait until the answer is on the page.
    Click Button    name:pizza-please
    Wait Until Element Contains    id:recommendations    Name:

Get Recommended Tool
    [Documentation]    Read the tool that QuickPizza selected.
    ${line}=    Get Text    xpath://p[starts-with(.,'Tool:')]
    ${tool}=    Remove String    ${line}    Tool:${SPACE}
    RETURN    ${tool}

Get Calories Per Slice
    [Documentation]    Read the calories from the displayed result.
    ${line}=    Get Text    xpath://p[starts-with(.,'Calories per slice:')]
    ${calories}=    Remove String    ${line}    Calories per slice:${SPACE}
    RETURN    ${calories}

Recommendation Should Keep The Restrictions
    [Documentation]    Step 4: verify the name, cutting tool and calorie limit.
    [Arguments]    ${name}    ${excluded tool}    ${max calories}
    Element Should Contain    id:recommendations    Name: ${name}
    ${tool}=    Get Recommended Tool
    Should Not Be Equal    ${tool}    ${excluded tool}
    ${calories}=    Get Calories Per Slice
    Should Be True    ${calories} <= ${max calories}
    RETURN    ${tool}

Rate The Pizza Without Logging In
    [Documentation]    Step 5: the page must ask the customer to log in first.
    Click Button    name:rate-5
    Wait Until Element Contains    id:rate-result    Please log in first.
    Element Text Should Be    id:rate-result    Please log in first.

Log In As Admin
    [Documentation]    Step 6: open the admin page in the same browser and log in.
    [Arguments]    ${user}    ${password}
    Go To    ${URL}/admin
    Wait Until Page Contains Element    id:svelte-announcer
    Input Text    id:username    ${user}
    Input Password    id:password    ${password}
    Click Button    css:button[type=submit]
    Wait Until Page Contains    Latest pizza recommendations

Admin List Should Show The Pizza
    [Documentation]    Step 7: verify the admin entry contains the same tool.
    [Arguments]    ${name}    ${tool}
    Wait Until Page Contains    ${name}
    Element Should Contain    xpath://li[contains(.,'${name}')]    (tool=${tool},
