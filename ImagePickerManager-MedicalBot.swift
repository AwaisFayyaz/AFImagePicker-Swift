//
//  ImagePickerManager.swift
//  Medical Bot
//
//  Created by BugDev Studios on 01/11/2018.
//  Copyright © 2018 BugDev Studios. All rights reserved.
//

import Foundation
import UIKit


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var picker = UIImagePickerController();
  var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
  var viewController: UIViewController?
  var pickImageCallback : ( (UIImage) -> () )?
  
  override init(){
    super.init()
    
    let cameraAction = UIAlertAction(title: "Camera", style: .default){
      UIAlertAction in
      self.openCamera()
    }
    let gallaryAction = UIAlertAction(title: "Gallery", style: .default){
      UIAlertAction in
      self.openGallery()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
      UIAlertAction in
    }
    
    // Add the actions
    picker.delegate = self
//    alert.addAction(cameraAction)
    alert.addAction(gallaryAction)
    alert.addAction(cancelAction)
    
  }
  
  func pickImage(_ viewController: UIViewController, button: UIButton, _ callback: @escaping ((UIImage) -> ())) {
    
    pickImageCallback = callback;
    self.viewController = viewController;
    
    alert.popoverPresentationController?.sourceView = button
    viewController.present(alert, animated: true, completion: nil)
    
  }
  
  func openCamera(){
    
    alert.dismiss(animated: true, completion: nil)
    if(UIImagePickerController .isSourceTypeAvailable(.camera)){
      picker.sourceType = .camera
      self.viewController!.present(picker, animated: true, completion: nil)
    } else {
      self.viewController?.showAlert(title: "Warning", message: "You dan't have camera", okButtonTitle: "OK")
      
      
    }
  }
  func openGallery(){
    alert.dismiss(animated: true, completion: nil)
    picker.sourceType = .photoLibrary
    self.viewController!.present(picker, animated: true, completion: nil)
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    pickImageCallback?(image)
  }
  
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
  }
  
}
