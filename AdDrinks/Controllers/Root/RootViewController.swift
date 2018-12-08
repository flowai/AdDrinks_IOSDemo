//
//  DataViewController.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 17.10.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

let reuseIdentifier = "CellIdentifier";

class RootViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var currentUser: UILabel!
    @IBOutlet var navigarionBar: UINavigationBar!
    @IBOutlet var logout: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.checkIfUserIsSignedIn()
        
        // Set Border for the
//        self.currentUser.layer.borderWidth = 1.0
//        self.currentUser.layer.borderColor = UIColor.black.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {

    }
    
    //UICollectionViewDelegateFlowLayout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 4;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        
        return 1;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as UICollectionViewCell

        cell.backgroundColor = self.randomColor()
        
        
        return cell
    }
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    @IBAction func handleLogoutUser(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let nextViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginView") as! LoginViewController
            self.present(nextViewController, animated: true) //self.navigationController?.pushViewController(nextViewController, animated: true) -> with nav bar
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        } catch {
            print("Unknown error.")
        }
        
    }
    
    private func checkIfUserIsSignedIn() {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let currentUser = user {
                self.currentUser.text = "Hallo \(currentUser.email!). Schön dich zu sehen!"
                return
            } else {
                // user is not signed in
                // go to login controller
                print("user is not signed in")
            }
        }

    }
}

