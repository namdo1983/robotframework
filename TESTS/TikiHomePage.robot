*** Settings ***
Documentation       A test suite for search page.
...
...                 Keywords are imported from the resource file

Resource            keywords.resource

Suite Setup         My Open Chrome Browser With Options


*** Test Cases ***
Make A Search
    [Setup]    Go To    ${URL_HOMEPAGE}
    Wait Until Keyword Succeeds    2x    5000ms    Select NGON menu
    # Get data from search
    Run Keyword And Continue On Failure    Kham Pha Them
    [Teardown]    Run Keyword If Test Failed    Write Fail Report At TestCase
