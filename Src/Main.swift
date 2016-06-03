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
typealias Parameters = [String: AnyObject]

//===

public
typealias OnConfigureRequestBlock = (NSMutableURLRequest, Parameters?) -> NSMutableURLRequest

public
typealias OnDidPrepareRequestBlock = (NSMutableURLRequest) -> NSMutableURLRequest

public
typealias OnDidReceiveDataResponseBlock = (NSURLRequest, DataTaskResult) -> Void

public
protocol APIClientCore
{
    var session: NSURLSession { get }
    
    var basePath: String { get }
    
    var onConfigureRequest: OnConfigureRequestBlock { get }
    
    var onDidPrepareRequest: OnDidPrepareRequestBlock? { get }
    
    var onDidReceiveDataResponse: OnDidReceiveDataResponseBlock? { get }
    
    init(
        basePath: String,
        onConfigureRequest: OnConfigureRequestBlock?,
        onDidPrepareRequest: OnDidPrepareRequestBlock?,
        onDidReceiveDataResponse: OnDidReceiveDataResponseBlock?,
        sessionConfig: NSURLSessionConfiguration?,
        sessionDelegate: NSURLSessionDelegate?,
        sessionDelegateQueue: NSOperationQueue?)
}

//===

public
extension APIClientCore // common functionality
{
    private
    func prepareRequest(
        method: HTTPMethod,
        relativePath: String,
        parameters: Parameters? = nil) -> NSURLRequest
    {
        var result =
            NSMutableURLRequest(URL:
                NSURL(string: basePath + relativePath)!)
        
        //===
        
        result.HTTPMethod = method.rawValue
        
        result = onConfigureRequest(result, parameters)
        
        //===
        
        if let onDidPrepareRequest = onDidPrepareRequest
        {
            result = onDidPrepareRequest(result)
        }
        
        //===
        
        return result.copy() as! NSURLRequest
    }
    
    private
    func dataTask(request: NSURLRequest) -> DataTaskResult
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
    func get(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.GET, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func post(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.POST, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func put(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.PUT, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func patch(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.PATCH, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func delete(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.DELETE, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func head(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.HEAD, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func trace(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.TRACE, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func connect(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            dataTask(
                prepareRequest(.CONNECT, relativePath: relativePath, parameters: parameters))
    }
    
    public
    func options(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
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
    let session: NSURLSession
    
    public
    let basePath: String
    
    //=== APIClient conformance - Public members
    
    public
    let onConfigureRequestDefault: OnConfigureRequestBlock =
    {
        return ParameterEncoding.URL.encode($0, parameters: $1).request
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
        sessionConfig: NSURLSessionConfiguration? = NSURLSessionConfiguration.defaultSessionConfiguration(),
        sessionDelegate: NSURLSessionDelegate? = nil,
        sessionDelegateQueue: NSOperationQueue? = nil)
    {
        self.basePath = basePath
        
        //===
        
        if
            let sessionDelegate = sessionDelegate,
            let sessionDelegateQueue = sessionDelegateQueue
        {
            session = NSURLSession(
                configuration: sessionConfig!,
                delegate: sessionDelegate,
                delegateQueue: sessionDelegateQueue)
        }
        else
        {
            session = NSURLSession(configuration: sessionConfig!)
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
