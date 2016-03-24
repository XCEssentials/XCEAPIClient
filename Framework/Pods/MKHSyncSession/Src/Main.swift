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
    (data: NSData?, response: NSURLResponse?, error: NSError?)

public
typealias UploadTaskResult = DataTaskResult

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

extension NSURLSession {
    /*
     * data task convenience methods.  These methods create tasks that
     * bypass the normal delegate calls for response and data delivery,
     * and provide a simple cancelable asynchronous interface to receiving
     * data.  Errors will be returned in the NSURLErrorDomain,
     * see <Foundation/NSURLError.h>.  The delegate, if any, will still be
     * called for authentication challenges.
     */
//    public func dataTaskWithRequest(request: NSURLRequest, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
//    public func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
//    
//    /*
//     * upload convenience method.
//     */
//    public func uploadTaskWithRequest(request: NSURLRequest, fromFile fileURL: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionUploadTask
//    public func uploadTaskWithRequest(request: NSURLRequest, fromData bodyData: NSData?, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionUploadTask
//    
//    /*
//     * download task convenience methods.  When a download successfully
//     * completes, the NSURL will point to a file that must be read or
//     * copied during the invocation of the completion routine.  The file
//     * will be removed automatically.
//     */
//    public func downloadTaskWithRequest(request: NSURLRequest, completionHandler: (NSURL?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDownloadTask
//    public func downloadTaskWithURL(url: NSURL, completionHandler: (NSURL?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDownloadTask
//    public func downloadTaskWithResumeData(resumeData: NSData, completionHandler: (NSURL?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDownloadTask
}
