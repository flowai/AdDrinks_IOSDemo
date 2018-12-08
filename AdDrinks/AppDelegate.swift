//
//  AppDelegate.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 17.10.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userReference: DocumentReference?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TODO: Think about transfering lots of the loading Code into the LaunchScreen - build new Controller there
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            //var userData: [String: Any]?
            // TODO: Dump collection Name to a config class outside the main classes
            userReference = Firestore.firestore().collection("userdata").document(currentUser.uid)
            userReference!.getDocument(source: FirestoreSource.server, completion: {
                (document, error) in
                if error != nil {
                    print("Error reading the document \(error.debugDescription)")
                    return
                }
                print("Document was read!")
                guard (document != nil) else {
                    print("ERROR Document does not exist")
                    // what if there is no sync with firestore so far?
                    return
                }
                let userData = document!.data()
                self.checkUserData(userData: userData)
                print("SUCCESS GET Document data: \(String(describing: userData))")
                
            })
            
            // Jump to root View
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
            self.window?.rootViewController = rootController
            print("currentUser: "+currentUser.email!+"; userID: "+currentUser.uid)
        } else {
            // If Logout jump to login view
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
            self.window?.rootViewController = rootController
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // func - to load and check user data against the local persistance
    func checkUserData (userData: [String: Any]?) {
            let context = self.persistentContainer.viewContext
            
            context.performAndWait {
                do {
                    // Search for existend User
                    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "uid = %@", Auth.auth().currentUser!.uid)
                    
                    let result = try fetchRequest.execute()
                    
                    guard let userDataPersistance = result.first else {
                        //if there is no user, create a new one
                        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                        let newUserDataPersistance = NSManagedObject(entity: entity!, insertInto: context)
                        newUserDataPersistance.setValue(Auth.auth().currentUser!.uid, forKey: "uid")
                        newUserDataPersistance.setValue(userData?["displayName"], forKey: "username")
                        newUserDataPersistance.setValue(userData?["email"], forKey: "email")
                        newUserDataPersistance.setValue(userData?["lastName"], forKey: "lastName")
                        newUserDataPersistance.setValue(userData?["preName"], forKey: "preName")
                        newUserDataPersistance.setValue(userData?["photoURL"], forKey: "photoURL")
                        newUserDataPersistance.setValue(userData?["createdAt"], forKey: "createdAt")
                        newUserDataPersistance.setValue(userData?["changedAt"], forKey: "changedAt")
                        try context.save()
                        print("Created new local persistance entry for user: \(String(describing: newUserDataPersistance.value(forKey: "email")))")
                        return
                    }
                    
                    // update existing User
                    userReference!.updateData([
                        "changedAt": FieldValue.serverTimestamp(), //not totally correct
                        "createdAt": userDataPersistance.createdAt!,
                        "displayName": userDataPersistance.username!,
                        "email": userDataPersistance.email!,
                        "lastName": userDataPersistance.lastName!,
                        "preName": userDataPersistance.preName!,
                        "photoURL": userDataPersistance.photoURL!
                    ]) { err in
                        if let err = err {
                            print("Error updating existing User: \(err)")
                        } else {
                            print("Existing User \(String(describing: userDataPersistance.email)) successfully updated")
                        }
                    }
                    
                } catch {
                    print("No user with uid / context save gone wrong")
                }
            }
            
        }
}

