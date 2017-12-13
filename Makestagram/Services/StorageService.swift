//
//  StorageService.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/10/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService {
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
    
        guard let imageData = UIImageJPEGRepresentation(image, 0.1) else {
        return completion(nil)
        }
    
        reference.putData(imageData, metadata: nil, completion:  { (metadata, error) in
            
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            completion(metadata?.downloadURL())
        })
    }
}
