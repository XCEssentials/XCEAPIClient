/*

 MIT License

 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

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
