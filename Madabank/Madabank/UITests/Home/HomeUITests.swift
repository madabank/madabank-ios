import XCTest

final class HomeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments += ["-uiTesting"]
        // Assuming we have a way to bypass login or we login first
        // Ideally we mock the session to start at Home
    }

    func testDashboardElementsExist() throws {
        let app = XCUIApplication()
        app.launch()
        
        // If we need to login first
        if app.buttons["Sign In"].exists {
            let emailField = app.textFields["email_input"]
            let passwordField = app.secureTextFields["password_input"]
            
            if emailField.exists {
                emailField.tap()
                emailField.typeText("test@example.com")
            }
            
            if passwordField.exists {
                passwordField.tap()
                passwordField.typeText("Password123!")
            }
            
            app.buttons["login_button"].tap()
        }
        
        // Wait for Home
        let balanceLabel = app.staticTexts["Total Balance"]
        XCTAssertTrue(balanceLabel.waitForExistence(timeout: 10))
        
        // Verify Quick Actions
        XCTAssertTrue(app.staticTexts["Quick Actions"].exists)
        XCTAssertTrue(app.staticTexts["Transfer"].exists)
        XCTAssertTrue(app.staticTexts["Pay"].exists)
        XCTAssertTrue(app.staticTexts["Top Up"].exists)
        
        // Verify Transactions
        XCTAssertTrue(app.staticTexts["Recent Transactions"].exists)
    }
}
