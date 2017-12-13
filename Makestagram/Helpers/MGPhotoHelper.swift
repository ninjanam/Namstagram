//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/10/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {

    // MARK: - Properties
    
    // This will be called when the user has selected a photo from UIImagePickerController
    var completionHandler: ((UIImage) -> Void)?
    
    // MARK: - Helper Methods
    
    // Takes a reference to a view controller as a reference.
    // Needed so a UIViewController to present other VCs.
    func presentActionSheet(from viewController: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?" , preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self] action in
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self] alert in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        viewController.present(imagePickerController, animated: true, completion: nil)
    }
}

extension MGPhotoHelper: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}





