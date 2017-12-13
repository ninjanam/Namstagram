//
//  StorageReference+Post.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/11/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import Foundation
import FirebaseStorage

extension StorageReference {
    
    static let dateFormatter = ISO8601DateFormatter()
    
    static func newPostImageReference() -> StorageReference {
        let uid = User.current.uid
        let timestamp = dateFormatter.string(from: Date())
        
        return Storage.storage().reference().child("images/posts/\(uid)/\(timestamp).jpg")
    }
}
