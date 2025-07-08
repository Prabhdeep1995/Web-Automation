*** Settings ***
Library     SeleniumLibrary
Library    XML
Resource    ../Pages/agooda_locators.robot
Library     DebugLibrary
Library    String
Library    Collections

*** Variables ***
${url}          https://www.agoda.com/
${browser}      chrome

*** Test Cases ***
Agooda Automation
    Open Browser    ${url}  ${browser}
    Maximize Browser Window

    Input Text    id=textInput    Noida
    Wait Until Element Is Visible    xpath=//li[@aria-label="Destination Noida, New Delhi and NCR (Area)"]
    Click Element    xpath=//li[@aria-label="Destination Noida, New Delhi and NCR (Area)"]
    
    Click Element    id=check-in-box

    Click Element    ${search_button}
    Wait Until Page Contains   Your budget (per night)

    FOR    ${counter}    IN RANGE    0     10
        Log    ${counter}
        Execute JavaScript    window.scrollBy(0, 1000)
    END

#    Get Element     //*[contains(@class, "PropertyCard__Section--pricingInfo")]
    Wait Until Page Contains Element    xpath=//span[contains(@class, "PropertyCardPrice__Value")]
    @{price_elements}=    Get WebElements    xpath=//span[contains(@class, "PropertyCardPrice__Value")]
    Log    ${price_elements}
    @{price}=   Create List
    FOR    ${index}    IN RANGE    0    10
        ${price_text}=  Get Text    ${price_elements[${index}]}
        ${new_price}=   Replace String  ${price_text}   ,   ${EMPTY}
        ${converted_price}=     Convert To Integer    ${new_price}

        Log    ${converted_price}
        Append To List  ${price}    ${converted_price}
    END

    Log    ${price}
    
    Sort List    ${price}
    Log    ${price}
    ${lowest_value}=    Get From List    ${price}    0
    Log    ${lowest_value}
    ${formatted_price}=     Evaluate    "{:,}".format(${lowest_value})
    Log    ${formatted_price}
    ${hotel_name}=  Get Text    xpath://span[@data-selenium="display-price"][.="${formatted_price}"]/ancestor::div[@data-element-name="PropertyCardBaseJacket"]//h3
    Log    The Cheapest hote is ${hotel_name} with Price Rs ${formatted_price}



