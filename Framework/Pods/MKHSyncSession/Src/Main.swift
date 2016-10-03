//
//  Main.swift
//  MKHSyncSession
//
//  Created by Maxim Khatskevich on 3/22/16.
//  Copyright © 2016 Maxim Khatskevich. All rights reserved.
//
//  Inspired by http://ericasadun.com/2015/11/12/more-bad-things-synchronous-nsurlsessions/
//  See also: https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/

//===

public
typealias DataTaskResult =
    (data: Data?, response: HTTPURLResponse?, error: NSError?)

public
typealias UploadTaskResult =
    (data: Data?, response: URLResponse?, error: NSError?)

public
typealias DownloadTaskResult =
    (tempFile: URL?, response: URLResponse?, error: NSError?)

//===

public
extension URLSession
{
    /// Return data from synchronous URL request
    public
    func dataTaskSync(_ request: URLRequest) -> DataTaskResult
    {
        var result: DataTaskResult
        
        //===
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        //===
        
        self.dataTask(
            with: request,
            completionHandler: { (data, response, error) in
        
                result = (data, response as? HTTPURLResponse, error as NSError?)
                
                //===
                
                semaphore.signal();
            })
            .resume()
        
        //===
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        //===
        
        return result
    }
    
    public
    func uploadTaskSync(_ request: URLRequest, fromFile fileURL: URL) -> UploadTaskResult
    {
        var result: UploadTaskResult
        
        //===
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        //===
        
        self.uploadTask(
            with: request,
            fromFile: fileURL,
            completionHandler: { (data, response, error) in
                
                result = (data, response, error as NSError?)
                
                //===
                
                semaphore.signal();
            })
            .resume()
        
        //===
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        //===
        
        return result
    }
    
    public
    func uploadTaskSync(_ request: URLRequest, fromData bodyData: Data?) -> UploadTaskResult
    {
        var result: UploadTaskResult
        
        //===
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        //===
        
        self.uploadTask(
            with: request,
            from: bodyData,
            completionHandler: { (data, response, error) in
                
                result = (data, response, error as NSError?)
                
                //===
                
                semaphore.signal();
            })
            .resume()
        
        //===
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        //===
        
        return result
    }
    
    public
    func downloadTaskSync(_ request: URLRequest) -> DownloadTaskResult
    {
        var result: DownloadTaskResult
        
        //===
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        //===
        
        self.downloadTask(
            with: request,
            completionHandler: { (tempFile, response, error) in
                
                result = (tempFile, response, error as NSError?)
                
                //===
                
                semaphore.signal();
            })
            .resume()
        
        //===
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        //===
        
        return result
    }
    
    public
    func downloadTaskSync(_ resumeData: Data) -> DownloadTaskResult
    {
        var result: DownloadTaskResult
        
        //===
        
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        //===
        
        self.downloadTask(
            withResumeData: resumeData,
            completionHandler: { (tempFile, response, error) in
                
                result = (tempFile, response, error as NSError?)
                
                //===
                
                semaphore.signal();
            })
            .resume()
        
        //===
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        //===
        
        return result
    }
}
