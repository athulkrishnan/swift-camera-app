//
//  ACAMasterViewController.swift
//  CameraAppSwift
//
//  Created by Antti Oinaala on 12/11/14.
//  Copyright (c) 2014 Antti Oinaala. All rights reserved.
//

import UIKit

class ACAMasterViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, ACADetailViewControllerDelegate {

    var detailViewController: ACADetailViewController? = nil
    var objects: NSMutableArray! = NSMutableArray()
    var pickedImage = UIImage()
    var fileStorageController = FileStorageController()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
        
        
        println("Awake from Nib")
        
    }
    
   

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

     
        let addButton = UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "takePicture:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? ACADetailViewController
        }
        
        var fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(self.fileStorageController.dataPath()) {
            
            println("Unarchive objects from URL: \(self.fileStorageController.imageDataURL)")
            let exists = NSFileManager.defaultManager().fileExistsAtPath(self.fileStorageController.imageDataURL.path! ) as Bool
            var URL = self.fileStorageController.imageDataURL.URLByAppendingPathComponent("imageData.plist")
            if NSKeyedUnarchiver.unarchiveObjectWithFile(URL.path!) != nil {
                self.objects =  NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileStorageController.dataPath()) as NSMutableArray
            } else {
                println("No archived data")
            }
      
    
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        self.objects.insertObject(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func takePicture(sender: AnyObject) {
        
        
        
 
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            /*
            if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad) {
                
            } else
                */
            
            if  ((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
                func cancel(act:UIAlertAction!) {
                    
                }
                
                func camera (act:UIAlertAction!) {
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerControllerSourceType.Camera;
                    picker.delegate = self
                    
                    self.presentViewController(picker, animated: true, completion: nil)
                }
                
                func photoAlbum (act:UIAlertAction!) {
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    picker.delegate = self
                    
                    self.presentViewController(picker, animated: true, completion: nil)
                }
           
                let alertController = UIAlertController(title: "Source Type", message:nil , preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancel)
                let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: camera)
                let photoAlbumAction = UIAlertAction (title: "Photo Album", style: .Default, handler: photoAlbum)
                
                alertController.addAction(cancelAction)
                alertController.addAction(cameraAction)
                alertController.addAction(photoAlbumAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
                
            }
            
            else {
                // Old iOS versions
                var actionSheet :UIActionSheet! = nil
                actionSheet = UIActionSheet(title: "Source Type", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Camera", otherButtonTitles:"Album")
                actionSheet.showInView(self.view?);
            }
            
            
        } else {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            picker.delegate = self
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            println("ViewController: \(segue.destinationViewController)")
            
         
            let controller = segue.destinationViewController as ACADetailViewController
            
            //controller.navigationItem.leftBarButtonItem =
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            controller.delegate = self
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let imageData = self.objects[indexPath.row] as ACAImageData

                controller.imageData = imageData
                
                
                
                

            } else {
                // Set picked image
                controller.image = self.pickedImage
                
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        self.fileStorageController.currentImageData = objects[indexPath.row] as ACAImageData
        
        let fileManager = NSFileManager.defaultManager()
        println("contentsOfPath: \(fileManager.contentsAtPath(self.fileStorageController.rootURL.path!))")

       cell.imageView?.image = self.fileStorageController.thumbnailImage()
        cell.textLabel?.text = self.fileStorageController.currentImageData.sImageDatetime
        cell.detailTextLabel?.text = self.fileStorageController.currentImageData.sImageName
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let imageData = self.objects.objectAtIndex(indexPath.row) as ACAImageData
            self.fileStorageController.removeImagesWithNames(Name: imageData.imageName, ThumbName: imageData.thumbnailImageName)
            self.objects.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.updateArchive()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

   // MARK: - Image picker delegate
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.pickedImage = image
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            self.detailViewController?.image = self.pickedImage
        } else {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    // MARK: - detail view controller delegate
    func detailViewControllerDidClose(imageData: ACAImageData) {
        self.objects.insertObject(imageData, atIndex: 0)
       
        self.updateArchive()
        
        var aIndexPath = NSArray(object: NSIndexPath(forRow: 0, inSection: 0))
        self.tableView.insertRowsAtIndexPaths(aIndexPath, withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    func updateArchive() {
        
        let exists = NSFileManager.defaultManager().fileExistsAtPath(self.fileStorageController.imageDataURL.path! ) as Bool
        var URL = self.fileStorageController.imageDataURL.URLByAppendingPathComponent("imageData.plist")
        println("File exist at path: \( URL.path )")
        if !NSKeyedArchiver.archiveRootObject(self.objects, toFile: URL.path!) {
            println("Couldn't archive imageData collection")
        } else {
            println("Data: \(self.objects) archived at URL: \(self.fileStorageController.imageDataURL)")
        }
    }
    
   // MARK: - Action sheet delegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            println("Cancel")
        }
        
        else if buttonIndex == 0 {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            picker.delegate = self
            
            self.presentViewController(picker, animated: true, completion: nil)
        } else if buttonIndex == 2 {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            picker.delegate = self
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
}



