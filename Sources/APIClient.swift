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
struct APIClient: APIClientCore
{
    // MARK: - APIClientCore conformance
    
    public
    let session: URLSession
    
    public
    let basePath: String
    
    public
    let onConfigureRequest: OnConfigureRequest
    
    public
    let onDidPrepareRequest: OnDidPrepareRequest?
    
    public
    let onDidReceiveDataResponse: OnDidReceiveDataResponse?
    
    // MARK: - Defautls
    
    public
    static
    let onConfigureRequest: OnConfigureRequest = {
        
        try $0 = URLEncoding.default.encode($0, with: $1)
    }
    
    // MARK: - Initializers
    
    public
    init(
        basePath: String,
        onConfigureRequest: @escaping OnConfigureRequest = APIClient.onConfigureRequest,
        onDidPrepareRequest: OnDidPrepareRequest? = nil,
        onDidReceiveDataResponse: OnDidReceiveDataResponse? = nil,
        sessionConfig: URLSessionConfiguration = .default,
        sessionDelegate: URLSessionDelegate? = nil,
        sessionDelegateQueue: OperationQueue? = nil
        ) throws
    {
        guard
            URL(string: basePath) != nil
        else
        {
            throw InvalidBasePath(basePath: basePath)
        }
        
        //===
        
        self.basePath = basePath
        
        self.session = URLSession(
            configuration: sessionConfig,
            delegate: sessionDelegate,
            delegateQueue: sessionDelegateQueue
        )
        
        self.onConfigureRequest = onConfigureRequest
        self.onDidPrepareRequest = onDidPrepareRequest
        self.onDidReceiveDataResponse = onDidReceiveDataResponse
    }
}
