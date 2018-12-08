//
//  NavigationViewController.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 14.11.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Foundation

class SettingsViewController: UIViewController  {
    
    @IBOutlet var eMailLabel: UILabel!
    @IBOutlet var userNameButton: UIButton!
    @IBOutlet var userPictureView: UIImageView!
    
    @IBOutlet var preNameButton: UIButton!
    @IBOutlet var lastNameButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let context = AppDelegate.persistentContainer.viewContext
        let context = getContext()
        
        //context.performAndWait {
            do {
                // Search for existend User
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "uid = %@", Auth.auth().currentUser!.uid)
                
                let result = try context.fetch(fetchRequest)
                let userDataPersistance = result.first

                self.eMailLabel.text =  userDataPersistance!.email!
                self.userNameButton.setTitle(userDataPersistance!.username!, for: UIControl.State.normal)
                self.preNameButton.setTitle(userDataPersistance!.preName!, for: UIControl.State.normal)
                self.lastNameButton.setTitle(userDataPersistance!.lastName!, for: UIControl.State.normal)
                
                } catch {
                    
                    print("Could not extract User Data out of user Id")
                }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
