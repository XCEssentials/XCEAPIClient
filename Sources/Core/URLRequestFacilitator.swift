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
protocol URLRequestFacilitator
{
    var session: URLSession { get }
    
    var sharedPrefixURL: URL { get }
    
    var onConfigureRequest: OnConfigureRequest { get }
}

// MARK: - Internal methods

public
extension URLRequestFacilitator
{
    func prepareRequest(
        for definition: RequestDefinition
        ) throws -> URLRequest
    {
        try prepareRequest(
            type(of: definition).method,
            relativePath: type(of: definition).relativePath,
            parameters: definition.buildParameters()
        )
    }
    
    func prepareRequest(
        _ method: HTTPMethod? = nil,
        relativePath: String,
        parameters: Parameters? = nil
        ) throws -> URLRequest
    {
        guard
            let encodedRelativePath = relativePath.addingPercentEncoding(
                withAllowedCharacters: .urlPathAllowed
            )
        else
        {
            throw InvalidRelativePath(
                relativePath: relativePath
            )
        }
        
        //---
        
        var targetURL = sharedPrefixURL
        targetURL.appendPathComponent(encodedRelativePath)
        var result = URLRequest(url: targetURL)
        result.httpMethod = method?.rawValue
        result = try onConfigureRequest(result, parameters)
        
        //---
        
        return result
    }
}
