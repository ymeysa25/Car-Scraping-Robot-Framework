*** Settings ***
Documentation   Scraping Web Garasi.id
Library         SeleniumLibrary     run_on_failure=Nothing
Library         Collections
Library         MyFunc.py


*** Variables ***
${url}          https://garasi.id/pencarian/mobil-bekas/
${browser}      Chrome
${keyword}      Toyota Agya
${search_box}   xpath://input[@name="searchValue"]

# Test Cases / Tasks
*** Test Cases ***
Scraping
    Buka Google
    Close Browser

*** Keywords ***
Buka Google
    Open Browser    ${url}         ${browser}
    Maximize Browser Window

    Wait Until Element Is Visible   ${search_box}

    Input Text                      ${search_box}    ${keyword}
    Press Keys                      ${search_box}    ENTER

    FOR    ${row}    IN RANGE    1    6
        Log to Console      "Baris : " ${row}
        Buka Halaman    ${row}
    END

Buka Halaman
    [Arguments]     ${row}
     FOR    ${column}    IN RANGE    1    4
        ${car_article}       Set Variable             xpath://div[contains(@class, "VehicleListContainer")]/div/div[${row}]/div[${column}]/a
        Log to Console      "Column : " ${column}
        Wait Until Element Is Visible       ${car_article}      30
        ${link_car_article}   Get Element Attribute   ${car_article}    href

        Go To   ${link_car_article}
        Scraping        ${row}    ${column}

        Go Back
        Go Back
    END


Scraping
    [Arguments]     ${row}      ${column}
    ${car_title}        Set Variable        xpath=/html/body/div[2]/div[1]/main/div/div[3]/h1
    Wait Until Element Is Visible       ${car_title}
    ${car_title_text}       Get Text                ${car_title}

    ${text}        Get Text        xpath://span[contains(@class, "Chip_Content")]/span[2]
    ${max_number}       getNumber   ${text}

    ${img}      Set Variable             xpath=/html/body/div[2]/div[1]/main/div/div[1]/div/div[1]/div/div[1]/a/div/img
    Wait Until Element Is Visible       ${img}      30
    Click Element                       ${img}

    FOR    ${no_image}    IN RANGE    1    ${max_number}
        ${img}          Set Variable    //div[contains(@class, "h-75")]/div[2]/div/div[${no_image}]/div/div/img
        Wait Until Element Is Visible       ${img}   30
        ${src}   Get Element Attribute   ${img}    src
        MyFunc.Save Image   ${src}   ${no_image}    ${keyword}    ${car_title_text}     ${row}      ${column}
        Click Element                   //div[contains(@class, "h-75")]/div[3]/div[2]/div/img
    END

# Referensi
# Keywords : https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html