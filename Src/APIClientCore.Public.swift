import Foundation

import MKHSyncSession

//===

public
extension APIClientCore
{
    func get(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.GET, relativePath: relativePath, parameters: parameters))
    }
    
    func post(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.POST, relativePath: relativePath, parameters: parameters))
    }
    
    func put(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.PUT, relativePath: relativePath, parameters: parameters))
    }
    
    func patch(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.PATCH, relativePath: relativePath, parameters: parameters))
    }
    
    func delete(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.DELETE, relativePath: relativePath, parameters: parameters))
    }
    
    func head(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.HEAD, relativePath: relativePath, parameters: parameters))
    }
    
    func trace(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.TRACE, relativePath: relativePath, parameters: parameters))
    }
    
    func connect(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.CONNECT, relativePath: relativePath, parameters: parameters))
    }
    
    func options(_ relativePath: String, parameters: Parameters? = nil) throws -> DataTaskResult
    {
        return try
            dataTask(
                prepareRequest(.OPTIONS, relativePath: relativePath, parameters: parameters))
    }
}
