//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Nam-Anh Vu on 12/7/17.
//  Copyright © 2017 TenTwelve. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        // access the FUIAuth default auth UI singleton
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        
        // set FUIAuth's singleton delegate
        authUI.delegate = self
        
        // present auth view controller
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        // check the FIRUser returned from authentication is not nil by unwrapping it.
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        
        // guard is needed bcause cannot proceed if user is nil
        guard let user = user else { return }
        
        // get data in Firebase for this particular userid
        UserService.show(forUID: user.uid) { (user) in
            print("NA: 1. LoginVC - UserService.show")
           // retrieve user data from snapshot
            if let user = user {
                print("NA: 2. LoginVC - if let")
                // once we receive user from database, set singleton with custom setter method. After singleton is set, it will remain in memory for the rest of app's lifecycle. Accessible from any view controller with User.current
                User.setCurrent(user, writeToUserDefaults: true)
                print("NA: 3. LoginVC - User.setCurrent")

                let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                print("NA: 4. LoginVC - initialViewController set")
            } else {
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
        }
    }
}
