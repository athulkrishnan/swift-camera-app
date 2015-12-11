//
//  ACAUIImageExtension.swift
//  CameraAppSwift
//
//  Created by Antti Oinaala on 28/11/14.
//  Copyright (c) 2014 Antti Oinaala. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageForScalingAndCroppingForSize (Size targetSize: CGSize) -> UIImage {
        let sourceImage = self
        var newImage: UIImage!
        
        
        
        var imageSize = sourceImage.size
        var width = imageSize.width
        var height = imageSize.height
        var targetWidth = targetSize.width
        var targetHeight = targetSize.height
        var scaleFactor: CGFloat
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPointMake(0.0, 0.0)
        
        if CGSizeEqualToSize(imageSize, targetSize) == false {
            var widthFactor = targetWidth / width
            var heightFactor = targetHeight / height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor // Scale to fit height
            } else {
                scaleFactor = heightFactor // Scale to fit width
            }
            
            // center the image
            scaledWidth = ceil(width * scaleFactor)
            scaledHeight = ceil(height * scaleFactor)
            
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else {
                if (widthFactor < heightFactor) {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize) // this will crop
        
        var thumbnailRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.drawInRect(thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return newImage
        
    }
    
    
}
