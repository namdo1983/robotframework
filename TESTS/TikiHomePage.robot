*** Settings ***
Suite Setup       My Open Chrome Browser With Options
Suite Teardown    My Test Suite Options
Library           RPA.Browser.Selenium    run_on_failure=None
Library           OperatingSystem
Library           RPA.Excel.Files

*** Variables ***
${URL_HOMEPAGE}    https://tiki.vn/

*** Test Cases ***
Make A Search
    [Setup]    Go To    ${URL_HOMEPAGE}
    Wait Until Keyword Succeeds    2x    5000ms    Choose Dien Thoai
    # Get data from search
    Run Keyword And Continue On Failure    Lua Chon Pho Bien
    [Teardown]    Run Keyword If Test Failed    Write Fail Report At TestCase

*** Keywords ***
My Open Chrome Browser With Options
    Open Browser    ${EMPTY}    chrome    executable_path=${CURDIR}/../DRIVERS/chromedriver.exe    service_log_path=${CURDIR}/my_chrome.log    options=add_argument("--disable-popup-blocking");add_argument("--disable-notifications");add_argument("--no-sandbox");add_argument("--disable-logging")
    Maximize Browser Window
    Delete All Cookies
    Set Browser Implicit Wait    1s
    Set Selenium Timeout    60s
    Remove File    ${CURDIR}/my_fail_report.txt
    My Create And Open Excel Document

Choose Dien Thoai
    Reload Page
    Wait Until Element Is Visible    //img[@src='https://salt.tikicdn.com/ts/upload/96/d1/77/e499ea39b0773a337d2217ad473fcb97.png']
    Mouse Over    //img[@src='https://salt.tikicdn.com/ts/upload/96/d1/77/e499ea39b0773a337d2217ad473fcb97.png']
    Sleep    3
    Click Element    //span[.='Điện Thoại - Máy Tính Bảng']    action_chain=True
    Log To Console    Complete

Lua Chon Pho Bien
    ${pho_bien}    Set Variable    css=[data-view-index='0'][data-view-id='search_sort_item']
    Wait Until Element Is Visible    ${pho_bien}
    ${text_pb}    Get Text    ${pho_bien}
    Sleep    5
    IF    'Phổ Biến' in '${text_pb}'
    Log To Console    Already selected
    ELSE
    Click Element    ${pho_bien}    action_chain=True
    END
    # Get all pagination
    @{all_page}    Get WebElements    //a[@data-view-id="product_list_pagination_item"]
    ${len_page}    Get Length    ${all_page}
    FOR    ${page}    IN RANGE    2    ${len_page}
    ${all_page}    Get WebElements    //a[@data-view-id="product_list_pagination_item"]
    Wait For Condition    return document.readyState=="complete"
    @{list_page}    Get WebElements    //a[@class='product-item']
    ${len_list}    Get Length    ${list_page}
    ${number_row}    Set Variable    1
    FOR    ${item}    IN    @{list_page}
        Scroll Element Into View    ${item}
        ${name_product}    Get Text    ${item}
        Set Cell Value    ${number_row}    1    ${name_product}
        ${href_product}    Get Element Attribute    ${item}    href
        Set Cell Value    ${number_row}    2    ${href_product}
        ${number_row}    Evaluate    ${number_row}+1
    END
    Scroll Element Into View    ${all_page}[${page}]
    Click Element    ${all_page}[${page}]    action_chain=True
    Wait Until Element Is Visible    ${pho_bien}
    Sleep    5
    Exit For Loop If    '${page}' == '${len_page}'
    END

Write Fail Report At TestCase
    ${get_current_url}    Get Location
    Run Keyword If    '${TEST_STATUS}' == 'FAIL'    Append To File    ${CURDIR}/my_fail_report.txt    ${get_current_url}\n${TEST_STATUS} => ${TEST_MESSAGE}\n

My Test Suite Options
    Save Workbook    ${CURDIR}/my_data.xlsx
    Close Workbook
    Close All Browsers

My Create And Open Excel Document
    Create Workbook    ${CURDIR}/my_data.xlsx
