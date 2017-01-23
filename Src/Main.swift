//
//  Main.swift
//  MKHAPIClient
//
//  Created by Maxim Khatskevich on 3/23/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//
//  Inspired by https://thatthinginswift.com/write-your-own-api-clients-swift/

import MKHSyncSession

//===

public
enum HTTPHeaderFieldName: String
{
    case
        Authorization,
        ContentType = "Content-Type"
}

//===

public
enum ContentType: String
{
    case
        FormURLEncoded = "application/x-www-form-urlencoded"
}

//===

public
enum HTTPMethod: String
{
    case
        GET,
        POST,
        PUT,
        PATCH,
        DELETE,
        HEAD,
        TRACE,
        CONNECT,
        OPTIONS
}

//===

public
typealias Parameters = [String: Any]

//===

public
typealias OnConfigureRequestBlock = (NSMutableURLRequest, Parameters?) -> NSMutableURLRequest

public
typealias OnDidPrepareRequestBlock = (NSMutableURLRequest) -> NSMutableURLRequest

public
typealias OnDidReceiveDataResponseBlock = (URLRequest, DataTaskResult) -> Void

public
protocol APIClientCore
{
    var session: URLSession { get }
    
    var basePath: String { get }
    
    var onConfigureRequest: OnConfigureRequestBlock { get }
    
    var onDidPrepareRequest: OnDidPrepareRequestBlock? { get }
    
    var onDidReceiveDataResponse: OnDidReceiveDataResponseBlock? { get }
    
    init(
        basePath: String,
        onConfigureRequest: OnConfigureRequestBlock?,
        onDidPrepareRequest: OnDidPrepareRequestBlock?,
        onDidReceiveDataResponse: OnDidReceiveDataResponseBlock?,
        sessionConfig: URLSessionConfiguration?,
        sessionDelegate: URLSessionDelegate?,
        sessionDelegateQueue: OperationQueue?)
}

//===

public
extension APIClientCore // common functionality
{
    fileprivate
    func prepareRequest(
        _ method: HTTPMethod,
        relativePath: String,
        parameters: Parameters? = nil) -> URLRequest
    {
        var result =
            NSMutableURLRequest(url:
                URL(string: basePath + relativePath)!)
        
        //===
        
        result.httpMethod = method.rawValue
        
        result = onConfigureRequest(result, parameters)
        
        //===
        
        if let onDidPrepareRequest = onDidPrepareRequest
        {
            result = onDidPrepareRequest(result)
        }
        
        //===
        
        return result.copy() as! URLRequest
    }
    
    fileprivate
    func dataTask(_ request: URLRequest) -> DataTaskResult
    {
        let result = session.dataTaskSync(request)
        
        //===
        
        if let onDidReceiveDataResponse = onDidReceiveDataResponse
        {
            onDidReceiveDataResponse(request, result)
        }
        
        //===
        
        return result
    }
    
    //=== Public members
    
    public
    func get(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.GET, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func post(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.POST, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func put(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.PUT, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func patch(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.PATCH, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func delete(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.DELETE, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func head(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.HEAD, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func trace(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.TRACE, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func connect(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.CONNECT, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func options(_ relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.OPTIONS, relativePath: relativePath, parameters: parameters))
    }
}

//===

public
struct APIClient: APIClientCore
{
    //=== APIClient conformance - Public read-only members
    
    public
    let session: URLSession
    
    public
    let basePath: String
    
    //=== APIClient conformance - Public members
    
    public
    let onConfigureRequestDefault: OnConfigureRequestBlock =
    {
        return ParameterEncoding.url.encode($0, parameters: $1).request
    }
    
    public
    let onConfigureRequest: OnConfigureRequestBlock
    
    public
    let onDidPrepareRequest: OnDidPrepareRequestBlock?
    
    public
    let onDidReceiveDataResponse: OnDidReceiveDataResponseBlock?
    
    public
    init(
        basePath: String,
        onConfigureRequest: OnConfigureRequestBlock? = nil,
        onDidPrepareRequest: OnDidPrepareRequestBlock? = nil,
        onDidReceiveDataResponse: OnDidReceiveDataResponseBlock? = nil,
        sessionConfig: URLSessionConfiguration? = nil,
        sessionDelegate: URLSessionDelegate? = nil,
        sessionDelegateQueue: OperationQueue? = nil)
    {
        self.basePath = basePath
        
        //===
        
        // even if a 'nil' has been passed - we need a non-nil value,
        // so we will use defaul configuration
        
        let config = sessionConfig ?? URLSessionConfiguration.default
        
        //===
        
        if
            let sessionDelegate = sessionDelegate,
            let sessionDelegateQueue = sessionDelegateQueue
        {
            session = URLSession(
                configuration: config,
                delegate: sessionDelegate,
                delegateQueue: sessionDelegateQueue)
        }
        else
        {
            session = URLSession(configuration: config)
        }
        
        //===
        
        if let onConfigureRequest = onConfigureRequest
        {
            self.onConfigureRequest = onConfigureRequest
        }
        else
        {
            self.onConfigureRequest = onConfigureRequestDefault
        }
        
        //===
        
        self.onDidPrepareRequest = onDidPrepareRequest
        self.onDidReceiveDataResponse = onDidReceiveDataResponse
    }
}
