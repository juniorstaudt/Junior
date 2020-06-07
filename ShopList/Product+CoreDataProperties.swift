//
//  Product+CoreDataProperties.swift
//  ShopList
//
//  Created by Junior Staudt on 06/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productDescription: String?
    @NSManaged public var price: Double
    @NSManaged public var image: NSObject?
    @NSManaged public var creditCard: Bool
    @NSManaged public var dolarTaxValue: Double
    @NSManaged public var iofValue: Double
    @NSManaged public var realTotal: Double
    @NSManaged public var dolarTotal: Double
    @NSManaged public var purchasedState: State?

}
