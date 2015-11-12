//
//  CameraViewController.swift
//  explosure
//
//  Created by Bernhard Eiling on 03.10.15.
//  Copyright © 2015 bernhardeiling. All rights reserved.
//

import UIKit
import GLKit

class CameraViewController: UIViewController, PhotoControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var photoSavedWrapperView: UIView!
    @IBOutlet weak var glView: GLKView?
    let cameraController: CameraController
    let documentInteractionController: UIDocumentInteractionController
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init?(coder aCoder: NSCoder) {
        cameraController = CameraController()
        documentInteractionController = UIDocumentInteractionController()
        super.init(coder: aCoder)
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange", name: UIDeviceOrientationDidChangeNotification, object: nil)
        cameraController.setupCaptureSessionWithDelegate(self)
        cameraController.glView = glView
        super.viewDidLoad()
    }
    
    @IBAction func stillImageTapRecognizerTapped(sender: UITapGestureRecognizer) {
        cameraController.captureImage()
    }
    
    func photoSavedToPhotoLibrary(savedPhoto: UIImage) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.openPhotoInInstagram(savedPhoto)
            
            self.photoSavedWrapperView.hidden = false
            self.photoSavedWrapperView.alpha = 1.0
            self.photoSavedWrapperView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            UIView.animateWithDuration(0.3, delay: 1.0, options: .CurveEaseOut, animations: { () -> Void in
                self.photoSavedWrapperView.alpha = 0.0
                self.photoSavedWrapperView.transform = CGAffineTransformIdentity
                }) { (Bool) -> Void in
                    self.photoSavedWrapperView.hidden = true
            }
        }
        
        
    }
    
    func openPhotoInInstagram(photo: UIImage) {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:"instagram://app")!) {
            let jpegImage = UIImageJPEGRepresentation(photo, 1.0)
            let homePathString = NSHomeDirectory() + "/Documents/myImage.igo";
            let homePathUrl = NSURL(fileURLWithPath: homePathString)
            do {
                try jpegImage!.writeToURL(homePathUrl, options: .DataWritingAtomic)
            } catch {
                NSLog("could not safe emp image")
            }
            
            documentInteractionController.URL = homePathUrl
            documentInteractionController.UTI = "com.instagram.exclusivegram"
            documentInteractionController.annotation = ["InstagramCaption": "etst caption"]
            documentInteractionController.delegate = self;
            documentInteractionController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)

        } else {
            NSLog("Instagram is not installed")
        }
    }
    
    func temporaryImageUrl() -> NSURL {
        let uniqueIdentifier = NSProcessInfo.processInfo().globallyUniqueString
        let picDirectory: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        let picUrl = NSURL(fileURLWithPath: picDirectory)
        return picUrl.URLByAppendingPathComponent(uniqueIdentifier + "_tempPhoto.igo")
    }
    
    func temporaryImagePathString() -> String {
        let picDirectoryString: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return picDirectoryString + "/tempDir/testImageFile.igo"
    }

    func documentInteractionController(controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        
    }
    
    func documentInteractionController(controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        
    }
    
    func deviceOrientationDidChange() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            
        }
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
	