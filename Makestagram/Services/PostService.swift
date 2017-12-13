//
//  PostService.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/10/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func create(for image: UIImage) {
        
        let imageRef = StorageReference.newPostImageReference()
        
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    // write a new Post object to our databse once we have an image uploaded
    private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        
        let currentUser = User.current
        
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        
        postRef.updateChildValues(dict)
    } 
}
