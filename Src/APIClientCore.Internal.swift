//
//  APIClientCore.Internal.swift
//  MKHAPIClient
//
//  Created by Maxim Khatskevich on 2/12/17.
//  Copyright © 2017 Maxim Khatskevich. All rights reserved.
//

import Foundation

import MKHSyncSession

//===

extension APIClientCore
{
    func prepareRequest(
        _ method: HTTPMethod,
        relativePath: String,
        parameters: Parameters? = nil
        ) throws -> URLRequest
    {
        guard
            let url = URL(string: basePath + relativePath)
        else
        {
            throw
                URLCreationFailed(
                    basePath: basePath,
                    relativePath: relativePath)
        }
        
        //===
        
        var result = NSMutableURLRequest(url: url)
        
        //===
        
        result.httpMethod = method.rawValue
        
        result = onConfigureRequest(result, parameters)
        
        //===
        
        if
            let onDidPrepareRequest = onDidPrepareRequest
        {
            result = onDidPrepareRequest(result)
        }
        
        //===
        
        return result.copy() as! URLRequest
    }
    
    func dataTask(_ request: URLRequest) -> DataTaskResult
    {
        let result = session.dataTaskSync(request)
        
        //===
        
        if
            let onDidReceiveDataResponse = onDidReceiveDataResponse
        {
            onDidReceiveDataResponse(request, result)
        }
        
        //===
        
        return result
    }
}
