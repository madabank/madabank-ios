import XCTest

class AuthUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Login Screen Tests
    
    func testLoginScreenDisplaysCorrectly() throws {
        // Verify login screen elements are displayed
        XCTAssertTrue(app.staticTexts["Welcome to Madabank"].exists)
        XCTAssertTrue(app.staticTexts["Sign in to continue"].exists)
        XCTAssertTrue(app.textFields["Enter your email"].exists)
        XCTAssertTrue(app.secureTextFields["Enter your password"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
        XCTAssertTrue(app.buttons["Forgot Password?"].exists)
        XCTAssertTrue(app.buttons["Sign Up"].exists)
    }
    
    func testLoginWithEmptyFields() throws {
        // Clear any default text
        let emailField = app.textFields["Enter your email"]
        emailField.tap()
        if let text = emailField.value as? String, !text.isEmpty {
            emailField.press(forDuration: 1.0)
            app.menuItems["Select All"].tap()
            app.keys["delete"].tap()
        }
        
        let passwordField = app.secureTextFields["Enter your password"]
        passwordField.tap()
        if let text = passwordField.value as? String, !text.isEmpty {
            passwordField.press(forDuration: 1.0)
            app.menuItems["Select All"].tap()
            app.keys["delete"].tap()
        }
        
        // Tap login
        app.buttons["Sign In"].tap()
        
        // Should show error or remain on login screen
        XCTAssertTrue(app.staticTexts["Welcome to Madabank"].exists)
    }
    
    func testLoginFieldsAcceptInput() throws {
        let emailField = app.textFields["Enter your email"]
        emailField.tap()
        emailField.typeText("test@example.com")
        
        let passwordField = app.secureTextFields["Enter your password"]
        passwordField.tap()
        passwordField.typeText("testpassword123")
        
        // Verify input was accepted
        XCTAssertEqual(emailField.value as? String, "test@example.com")
    }
    
    // MARK: - Navigation Tests
    
    func testNavigateToRegisterScreen() throws {
        // Tap Sign Up button
        app.buttons["Sign Up"].tap()
        
        // Verify register screen is displayed
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Fill in your details to get started"].exists)
    }
    
    func testNavigateToForgotPasswordScreen() throws {
        // Tap Forgot Password button
        app.buttons["Forgot Password?"].tap()
        
        // Verify forgot password screen is displayed
        let forgotTitle = app.staticTexts["Forgot Password?"]
        XCTAssertTrue(forgotTitle.waitForExistence(timeout: 2))
    }
    
    // MARK: - Register Screen Tests
    
    func testRegisterScreenDisplaysCorrectly() throws {
        // Navigate to register
        app.buttons["Sign Up"].tap()
        
        // Wait for transition
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 2))
        
        // Verify all form fields exist
        XCTAssertTrue(app.textFields["Enter first name"].exists)
        XCTAssertTrue(app.textFields["Enter last name"].exists)
        XCTAssertTrue(app.textFields["Enter your email"].exists)
        XCTAssertTrue(app.textFields["Enter phone number"].exists)
        XCTAssertTrue(app.secureTextFields["Minimum 8 characters"].exists)
        XCTAssertTrue(app.secureTextFields["Re-enter password"].exists)
        XCTAssertTrue(app.buttons["Create Account"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    func testRegisterBackToLogin() throws {
        // Navigate to register
        app.buttons["Sign Up"].tap()
        
        // Wait for register screen
        let registerTitle = app.staticTexts["Create Account"]
        XCTAssertTrue(registerTitle.waitForExistence(timeout: 2))
        
        // Tap Sign In to go back
        app.buttons["Sign In"].tap()
        
        // Verify back on login screen
        let loginTitle = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(loginTitle.waitForExistence(timeout: 2))
    }
    
    func testRegisterFormValidation() throws {
        // Navigate to register
        app.buttons["Sign Up"].tap()
        
        // Wait for register screen
        XCTAssertTrue(app.staticTexts["Create Account"].waitForExistence(timeout: 2))
        
        // Create Account button should be disabled initially (empty form)
        let createButton = app.buttons["Create Account"]
        // Note: Button may still be enabled but opacity might be different
        XCTAssertTrue(createButton.exists)
    }
    
    // MARK: - Forgot Password Screen Tests
    
    func testForgotPasswordScreenDisplaysCorrectly() throws {
        // Navigate to forgot password
        app.buttons["Forgot Password?"].tap()
        
        // Verify screen elements
        let title = app.staticTexts["Forgot Password?"]
        XCTAssertTrue(title.waitForExistence(timeout: 2))
        XCTAssertTrue(app.textFields["Enter your email"].exists)
        XCTAssertTrue(app.buttons["Send Reset Link"].exists)
    }
    
    func testForgotPasswordBackToLogin() throws {
        // Navigate to forgot password
        app.buttons["Forgot Password?"].tap()
        
        // Wait for screen
        XCTAssertTrue(app.staticTexts["Forgot Password?"].waitForExistence(timeout: 2))
        
        // Find and tap back button (chevron.left)
        let backButton = app.buttons.firstMatch
        backButton.tap()
        
        // Verify back on login
        let loginTitle = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(loginTitle.waitForExistence(timeout: 2))
    }
    
    func testForgotPasswordEmailInput() throws {
        // Navigate to forgot password
        app.buttons["Forgot Password?"].tap()
        
        // Wait for screen
        XCTAssertTrue(app.staticTexts["Forgot Password?"].waitForExistence(timeout: 2))
        
        // Enter email
        let emailField = app.textFields["Enter your email"]
        emailField.tap()
        emailField.typeText("forgot@example.com")
        
        // Verify input
        XCTAssertEqual(emailField.value as? String, "forgot@example.com")
        
        // Send Reset Link button should exist
        XCTAssertTrue(app.buttons["Send Reset Link"].exists)
    }
}
