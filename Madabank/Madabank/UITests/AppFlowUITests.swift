import XCTest

final class AppFlowUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"] // Enable mocking
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testFullAppFlow() throws {
        // 1. Login
        let welcomeText = app.staticTexts["Welcome to Madabank"]
        XCTAssertTrue(welcomeText.waitForExistence(timeout: 5), "Should start at Login screen")
        
        // Enter credentials
        let emailField = app.textFields["Email"]
        if emailField.exists {
            emailField.tap()
            emailField.typeText("user@madabank.com")
        }
        
        let passwordField = app.secureTextFields["Password"]
        if passwordField.exists {
            passwordField.tap()
            passwordField.typeText("securePass123")
        }
        
        app.buttons["Sign In"].tap()
        
        // 2. Dashboard
        let balanceLabel = app.staticTexts["Total Balance"]
        XCTAssertTrue(balanceLabel.waitForExistence(timeout: 5), "Should navigate to Dashboard")
        
        // 3. Navigate Tabs
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        
        // Go to Cards
        tabBar.buttons["Cards"].tap()
        XCTAssertTrue(app.navigationBars["My Cards"].exists, "Should stay on Cards tab")
        
        // Go to Accounts
        tabBar.buttons["Accounts"].tap()
        XCTAssertTrue(app.navigationBars["Accounts"].exists, "Should be on Accounts tab")
        
        // Go to History
        tabBar.buttons["History"].tap()
        XCTAssertTrue(app.navigationBars["Transaction History"].exists, "Should be on History tab")
        
        // 4. Logout (Assuming Profile/Settings is accessible from Home or internal mechanism)
        // If Logout is in Profile, we need to find how to get there.
        // Usually top left or right on Home.
        // Let's go back to Home first
        tabBar.buttons["Home"].tap()
        
        // Check for Profile button/avatar
        // Assuming identifiers from HomeViewController
        let profileButton = app.buttons["profile_button"] 
        if profileButton.exists {
            profileButton.tap()
            
            // In Profile, look for Settings or Logout
            // Assuming Profile has Settings button or direct Logout
            if app.buttons["Settings"].exists {
                app.buttons["Settings"].tap()
            }
            
            let logoutButton = app.buttons["Log Out"]
            if logoutButton.waitForExistence(timeout: 2) {
                logoutButton.tap()
                
                // Confirm logout if alert exists
                if app.alerts.firstMatch.exists {
                     app.alerts.firstMatch.buttons["Log Out"].tap()
                }
                
                // Verify back at Login
                XCTAssertTrue(welcomeText.waitForExistence(timeout: 5), "Should return to Login screen")
            }
        }
    }
}
