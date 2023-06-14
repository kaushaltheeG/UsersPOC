//
//  ContentView_UITest.swift
//  UsersPOC_UITests
//
//  Created by Kaushal Kumbagowdana on 6/14/23.
//

import XCTest

final class ContentView_UITest: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ContentView_ChatWithUserNavLink_shouldNavigateToUserIndexView() {

        let chatHomeNavBar = app.navigationBars["Chat Home"]
        XCTAssertNotNil(chatHomeNavBar)
        chatHomeNavBar.tap()
        
        let chatWithUserNavLink = app.buttons["navigationToUsersIndex"]
        XCTAssertNotNil(chatWithUserNavLink)
        chatWithUserNavLink.tap()
        
        let usersIndexNavigationBar = app.navigationBars["Users"]
        XCTAssertNotNil(usersIndexNavigationBar)
        XCTAssertFalse(chatWithUserNavLink.exists)
        usersIndexNavigationBar.tap()
        XCTAssertTrue(usersIndexNavigationBar.exists)
        
        // move back to content view
        usersIndexNavigationBar.buttons["Chat Home"].tap()
        XCTAssertFalse(usersIndexNavigationBar.exists)
        XCTAssertTrue(chatWithUserNavLink.exists)
        
        
    }
    
    func test_ContentView_showAlertButton_shouldDisplayAlert() {
        
        // When
        tapAlertButton(shouldDismssAlert: false)
        
        // Then
        let alert = app.alerts.firstMatch // finds the first alert instead of basing it on alert text
        XCTAssertTrue(alert.exists) // alert should appear
    }
    
    func test_ContentView_showAlertButton_shouldDisplayAlertandDismissAlert() {

        // When
        tapAlertButton(shouldDismssAlert: true)
        
        // Then
        let doesAlertExist = app.alerts.firstMatch.waitForExistence(timeout: 5)
        XCTAssertFalse(doesAlertExist) // should not exists after clicking
    }
    
    
    // Helper
    func tapAlertButton(shouldDismssAlert: Bool) {
        let alertButton = app.buttons["showAlertButton"]
        alertButton.tap()
        
        if shouldDismssAlert {
            let alert = app.alerts.firstMatch // finds the first alert instead of basing it on alert text
            let alertOkButton = alert.buttons["OK"]
            let alertOkButtonExists = alertOkButton.waitForExistence(timeout: 5) // waits up to 5 seconds for element to exists; better than using sleep(1)
            XCTAssertTrue(alertOkButtonExists)
            
            alertOkButton.tap()
        }
    }
    
    
}
