//
//  SIgnUpViewController.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 31.10.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Foundation

class SignUpViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet var eMail: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var retypePassword: UITextField!
    
    @IBOutlet var createAccount: UIButton!
    
    var pageViewController: UIPageViewController?
    
    let missingCredentials = "missing Credentials"
    let credAlreadyInUse = "Credential already in use"
    let invalidEMail = "invalid eMail address"
    let eMailAddressIsMissing = "eMail address is missing"
    let passwordIsTooWeak = "password is too weak, pls refer to the password standards"
    let accountIsAlreadyInUse = "account is already in use"
    let passwordAndRetypePaswordNotCompliant = "Please check that Password and retype Password are equal"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNewUserAccount(_ sender: Any) {
        guard let userEMail = eMail.text, !userEMail.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty,
                let userPassword = password.text, !userPassword.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty,
                    let userRetypePassword = retypePassword.text, !userRetypePassword.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            
            print(missingCredentials)
            self.showAlertButtonWrongCredentials(errorIssue: missingCredentials)
            return
        }
        
        if userPassword == userRetypePassword {
            Auth.auth().createUser(withEmail: userEMail, password: userPassword) { (user, error) in
                if user != nil {
                    print("User has signed up")
                    let nextViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginView") 
                    self.present(nextViewController, animated: true)
                }
                
                if error != nil {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                        case .credentialAlreadyInUse:
                            print(self.credAlreadyInUse)
                            self.showAlertButtonWrongCredentials(errorIssue: self.credAlreadyInUse)
                        case .invalidEmail:
                            print(self.invalidEMail)
                            self.showAlertButtonWrongCredentials(errorIssue: self.invalidEMail)
                        case .missingEmail:
                            print(self.eMailAddressIsMissing)
                            self.showAlertButtonWrongCredentials(errorIssue: self.eMailAddressIsMissing)
                        case .weakPassword:
                            print(self.passwordIsTooWeak)
                            self.showAlertButtonWrongCredentials(errorIssue: self.passwordIsTooWeak)
                        case .accountExistsWithDifferentCredential:
                            print(self.accountIsAlreadyInUse)
                            self.showAlertButtonWrongCredentials(errorIssue: self.accountIsAlreadyInUse)
                        default:
                            print("Internal Error: \(String(errorCode.rawValue))")
                            self.showAlertButtonWrongCredentials(errorIssue: String(errorCode.rawValue))
                        }
                    }
                }
            }
        }
        else {
            print(self.passwordAndRetypePaswordNotCompliant)
            self.showAlertButtonWrongCredentials(errorIssue: self.passwordAndRetypePaswordNotCompliant)
        }
    }
    
    func showAlertButtonWrongCredentials(errorIssue: String) {
        
        // create the alert
        let alert = UIAlertController(title: "Wrong Credentials", message: errorIssue, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "One more time!", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}
