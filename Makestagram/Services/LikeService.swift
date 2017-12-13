//
//  LikeService.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/13/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LikeService {
    
    static func create(for post: Post, success: @escaping (Bool) -> Void) {
        
        // each post must have a key. We check the post has a key and return false if there isn't one
        guard let key = post.key else {
            return success(false)
        }
        
        // use this uid to build the location of where we'll store the data for liking the post
        let currentUID = User.current.uid
        
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(true) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            // to increment and decrement like count, use a transaction block that saves data as a
            // transaction operation. The block will prevent data from being corrupted from multiple
            // writes happening at the same time
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount + 1
                
                return TransactionResult.success(withValue: mutableData)}, andCompletionBlock: { (error, _, _) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        success(false)
                    } else {
                        success(true)
                    }
            })
        }
    }
    
    static func delete(for post: Post, success: @escaping (Bool) -> Void) {
        
        guard let key = post.key else {
            return success(false)
        }
        
        let currentUID = User.current.uid
        
        let dislikesRef = Database.database().reference().child("postsLikes").child(key).child(currentUID)
        dislikesRef.setValue(nil) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success(false)
            }
            
            let dislikeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            dislikeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                let currentCount = mutableData.value as? Int ?? 0
                
                mutableData.value = currentCount - 1
                
                return TransactionResult.success(withValue: mutableData)}, andCompletionBlock: { (error, _, _) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                        success(false)
                    } else {
                        success(true)
                    }
            })
        }
    }
    
    // method to tell whether a post is liked by the current user
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key")
            return completion(false)
        }
        
        // get relative path to location of where we store the current user's like data
        // for a specific post, if a like were to exist.
        let likesRef = Database.database().reference().child("postLikes").child(postKey)
        
        // check whether a value exists at the location we're reading from. If there is, we know the current user has liked the post. Otherwise, we know that the user hasn't.
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? [String : Bool] {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    static func setIsLiked(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
            create(for: post, success: success)
        } else {
            delete(for: post, success: success)
        }
    }
    
    
    
    
}
