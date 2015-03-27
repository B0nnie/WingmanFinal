//
//  File.swift
//  Wingman
//
//  Created by William McDuff on 2015-03-26.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import Foundation
//import AFAmazonS3Manager

let s3URL = "https://s3.amazonaws.com/BUCKET/"

private let _S3Model = S3()

let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

class S3 {
    
    class func model() -> S3 { return _S3Model }
    
    var s3Manager: AFAmazonS3Manager {
        
        let manager = AFAmazonS3Manager(accessKeyID: "AKIAIVV7LIB77YFJ4N2A", secret: "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")
        manager.requestSerializer.region = AFAmazonS3USStandardRegion
        manager.requestSerializer.bucket = "wingmen"
        return manager
        
    }
    
    func getVideoWithID(objectId: String, completion: (() -> ())?) {
        
        let filePath = "FILE_PATH"
        
        if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
            
            if let c = completion { c() }
            
        }
        
        // if timestamp of update then delete and redownload ... TODO
        NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
        
        let outputStream = NSOutputStream(toFileAtPath: filePath, append: false)
        
       // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 1)), dispatch_get_main_queue()) { () -> Void in
            
            self.s3Manager.getObjectWithPath(filePath, outputStream: outputStream, progress: { (bytesRead, totalBytesRead, totalBytesExpectedToRead) -> Void in
                
                //                println("\(Int(CGFloat(totalBytesRead) / CGFloat(totalBytesExpectedToRead) * 100.0))% Downloaded")
                
                }, success: { (responseObject) -> Void in
                    
                    println("video saved")
                    
                    if let c = completion { c() }
                    
                }) { (error) -> Void in
                    
            }
            
        //}
        
        
    }
    
}
