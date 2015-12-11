//
//  ACADetailViewController.swift
//  CameraAppSwift
//
//  Created by Antti Oinaala on 12/11/14.
//  Copyright (c) 2014 Antti Oinaala. All rights reserved.
//

import UIKit

protocol ACADetailViewControllerDelegate {
    func detailViewControllerDidClose(imageData: ACAImageData)
    
    
}

class ACADetailViewController: UIViewController, UISplitViewControllerDelegate {

    var masterPopoverController : UIPopoverController? = nil
    @IBOutlet weak var imageView: UIImageView!
    var delegate: ACADetailViewControllerDelegate!
    
    var imageData: ACAImageData!



    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
            
        }
    }
    
    
    var image: AnyObject? {
        didSet {
            self.configureView()
        }
    }
    
    
    
        


    func configureView() {
        // Update the user interface for the image view.
        
        if let img: AnyObject = self.image {
            if let imgView = self.imageView {
                if (self.image  != nil) {
                    self.imageView.image = img as? UIImage
                } else {
                    self.imageView.image = UIImage(named:"kuva.png")
                }
            }
        }
        
 //       self.masterPopoverController?.dismissPopoverAnimated(true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveData:")
        self.navigationItem.rightBarButtonItem = addButton;
        if self.imageData != nil {
            let fileStorageController = FileStorageController()
            fileStorageController.currentImageData = self.imageData
            
            self.image = fileStorageController.image()
        }
    }
    
    func saveData(sender: AnyObject) {
        if self.imageData == nil {
            self.createImageData()
        }
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            self.delegate .detailViewControllerDidClose(self.imageData)
            
        } else {
            self.navigationController?.popViewControllerAnimated(true)
            self.delegate .detailViewControllerDidClose(self.imageData)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createImageData() {
        let fileStorageController = FileStorageController()
        let keyGen = ACAKeyGen()
        
        self.imageData = ACAImageData()
     
        
        let date = keyGen.shortKey()
        let imageID = keyGen.key()
        var imageName = String(format: "%@", imageID)
        self.imageData.sImageName = "img"
        self.imageData.sImageDatetime = date
        self.imageData.imageName = imageName
        self.imageData.imageName = self.imageData.imageName.stringByAppendingPathExtension("JPEG")
        
        imageName = String(format: "thumb_%@", imageID)
        self.imageData.thumbnailImageName = imageName
        self.imageData.thumbnailImageName = self.imageData.thumbnailImageName.stringByAppendingPathExtension("JPEG")
        fileStorageController.saveImagesWithOriginalImage(Image: self.image! as UIImage, ImageData: self.imageData)
    }
    
    
    
    //MARK: - Split view
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        if (displayMode == UISplitViewControllerDisplayMode.PrimaryHidden) {
         //   self.masterPopoverController = svc.popoverPresentationController as? UIPopoverController
         //   self.navigationItem.setLeftBarButtonItem(svc.displayModeButtonItem(), animated: true)
        } else {
            
        }
    }
    
    
    // Deprecated
    func splitViewController(svc: UISplitViewController, willHideViewController aViewController: UIViewController, withBarButtonItem barButtonItem: UIBarButtonItem, forPopoverController pc: UIPopoverController) {
        barButtonItem.title = NSLocalizedString("Menu", tableName: nil, bundle: NSBundle.mainBundle(), value: "Menu", comment: "")
        self.navigationItem.setLeftBarButtonItem(barButtonItem, animated: true)
        self.masterPopoverController = pc as UIPopoverController
    }
    
    
    
    func splitViewController(svc: UISplitViewController, willShowViewController aViewController: UIViewController, invalidatingBarButtonItem barButtonItem: UIBarButtonItem) {
        self.navigationItem.setLeftBarButtonItem(nil , animated: true)
        self.masterPopoverController = nil
        
    }
    
  


}

