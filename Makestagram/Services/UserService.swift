//
//  UserService.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/8/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    // method encapsulates functionality for creating a user on Firebase
    // removing the networking related code in CreateUsernameViewController
    // The struct is an intermediary for communicating between our app and Firebase
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        
        // create a dictionary to store the username they have provided
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        // write the data we want to store at 'ref'
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            // read the user we just wrote to the DB and create a user from the snapshot
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        
        print("NA: 1. UserService - func show")

        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print("NA: 2. UserService - before guard let user")
            guard let user = User(snapshot: snapshot)
                else {
                return completion(nil)
            }
            print("NA: 3. UserService - before completion(user)")
            completion(user)
            print("NA: 4. UserService - after completion(user)")
        }
    }
    
    // method will retrieve all of user's posts from Firebase.
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let dispatchGroup = DispatchGroup()
            
            let posts: [Post] =
                snapshot
                    .reversed()
                    .flatMap {
                        guard let post = Post(snapshot: $0)
                            else { return nil }
                        
                        dispatchGroup.enter()
                        
                        LikeService.isPostLiked(post) { (isLiked) in
                            post.isLiked = isLiked
                            
                            dispatchGroup.leave()
                        }
                        return post
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
            })
        }
    }
    
}
