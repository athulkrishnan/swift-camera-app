//
//  ACAKeyGen.swift
//  CameraAppSwift
//
//  Created by Antti Oinaala on 27/11/14.
//  Copyright (c) 2014 Antti Oinaala. All rights reserved.
//

import UIKit


class ACAKeyGen: NSObject {
    
 

    
    func key() -> String {
       
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmss"
        println(dateFormatter.stringFromDate(NSDate() ))
        
        return dateFormatter.stringFromDate(NSDate())
    }
    
    
    func shortKey() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        println(dateFormatter.stringFromDate(NSDate() ))
        
        return dateFormatter.stringFromDate(NSDate())
    }
    
}
