//
//  ProductViewController.swift
//  ShopList
//
//  Created by Junior Staudt on 05/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbDolarProductPrice: UILabel!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lbPurchasedState: UILabel!
    @IBOutlet weak var lbDolarTaxValue: UILabel!
    @IBOutlet weak var lbDolarTotal: UILabel!
    @IBOutlet weak var swCreditCard: UISwitch!
    @IBOutlet weak var lbIOFValue: UILabel!
    @IBOutlet weak var lbRealTotal: UILabel!
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lbProductDescription.text = product.productDescription
        lbDolarProductPrice.text = tc.getFormattedValue(of: product.price, withCurrency: "US$ ")
        lbPurchasedState.text = product.purchasedState?.name
        lbDolarTaxValue.text = tc.getFormattedValue(of: product.dolarTaxValue, withCurrency: "US$ ")
        lbDolarTotal.text = tc.getFormattedValue(of: product.dolarTotal, withCurrency: "US$ ")
        swCreditCard.setOn(product.creditCard, animated: false)
        lbIOFValue.text = tc.getFormattedValue(of: product.iofValue, withCurrency: "R$ ")
        lbRealTotal.text = tc.getFormattedValue(of: product.realTotal, withCurrency: "R$ ")
        if let image = product.image as? UIImage {
            ivProduct.image = image
        } else {
            ivProduct.image = UIImage(named: "imageUpload")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.product = product
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
