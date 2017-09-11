import Foundation

//===

public
extension APIClientCore
{
    // MARK: - DataTask
    
    func dataTask(
        relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskCompletion
        ) throws
    {
        let request = try prepareRequest(
            relativePath: relativePath,
            parameters: parameters
        )
        
        session.dataTask(with: request) {
            
            self.onDidReceiveDataResponse?(request, ($0, $1, $2))
            completion($0, $1, $2)
        }
        .resume()
    }
    
    func dataTaskHTTP(
        _ method: HTTPMethod,
        relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        let request = try prepareRequest(
            method,
            relativePath: relativePath,
            parameters: parameters
        )
        
        session.dataTask(with: request) {
            
            self.onDidReceiveDataResponse?(request, ($0, $1, $2))
            completion($0, $1 as? HTTPURLResponse, $2)
        }
        .resume()
    }
    
    // MARK: - HTTP helpers
    
    func get(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .get,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func post(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .post,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func put(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .put,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func patch(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .patch,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func delete(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .delete,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func head(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .head,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func trace(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .trace,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func connect(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .connect,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
    
    func options(
        _ relativePath: String,
        parameters: Parameters? = nil,
        completion: @escaping DataTaskHTTPCompletion
        ) throws
    {
        try dataTaskHTTP(
            .options,
            relativePath: relativePath,
            parameters: parameters,
            completion: completion
        )
    }
}
