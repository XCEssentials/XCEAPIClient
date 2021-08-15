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
    
    var onEncodeRequest: OnEncodeRequest { get }
}

// MARK: - Internal methods

public
extension URLRequestFacilitator
{
    func prepareRequest(
        _ method: HTTPMethod? = nil,
        relativePath: String,
        parameters: Parameters? = nil
        ) -> Result<URLRequest, PrepareRequestIssue>
    {
        guard
            let encodedRelativePath = relativePath
                .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
        else
        {
            return .failure(.invalidRelativePath(relativePath))
        }
        
        //---
        
        var targetURL = sharedPrefixURL
        targetURL.appendPathComponent(encodedRelativePath)
        var result = URLRequest(url: targetURL)
        result.httpMethod = method?.rawValue
        
        switch onEncodeRequest(result, parameters)
        {
        case .success(let output):
            return .success(output)
            
        case .failure(let error):
            return .failure(.requestEncodingFailed(error))
        }
    }

    func prepareRequest<R: RequestDefinition>(
        for definition: R,
        toDataConverter: (R) throws -> Data = JSONEncoder().encode,
        dataToDictOptions: JSONSerialization.ReadingOptions = .init()
        ) -> Result<URLRequest, PrepareRequestIssue>
    {
        let parametersData: Data
        
        do
        {
            parametersData = try toDataConverter(definition)
        }
        catch
        {
            return .failure(.conversionIntoDataFailed(error))
        }
        
        //---
        
        let parametersObject: Any
        
        do
        {
            parametersObject = try JSONSerialization
                .jsonObject(
                    with: parametersData,
                    options: dataToDictOptions
                )
        }
        catch
        {
            return .failure(.conversionDataIntoJSONObjectFailed(error))
        }
        
        //---
        
        guard
            let parameters = parametersObject as? Parameters
        else
        {
            return .failure(.conversionJSONObjectIntoDictionaryFailed(theObject: parametersObject))
        }
        
        //---
        
        return prepareRequest(
            type(of: definition).method,
            relativePath: type(of: definition).relativePath,
            parameters: parameters
        )
    }
}
