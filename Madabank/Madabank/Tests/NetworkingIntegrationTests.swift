import XCTest
@testable import Networking
@testable import Madabank

class NetworkingIntegrationTests: XCTestCase {
    
    func testLoginMock() async throws {
        // Given
        // Environment defaults to .dev on simulator -> Mocking enabled
        let networkManager = NetworkManager.shared
        
        // When
        // Try to perform a login request directly via NetworkManager
        // APIEndpoint.login matches "login.json"
        
        let endpoint = APIEndpoint.login(LoginRequest(email: "dev@madabank.art", password: "password123"))
        
        do {
            let response: AuthResponse = try await networkManager.request(endpoint)
            print("Successfully decoded LoginResponse: \(response)")
            XCTAssertFalse(response.token.isEmpty)
        } catch {
            XCTFail("Failed to fetch/decode login mock: \(error)")
        }
    }
    
    func testAccountBalanceMock() async throws {
        let networkManager = NetworkManager.shared
        let endpoint = APIEndpoint.getAccountBalance(id: "123")
        
        do {
            let response: AccountBalance = try await networkManager.request(endpoint)
            print("Successfully decoded AccountBalance: \(response)")
            XCTAssertEqual(response.balance, 5000.0)
        } catch {
            XCTFail("Failed to fetch/decode account balance mock: \(error)")
        }
    }
    
    func testTransactionsMock() async throws {
        let networkManager = NetworkManager.shared
        // Endpoint for recent transactions (limit 5)
        // APIEndpoint.getTransactions maps to "transactions.json"
        let request = GetTransactionsRequest(accountId: "123", limit: 5, offset: 0)
        let endpoint = APIEndpoint.getTransactions(request)
        
        do {
            let response: TransactionListResponse = try await networkManager.request(endpoint)
            print("Successfully decoded TransactionListResponse: \(response)")
            XCTAssertEqual(response.transactions.count, 2)
        } catch {
            XCTFail("Failed to fetch/decode transactions mock: \(error)")
        }
    }
    
    func testProfileMock() async throws {
        let networkManager = NetworkManager.shared
        let endpoint = APIEndpoint.getProfile
        
        do {
            let response: UserProfile = try await networkManager.request(endpoint)
            print("Successfully decoded UserProfile: \(response)")
            XCTAssertEqual(response.email, "dev@madabank.art")
        } catch {
            XCTFail("Failed to fetch/decode profile mock: \(error)")
        }
    }
}
