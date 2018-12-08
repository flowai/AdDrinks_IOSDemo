//
//  StackView.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 22.11.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class StackView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    var querySnapshot: QuerySnapshot?
    var products:[NSDictionary] = []
    //var products: [QueryDocumentSnapshot]?
    
    //MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.syncFirestoreWithPersistance()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        //tableView.dataSource = products

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    
    private func syncFirestoreWithPersistance() {
        let productsReference = Firestore.firestore().collection("products")
        productsReference.getDocuments() { //.whereField("capital", isEqualTo: true)
            (querySnapshot, err) in
            if let err = err {
                print("Error getting products: \(err)")
            } else {
                //self.querySnapshot = querySnapshot
                //self.products = querySnapshot!.documents
                print("reloadData - triggered")
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.products.append(document.data() as NSDictionary)
                    
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
}

extension StackView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ShopViewCustomCell",
            for: indexPath) as! ShopViewCustomTableCell
        
        let product = products[indexPath.row]
        cell.productName?.text = "\(String(describing: product["manufacturerName"]!)) - \(String(describing: product["title"]!))"
        cell.price?.text = "\(String(describing: product["price"]!))"
        //cell.bioLabel.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
        return cell
    }
}
