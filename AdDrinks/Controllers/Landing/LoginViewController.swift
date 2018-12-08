//
//  RootViewController.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 17.10.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!

    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    @IBAction func signUp(_ sender: Any) {
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if user != nil {
                if let name: String = user?.user.displayName {
                    print("User \(name) has signed in")
                }
                print("User unknown has signed in")
                let nextViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootView") as! RootViewController
                self.present(nextViewController, animated: true)
            }
            if error != nil {
                print("Something went wrong - user was not able to be created!")
            }
        }
    }
    
}

