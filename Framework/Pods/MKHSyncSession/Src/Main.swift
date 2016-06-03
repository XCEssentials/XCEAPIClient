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
    (data: NSData?, response: NSHTTPURLResponse?, error: NSError?)

public
typealias UploadTaskResult =
    (data: NSData?, response: NSURLResponse?, error: NSError?)

public
typealias DownloadTaskResult =
    (tempFile: NSURL?, response: NSURLResponse?, error: NSError?)

//===

public
extension NSURLSession
{
    /// Return data from synchronous URL request
    public
    func dataTaskSync(request: NSURLRequest) -> DataTaskResult
    {
        var result: DataTaskResult
        
        //===
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        //===
        
        self.dataTaskWithRequest(
            request,
            completionHandler: { (data, response, error) in
        
                result = (data, response as? NSHTTPURLResponse, error)
                
                //===
                
                dispatch_semaphore_signal(semaphore);
            })
            .resume()
        
        //===
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        //===
        
        return result
    }
    
    public
    func uploadTaskSync(request: NSURLRequest, fromFile fileURL: NSURL) -> UploadTaskResult
    {
        var result: UploadTaskResult
        
        //===
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        //===
        
        self.uploadTaskWithRequest(
            request,
            fromFile: fileURL,
            completionHandler: { (data, response, error) in
                
                result = (data, response, error)
                
                //===
                
                dispatch_semaphore_signal(semaphore);
            })
            .resume()
        
        //===
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        //===
        
        return result
    }
    
    public
    func uploadTaskSync(request: NSURLRequest, fromData bodyData: NSData?) -> UploadTaskResult
    {
        var result: UploadTaskResult
        
        //===
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        //===
        
        self.uploadTaskWithRequest(
            request,
            fromData: bodyData,
            completionHandler: { (data, response, error) in
                
                result = (data, response, error)
                
                //===
                
                dispatch_semaphore_signal(semaphore);
            })
            .resume()
        
        //===
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        //===
        
        return result
    }
    
    public
    func downloadTaskSync(request: NSURLRequest) -> DownloadTaskResult
    {
        var result: DownloadTaskResult
        
        //===
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        //===
        
        self.downloadTaskWithRequest(
            request,
            completionHandler: { (tempFile, response, error) in
                
                result = (tempFile, response, error)
                
                //===
                
                dispatch_semaphore_signal(semaphore);
            })
            .resume()
        
        //===
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        //===
        
        return result
    }
    
    public
    func downloadTaskSync(resumeData: NSData) -> DownloadTaskResult
    {
        var result: DownloadTaskResult
        
        //===
        
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0)
        
        //===
        
        self.downloadTaskWithResumeData(
            resumeData,
            completionHandler: { (tempFile, response, error) in
                
                result = (tempFile, response, error)
                
                //===
                
                dispatch_semaphore_signal(semaphore);
            })
            .resume()
        
        //===
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        //===
        
        return result
    }
}
