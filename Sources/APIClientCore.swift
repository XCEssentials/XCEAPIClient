import Foundation

//===

public
typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void

public
typealias DataTaskHTTPCompletion = (Data?, HTTPURLResponse?, Error?) -> Void

public
typealias DataTaskResult = (data: Data?, response: URLResponse?, error: Error?)

//public
//typealias UploadTaskResult =
//    (data: Data?, response: URLResponse?, error: NSError?)
//
//public
//typealias DownloadTaskResult =
//    (tempFile: URL?, response: URLResponse?, error: NSError?)

//===

public
typealias OnConfigureRequest = (inout URLRequest, Parameters?) throws -> Void

public
typealias OnDidPrepareRequest = (URLRequest) -> Void

public
typealias OnDidReceiveDataResponse = (URLRequest, DataTaskResult) -> Void

//===

public
protocol APIClientCore
{
    var session: URLSession { get }
    
    var basePath: String { get }
    
    var onConfigureRequest: OnConfigureRequest { get }
    
    var onDidPrepareRequest: OnDidPrepareRequest? { get }
    
    var onDidReceiveDataResponse: OnDidReceiveDataResponse? { get }
    
    init(
        basePath: String,
        onConfigureRequest: @escaping OnConfigureRequest,
        onDidPrepareRequest: OnDidPrepareRequest?,
        onDidReceiveDataResponse: OnDidReceiveDataResponse?,
        sessionConfig: URLSessionConfiguration,
        sessionDelegate: URLSessionDelegate?,
        sessionDelegateQueue: OperationQueue?
        ) throws
}

// MARK: - Internal methods

extension APIClientCore
{
    func prepareRequest(
        _ method: HTTPMethod? = nil,
        relativePath: String,
        parameters: Parameters? = nil
        ) throws -> URLRequest
    {
        guard
            let rPath = relativePath.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed
            ),
            let url = URL(string: basePath + rPath)
        else
        {
            throw InvalidRelativePath(
                basePath: basePath,
                relativePath: relativePath
            )
        }
        
        //===
        
        var result = URLRequest(url: url)
        
        result.httpMethod = method?.rawValue
        try onConfigureRequest(&result, parameters)
        onDidPrepareRequest?(result)
        
        //===
        
        return result
    }
}

