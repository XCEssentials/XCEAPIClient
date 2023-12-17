import XCTest

@testable
import XCEAPIClient

//---

final
class RequestDefinitionTests: XCTestCase
{
    struct UserRequestDefinition: RequestDefinition
    {
        static
        let relativePath: String = "user"
        
        static
        let method: HTTPMethod? = .get
        
        static
        let parameterEncoding: ParameterEncoding = URLEncoding.default
        
        let id: String
        
        var optionalFlag: Int? = nil
    }
    
    var facilitator: URLRequestFacilitator!
    
    override func setUp() {
        super.setUp()
        facilitator = BasicURLRequestFacilitator(sharedPrefixURL: .init(string: "host.com")!)
    }
    
    override func tearDown() {
        facilitator = nil
        super.tearDown()
    }
}

//---

extension RequestDefinitionTests
{
    func test_buildParameters_withoutOptional() async throws
    {
        let definition = UserRequestDefinition(id: "123")
        let request = try await facilitator.prepareRequest(from: definition)
        let components = URLComponents(string: request.url!.absoluteString)!
        let sut = components.queryItems!
        
        XCTAssertEqual(sut.count, 1)
        XCTAssertTrue(sut.contains(where: { $0.name == "id" && $0.value == "123" }))
    }
    
    func test_buildParameters_withOptional() async throws
    {
        let definition = UserRequestDefinition(id: "123", optionalFlag: 22)
        let request = try await facilitator.prepareRequest(from: definition)
        let components = URLComponents(string: request.url!.absoluteString)!
        let sut = components.queryItems!
        
        XCTAssertEqual(sut.count, 2)
        XCTAssertTrue(sut.contains(where: { $0.name == "id" && $0.value == "123" }))
        XCTAssertTrue(sut.contains(where: { $0.name == "optionalFlag" && $0.value == "22" }))
    }
}
