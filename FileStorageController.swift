//
//  FileStorageController.swift
//  CameraAppSwift
//
//  Created by Antti Oinaala on 28/11/14.
//  Copyright (c) 2014 Antti Oinaala. All rights reserved.
//

import UIKit



class FileStorageController: NSObject {
    var rootURL: NSURL!
    var currentImageData : ACAImageData!
    let imageDataURL : NSURL!

    
    
    override init() {
        super.init()
        let fileManager = NSFileManager.defaultManager()
        
        let paths = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask) as Array
        self.rootURL = paths[0] as NSURL
       // rootURL = NSURL (string:NSHomeDirectory())
       // rootURL = rootURL.URLByAppendingPathComponent("Documents")
        println(self.rootURL)
        
        self.imageDataURL = self.rootURL.URLByAppendingPathComponent("imageData")
        self.imageDataURL = self.imageDataURL.URLByResolvingSymlinksInPath
        
        var success = fileManager.fileExistsAtPath(self.imageDataURL.path! )
        
        
        if success {
            println("File exist at path: \(self.imageDataURL)")
        }
        
        if (!success) {
            success = fileManager.createDirectoryAtURL(self.imageDataURL, withIntermediateDirectories: false, attributes: nil, error: nil)
                if (success != true) {
                    println("Error: Cannot create directory at URL: \(self.imageDataURL). Launching terminated")
                  
                }
                
            
        }

        println("fileStorageController init")
        
    }
    
    func saveImagesWithOriginalImage (Image image: UIImage, ImageData imageData: ACAImageData ) {
        let fileManager = NSFileManager.defaultManager()
        
        let localImage = image
        var localThumbImage = localImage
        
        localThumbImage = localThumbImage.imageForScalingAndCroppingForSize(Size: CGSizeMake(140.0 , 140.0))
        
        var JPEG, thumbJPEG: NSData!
        
        JPEG = UIImageJPEGRepresentation(image, 1.0)
        thumbJPEG = UIImageJPEGRepresentation(localThumbImage, 1.0)
        
        let imageURL = self.imageDataURL.URLByAppendingPathComponent(imageData.imageName)
        let thumbImageURL = self.imageDataURL.URLByAppendingPathComponent(imageData.thumbnailImageName)
        
        if !fileManager.createFileAtPath(imageURL.path!, contents: JPEG, attributes: nil) {
            println("Couldn't create file at path:\(imageURL.path)")
        }
        
        if !fileManager.createFileAtPath(thumbImageURL.path!, contents: thumbJPEG, attributes: nil) {
            println("Couldn't create file at path:\(thumbImageURL.path)")
        }
        //println("image url: \(imageURL)")
        //println("thumb image url: \(thumbImageURL)")
        //println("saveImagesWithOriginalImage end")
        
    
        //println("Image exists at path: \(fileManager.fileExistsAtPath(imageURL.path!))")
        //println("ThumbImage exists at path: \(fileManager.fileExistsAtPath(thumbImageURL.path!))")
    }
    
    func removeImageWithURL (URL imageURL: NSURL) -> Bool {
        let fileManager = NSFileManager()
        var error: NSError? = NSError()
        
        var success = fileManager.removeItemAtURL(imageURL, error: &error)
        
        if success == false {
            println("Error when deleting image at url:\(imageURL)")
            return false
        }
        println("removeImageWithURL end")
        return true
    }
    
    
    func removeThumbnailImageWithURL (URL thumbnailImageURL: NSURL) -> Bool {
        let fileManager = NSFileManager()
        var error: NSError? = NSError()
        
        var success = fileManager.removeItemAtURL(thumbnailImageURL, error: &error)
        
        if success == false {
            println("Error when deleting image at url:\(thumbnailImageURL)")
            return false
        }
        
        println("removeThumbnailImageWithURL end")
        
        return true
    }
    
    func removeImagesWithNames (Name imageName: String, ThumbName thumbImageName: String) {
        let fileManager = NSFileManager()
        var error: NSError? = NSError()
        
        let imageURL = self.imageDataURL.URLByAppendingPathComponent(imageName)
        let thumbImageURL = self.imageDataURL.URLByAppendingPathComponent(thumbImageName)
        var success = fileManager.removeItemAtURL(imageURL, error: &error)
        if success {
            println("image removed")
        }
        
        success = fileManager.removeItemAtURL(thumbImageURL, error: &error)
        if success {
            println("thumb image removed")
        }
        
    }
    
    
    func thumbnailImage() -> UIImage? {
        var thumbImageURL: NSURL! = nil
        
        
        
        
        var contents = NSFileManager.defaultManager().contentsOfDirectoryAtURL(imageDataURL, includingPropertiesForKeys: nil, options: nil, error: nil)
        println(contents)
        
        if contents == nil {
            println("No contents")
            return nil
        }
        
        let fileURLs = contents as [NSURL]
        for URL in fileURLs {
            
            let lastComponent = URL.lastPathComponent
            
            if lastComponent == self.currentImageData.thumbnailImageName {
                thumbImageURL = URL
                break
            }
        }
        
      
        
        //println("thumb image url: \(thumbImageURL)")
        //let thumbNailUrl = NSURL .URLByAppendingPathComponent()
        let data = NSData(contentsOfURL: thumbImageURL)
        //var array = NSFileManager.defaultManager() .contentsOfDirectoryAtURL(rootURL, includingPropertiesForKeys: nil, options: nil, error: nil)
       // NSFileManager.defaultManager().createSymbolicLinkAtURL(<#url: NSURL#>, withDestinationURL: <#NSURL#>, error: <#NSErrorPointer#>)
      //  println(array)
        var image: UIImage! = nil
        
        image = UIImage(data:data!)
        
        //println("thumbnailImage end")
        return image!
    }
   
    
    func image() -> UIImage? {
        var imageURL: NSURL! = nil
        
        
        
        var contents = NSFileManager.defaultManager().contentsOfDirectoryAtURL(self.imageDataURL, includingPropertiesForKeys: nil, options: nil, error: nil)
        println(contents)
        
        if contents == nil {
          //  println("No contents")
            return nil
        }
        
        
        let fileURLs = contents as [NSURL]
        for URL in fileURLs {
            
            let lastComponent = URL.lastPathComponent
            
            if lastComponent == self.currentImageData.thumbnailImageName {
                imageURL = URL
                break
            }
        }
        
        

        
        //println("image url: \(imageURL)")
        let data = NSData(contentsOfURL: imageURL)
        
        var image: UIImage! = nil
        image = UIImage(data:data!)
        
        //println("image end")
        return image!
    }
    
    
    func dataPath() -> String {
        let fullURL = self.imageDataURL.URLByAppendingPathComponent("imageData.plist")
        //let fullURL = tmp.URLByAppendingPathExtension("dat")
        println(fullURL)
        return fullURL.path!
    }
}
