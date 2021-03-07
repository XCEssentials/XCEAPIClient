import XCTest

@testable
import XCEAPIClient

//---

final
class URLRequestFacilitatorTests: XCTestCase
{
    let facilitator = BasicURLRequestFacilitator(
        sharedPrefixURL: URL(string: "example.com")!
    )
}

//---

extension URLRequestFacilitatorTests
{
    func test_prepareRequest_happyPath()
    {
        let sut = facilitator.prepareRequest(
            .get,
            relativePath: "user",
            parameters: ["id": "123"]
        )
        
        switch sut
        {
        case .success(let request):
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.url?.absoluteString, "example.com/user?id=123")
            
        default:
            XCTFail("Expected a success")
        }
    }
}
