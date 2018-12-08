//
//  ShopViewController.swift
//  AdDrinks
//
//  Created by Waidner, Florian on 14.11.18.
//  Copyright © 2018 AdDrinks. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Foundation

class ShopViewCustomTableCell: UITableViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var putInBasket: UIButton!
    
}
