//
//  ViewController+CoreData.swift
//  ShopList
//
//  Created by Junior Staudt on 06/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
