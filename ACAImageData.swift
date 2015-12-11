//
//  ACAImageData.swift
//  CameraAppSwift
//
//  Created by Antti Oinaala on 27/11/14.
//  Copyright (c) 2014 Antti Oinaala. All rights reserved.
//

import UIKit


class ACAImageData: NSObject, NSCoding {
    
    var sImageDatetime: String!
    var sImageName: String!
    var imageName: String!
    var thumbnailImageName: String!
   



    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.sImageDatetime = decoder.decodeObjectForKey("datetime") as String?
        self.sImageName = decoder.decodeObjectForKey("name") as String?
        self.imageName = decoder.decodeObjectForKey("imageName") as String?
        self.thumbnailImageName = decoder.decodeObjectForKey("thumbImageName") as String?
    }

    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.sImageDatetime, forKey: "datetime")
        aCoder.encodeObject(self.sImageName, forKey: "name")
        aCoder.encodeObject(self.imageName, forKey: "imageName")
        aCoder.encodeObject(self.thumbnailImageName, forKey: "thumbImageName")
        
    }
}