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

//---

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
