import XCTest

@testable
import XCEAPIClient

//---

final
class RequestDefinitionTests: XCTestCase {
    
    func testBuildParameters() {
        
        struct UserRequestDefinition: RequestDefinition {
            
            static
            let relativePath: String = "user"
            
            static
            let method: HTTPMethod? = .get
            
            let id: String
        }
        
        let sut = try! UserRequestDefinition(id: "123").buildParameters()
        
        XCTAssertEqual(sut.count, 1)
        XCTAssertTrue(sut.contains(where: { $0.key == "id" }))
        XCTAssertTrue(sut.contains(where: { ($0.value as? String) == "123" }))
    }
}
