import XCTest

@MainActor
final class HomeUITests: XCTestCase {



    func testDashboardElementsExist() async throws {
        let app = XCUIApplication()
        app.launch()
        
        // If we need to login first
        if app.buttons["login_sign_in_button"].exists || app.buttons["Sign In"].exists {
            let emailField = app.textFields["login_email_field"]
            let passwordField = app.secureTextFields["login_password_field"]
            
            if emailField.exists {
                emailField.tap()
                emailField.typeText("dev@madabank.art")
            }
            
            if passwordField.exists {
                passwordField.tap()
                passwordField.typeText("password123")
            }
            
            if app.buttons["login_sign_in_button"].exists {
                app.buttons["login_sign_in_button"].tap()
            } else {
                app.buttons["Sign In"].tap()
            }
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
