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
        
        var optionalFlag: Int? = nil
    }
}

//---

extension RequestDefinitionTests
{
    func test_buildParameters_withoutOptional()
    {
        let sut = UserRequestDefinition(id: "123").parameters
        
        XCTAssertEqual(sut.count, 1)
        XCTAssertTrue(sut.contains(where: { $0.key == "id" }))
        XCTAssertTrue(sut.contains(where: { ($0.value as? String) == "123" }))
    }
    
    func test_buildParameters_withOptional()
    {
        let sut = UserRequestDefinition(id: "123", optionalFlag: 2).parameters
        
        XCTAssertEqual(sut.count, 2)
        XCTAssertTrue(sut.contains(where: { $0.key == "id" }))
        XCTAssertTrue(sut.contains(where: { ($0.value as? String) == "123" }))
        XCTAssertTrue(sut.contains(where: { $0.key == "optionalFlag" }))
        XCTAssertTrue(sut.contains(where: { ($0.value as? Int) == 2 }))
    }
}
