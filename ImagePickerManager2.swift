//
//  ImagePickerManager.swift
//  Medical Bot
//
//  Created by BugDev Studios on 01/11/2018.
//  Copyright © 2018 BugDev Studios. All rights reserved.
//

import AVFoundation
import UIKit

enum PickImageSourceType {
  case camera
  case gallery
}
class ImagePickerManager: NSObject {
  
  var picker = UIImagePickerController()
  var viewController: UIViewController?
  var pickImageCallback : ( (UIImage) -> () )?
  
  override init(){
    super.init()
    
    
  }
 
  //MARK:- FUNCTIONS
  func pickImage(_ viewController: UIViewController, button: UIButton, sourceType: PickImageSourceType, _ callback: @escaping ((UIImage) -> ())) {
    
    picker.delegate = self
    pickImageCallback = callback
    self.viewController = viewController
    
    switch sourceType {
      
    case .camera:
      handleCamera()
      
    case .gallery:
      
      guard UIImagePickerController .isSourceTypeAvailable(.photoLibrary) else { viewController.showToast(message: "You don't have Photo Library"); return  }
      picker.sourceType = .photoLibrary
      
    }
    
    
  }
  
}

extension ImagePickerManager : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    print("didFinishPickingMediaWithInfo")
    pickImageCallback?(image)
    picker.dismiss(animated: true, completion: nil)
    
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    TBprint("user picked image: \(pickedImage as Any)")
  }
  
}

extension ImagePickerManager {
  
  
  func handleCamera() {
    
    //camera available ?
    guard UIImagePickerController .isSourceTypeAvailable(.camera) else { viewController?.showToast(message: "You don't have camera"); return  }
    
    //authorized to use camera?
    
    let cameraMediaType = AVMediaType.video
    let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
    
    //    var permissionAvailable = false
    
    switch cameraAuthorizationStatus {
    case .authorized:
      showCameraPicker()
    case .denied:
      alertPromptToAllowCameraAccessViaSettings()
    case .notDetermined:
      permissionPrimeCameraAccess()
    default:
      permissionPrimeCameraAccess()
    }
    
    
  }
  
  func alertPromptToAllowCameraAccessViaSettings() {
    let alert = UIAlertController(title: "TextBehind Would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can take your profile picture.", preferredStyle: .alert )
    alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
      
      if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(appSettingsURL)
        } else {
          UIApplication.shared.openURL(appSettingsURL)
        }
      }
    })
    
    viewController?.present(alert, animated: true, completion: nil)
  }
  
  
  func permissionPrimeCameraAccess() {
    let alert = UIAlertController( title: "TextBehind Would Like To Access the Camera", message: "TextBehind would like to access your Camera so that you can Take your profile picture.", preferredStyle: .alert )
    
    let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
      
      if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self] granted in
          DispatchQueue.main.async {
            self?.handleCamera()
          }
        })
      }
    })
    alert.addAction(allowAction)
    let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
    
    }
    alert.addAction(declineAction)
    viewController?.present(alert, animated: true, completion: nil)
  }
  
  
  func showCameraPicker() {
    
//    picker.delegate = self
//    picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
    picker.allowsEditing = false
    picker.sourceType = .camera
    viewController?.present(picker, animated: true, completion: nil)
  }
  
}
