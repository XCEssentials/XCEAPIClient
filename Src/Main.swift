//
//  Main.swift
//  MKHCustomAPI
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
protocol APIClientCore
{
    static
    var session: NSURLSession! { get }
    
    static
    var basePath: String! { get }
    
    static
    var onConfigureRequest: (NSMutableURLRequest, Parameters?) -> NSMutableURLRequest { get }
    
    static
    var onDidPrepareRequest: (NSMutableURLRequest) -> NSMutableURLRequest { get }
    
    static
    var onDidReceiveDataResponse: (NSURLRequest, DataTaskResult) -> Void { get }
    
    // call this method before start using the class
    // handle initial configuration here
    static
    func configure(
        basePath: String,
        sessionConfig: NSURLSessionConfiguration,
        sessionDelegate: NSURLSessionDelegate?,
        sessionDelegateQueue queue: NSOperationQueue?)
}

//===

public
extension APIClientCore // common functionality
{
    private
    static
    func prepareRequest(
        method: HTTPMethod,
        relativePath: String,
        parameters: Parameters? = nil) -> NSURLRequest
    {
        var result =
            NSMutableURLRequest(URL:
                NSURL(string: Self.basePath + relativePath)!)
        
        //===
        
        result.HTTPMethod = method.rawValue
        
        result = onConfigureRequest(result, parameters)
        result = onDidPrepareRequest(result)
        
        //===
        
        return result.copy() as! NSURLRequest
    }
    
    private
    static
    func dataTask(request: NSURLRequest) -> DataTaskResult
    {
        let result = session.dataTaskSync(request)
        
        //===
        
        onDidReceiveDataResponse(request, result)
        
        //===
        
        return result
    }
    
    //=== Public members
    
    public
    static
    func get(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.GET, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func post(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.POST, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func put(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.PUT, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func patch(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.PATCH, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func delete(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.DELETE, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func head(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.HEAD, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func trace(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.TRACE, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func connect(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.CONNECT, relativePath: relativePath, parameters: parameters))
    }
    
    public
    static
    func options(relativePath: String, parameters: Parameters? = nil) -> DataTaskResult
    {
        return
            Self.dataTask(
                Self.prepareRequest(.OPTIONS, relativePath: relativePath, parameters: parameters))
    }
}

//===

public
final
class API: NSObject, APIClientCore
{
    //=== APIClient conformance - Public read-only members
    
    public /*but*/ private(set)
    static
    var session: NSURLSession!
    
    public /*but*/ private(set)
    static
    var basePath: String!
    
    //=== APIClient conformance - Public members
    
    public
    static
    var onConfigureRequest: (NSMutableURLRequest, Parameters?) -> NSMutableURLRequest =
    {
        return ParameterEncoding.URL.encode($0, parameters: $1).request
    }
    
    public
    static
    var onDidPrepareRequest: (NSMutableURLRequest) -> NSMutableURLRequest = { return $0 }
    
    public
    static
    var onDidReceiveDataResponse: (NSURLRequest, DataTaskResult) -> Void = { (_, _) in }
    
    public
    class
    final
    func configure(
        basePath: String,
        sessionConfig: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration(),
        sessionDelegate: NSURLSessionDelegate? = nil,
        sessionDelegateQueue: NSOperationQueue? = nil)
    {
        API.basePath = basePath
        
        //===
        
        if
            let sessionDelegate = sessionDelegate,
            let sessionDelegateQueue = sessionDelegateQueue
        {
            session = NSURLSession(
                configuration: sessionConfig,
                delegate: sessionDelegate,
                delegateQueue: sessionDelegateQueue)
        }
        else
        {
            session = NSURLSession(configuration: sessionConfig)
        }
    }
}
