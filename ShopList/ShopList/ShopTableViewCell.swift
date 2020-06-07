//
//  ShopTableViewCell.swift
//  ShopList
//
//  Created by Junior Staudt on 05/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lbProductDescription: UILabel!
    @IBOutlet weak var lbProductPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with product: Product) {
        lbProductDescription.text = product.productDescription ?? "Produto sem nome"
        lbProductPrice.text = String(product.price) 
        if let image = product.image as? UIImage {
            ivProduct.image = image
        } else {
            ivProduct.image = UIImage(named: "imageUpload")
        }
    
    }

}
