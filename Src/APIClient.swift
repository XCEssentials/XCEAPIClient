//
//  APIClient.swift
//  MKHAPIClient
//
//  Created by Maxim Khatskevich on 2/12/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

import MKHSyncSession

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
        
        if
            let onConfigureRequest = onConfigureRequest
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
