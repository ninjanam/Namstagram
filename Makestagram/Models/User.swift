//
//  User.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/8/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    
    // MARK: - Properties
    let uid: String
    let username: String
    
    // MARK: - Init
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    // create reusable initialiser to create user objects from snapshots
    init?(snapshot: DataSnapshot) {
        // guard by requiring the snapshot to be casted to a dictionary and checking that the dictionary contains "username" key/value. If any of these fail, we return nil.
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
        else { return nil }
        
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    
    // private var to hold our current user. Private so it can't be accessed outside the class
    private static var _current: User?
    
    // computed var that only has a getter
    static var current: User {
        
        // check _current is of type User? isn't nil.
        // If _current is nil, and current is being read, guard statement will crash
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // if _current isn't nil, it will be returned to the user
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // create custom setter method to set current user
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            // turn the user object into Data type
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        _current = user
    }
}

extension User: NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}












