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
            let rPath = relativePath
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: basePath + rPath)
        else
        {
            throw
                InvalidRelativePath(
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
