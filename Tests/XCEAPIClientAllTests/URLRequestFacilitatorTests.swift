import XCTest

@testable
import XCEAPIClient

//---

final
class URLRequestFacilitatorTests: XCTestCase
{
    let sut = BasicURLRequestFacilitator(
        sharedPrefixURL: URL(string: "example.com")!
    )
}

//---

extension URLRequestFacilitatorTests
{
    func test_prepareRequest_happyPath() async throws
    {
        let request = try await sut.prepareRequest(
            .get,
            relativePath: "user",
            parameterEncoding: URLEncoding.default,
            parameters: ["id": "123"]
        )

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "example.com/user?id=123")
    }
}
