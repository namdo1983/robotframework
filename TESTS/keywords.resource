*** Settings ***
Library     SeleniumLibrary    run_on_failure=None
Library     OperatingSystem
Library     ../DRIVERS/CustomLib.py


*** Variables ***
${URL_HOMEPAGE}     https://tiki.vn/
${PATH_RP}          ${CURDIR}/Report.txt


*** Keywords ***
My Open Chrome Browser With Options
    Create File    ${PATH_RP}
    ${chrome_path}    My Chrome
    Open Browser
    ...    ${EMPTY}
    ...    chrome
    ...    executable_path=${chrome_path}
    ...    options=add_argument("--disable-popup-blocking");add_argument("--disable-notifications");add_argument("--no-sandbox");add_argument("--disable-logging")
    Maximize Browser Window
    Delete All Cookies
    Set Selenium Speed    0.4
    Set Selenium Timeout    30s
    Remove File    ${CURDIR}/my_fail_report.txt
    # My Create And Open Excel Document

Select NGON menu
    Sleep    3
    Click Element    //div[.='NGON']
    Log To Console    Complete

Kham Pha Them
    Sleep    5
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Wait Until Element Is Visible    //div[.='Xem thêm']
    # Click Xem them
    Click Element
    ...    css=#__next > div.home-page > main > div.styles__StyledTikiNgonDynamicWidget-sc-140wzv4-0.dxUHj.tikingon_infinite_scroll > div > div > div > a
    @{title_product}    Get WebElements
    ...    //*[@id="__next"]/div[1]/main/div[8]/div/div/div/div/div[*]/div/div[2]/a/div[2]/h3
    ${sold_out}    Get WebElements
    ...    //*[@id="__next"]/div[1]/main/div[8]/div/div/div/div/div[*]/div/div[2]/a/div[2]/div[2]

    FOR    ${title}    ${sold}    IN ZIP    ${title_product}    ${sold_out}
        ${title}    Run Keyword And Ignore Error    Get Text    ${title}
        ${sold}    Run Keyword And Ignore Error    Get Text    ${sold}
        ${content}    Set Variable    +------------------------------+\n+ ${title}[1]: ${sold}[1]\n
        Append To File    ${PATH_RP}    ${content}
    END

Write Fail Report At TestCase
    ${get_current_url}    Get Location
    IF    '${TEST_STATUS}' == 'FAIL'
        Append To File    ${CURDIR}/fail_report.txt    ${get_current_url}\n${TEST_STATUS} => ${TEST_MESSAGE}\n
    END
