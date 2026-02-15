import XCTest

@MainActor
final class AuthUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting", "-reset"]
        app.launch()
    }
    
    override func tearDown() async throws {
        app = nil
    }

    
    // MARK: - Login Screen Tests
    
    func testLoginScreenDisplaysCorrectly() async throws {
        // Verify login screen elements are displayed
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        XCTAssertTrue(app.staticTexts["Sign in to continue"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
        XCTAssertTrue(app.buttons["Forgot Password?"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    func testNavigateToRegisterScreen() async throws {
        // Wait for login screen
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        // Tap Sign Up button
        app.buttons["Sign Up"].tap()
        
        // Verify register screen is displayed
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 3))
    }
    
    func testNavigateToForgotPasswordScreen() async throws {
        // Wait for login screen
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        // Tap Forgot Password button
        app.buttons["Forgot Password?"].tap()
        
        // Verify forgot password screen is displayed
        let forgotTitle = app.staticTexts["Forgot Password?"]
        XCTAssertTrue(forgotTitle.waitForExistence(timeout: 3))
    }
    
    // MARK: - Register Screen Tests
    
    func testRegisterScreenDisplaysCorrectly() async throws {
        // Navigate to register
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        app.buttons["Sign Up"].tap()
        
        // Wait for transition
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 3))
        
        // Verify Create Account button exists
        XCTAssertTrue(app.buttons["Create Account"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    func testRegisterBackToLogin() async throws {
        // Navigate to register
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        app.buttons["Sign Up"].tap()
        
        // Wait for register screen
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 3))
        
        // Tap Sign In to go back
        app.buttons["Sign In"].tap()
        
        // Verify back on login screen
        let loginTitle = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(loginTitle.waitForExistence(timeout: 3))
    }
    
    // MARK: - Forgot Password Screen Tests
    
    func testForgotPasswordScreenDisplaysCorrectly() async throws {
        // Navigate to forgot password
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        app.buttons["Forgot Password?"].tap()
        
        // Verify screen elements
        let title = app.staticTexts["Forgot Password?"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Send Reset Link"].exists)
    }
    // MARK: - Flow Tests
    
    func testLoginFlow() async throws {
        // Wait for login screen
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        let emailField = app.textFields["login_email_field"]
        let passwordField = app.secureTextFields["login_password_field"]
        
        // Enter credentials
        if emailField.exists {
            emailField.tap()
            emailField.typeText("dev@madabank.art")
        } else {
             XCTFail("Email field not found. Hierarchy: \(app.debugDescription)")
        }
        
        if passwordField.exists {
            passwordField.tap()
            passwordField.typeText("password123")
        }
        
        // Dismiss keyboard
        if app.toolbars.buttons["Done"].exists {
            app.toolbars.buttons["Done"].tap()
        } else {
            // Fallback: Tap title to dismiss keyboard
            app.staticTexts["Welcome to Madabank"].tap()
        }
        
        // Tap Login
        let signInButton = app.buttons["login_sign_in_button"]
        if signInButton.waitForExistence(timeout: 5) {
            signInButton.tap()
        } else {
            app.buttons["Sign In"].tap()
        }
        
        // Verify navigation to Home (Dashboard)
        let balanceLabel = app.staticTexts["Total Balance"]
        
        if !balanceLabel.waitForExistence(timeout: 10) {
             if app.alerts.firstMatch.exists {
                 XCTFail("Login failed with alert: \(app.alerts.firstMatch.label)")
             } else {
                 XCTFail("Dashboard 'Total Balance' not found. Hierarchy: \(app.debugDescription)")
             }
             return
        }
        
        // Verify Tab Bar exists
        XCTAssertTrue(app.tabBars.firstMatch.exists)
        
        // Navigation Checks
        let tabBar = app.tabBars.firstMatch
        if !tabBar.isHittable {
             print("TabBar not hittable. Frame: \(tabBar.frame)")
        }
        
        // Handle "Save Password" sheet if present
        let notNowButton = app.buttons["Not Now"]
        if notNowButton.waitForExistence(timeout: 5) {
            notNowButton.tap()
            // Wait for it to disappear
            let doesNotExistPredicate = NSPredicate(format: "exists == false")
            let expectation = expectation(for: doesNotExistPredicate, evaluatedWith: notNowButton, handler: nil)
            await fulfillment(of: [expectation], timeout: 5)
        }
        
        // Check window count
        print("Windows count: \(app.windows.count)")

        // Go to Cards
        let cardsButton = tabBar.buttons["Cards"]
        // Force tap using coordinates to avoid "hittable" issues if blocked by transparent window
        if cardsButton.waitForExistence(timeout: 5) {
            print("Tapping Cards button via coordinate...")
            let coordinate = cardsButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            coordinate.tap()
        } else {
             XCTFail("Cards button not found")
        }
        
        if !app.otherElements["CardsView"].waitForExistence(timeout: 10) && !app.collectionViews["CardsCollectionView"].waitForExistence(timeout: 10) {
            print("CardsView OR CollectionView not found. Hierarchy: \(app.debugDescription)")
            XCTFail("Cards View should appear")
        }
        XCTAssertTrue(app.navigationBars["My Cards"].waitForExistence(timeout: 5), "Should stay on Cards tab")
        
        // Go to Accounts
        tabBar.buttons["Accounts"].tap()
        XCTAssertTrue(app.navigationBars["Accounts"].waitForExistence(timeout: 5), "Should be on Accounts tab")
        
        // Go to History
        tabBar.buttons["History"].tap()
        XCTAssertTrue(app.navigationBars["Transaction History"].waitForExistence(timeout: 5), "Should be on History tab")
    }
}
