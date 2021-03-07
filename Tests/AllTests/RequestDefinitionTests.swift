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
        
        let id: String
    }
}

//---

extension RequestDefinitionTests
{
    func test_buildParameters()
    {
        let sut = UserRequestDefinition(id: "123").parameters
        
        XCTAssertEqual(sut.count, 1)
        XCTAssertTrue(sut.contains(where: { $0.key == "id" }))
        XCTAssertTrue(sut.contains(where: { ($0.value as? String) == "123" }))
    }
}
