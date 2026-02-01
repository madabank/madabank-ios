import XCTest

final class AuthUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Login Screen Tests
    
    func testLoginScreenDisplaysCorrectly() throws {
        // Verify login screen elements are displayed
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        XCTAssertTrue(app.staticTexts["Sign in to continue"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
        XCTAssertTrue(app.buttons["Forgot Password?"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    func testNavigateToRegisterScreen() throws {
        // Wait for login screen
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        // Tap Sign Up button
        app.buttons["Sign Up"].tap()
        
        // Verify register screen is displayed
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 3))
    }
    
    func testNavigateToForgotPasswordScreen() throws {
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
    
    func testRegisterScreenDisplaysCorrectly() throws {
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
    
    func testRegisterBackToLogin() throws {
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
    
    func testForgotPasswordScreenDisplaysCorrectly() throws {
        // Navigate to forgot password
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5))
        
        app.buttons["Forgot Password?"].tap()
        
        // Verify screen elements
        let title = app.staticTexts["Forgot Password?"]
        XCTAssertTrue(title.waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Send Reset Link"].exists)
    }
}
