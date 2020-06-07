//
//  TaxesCalculator.swift
//  ShopList
//
//  Created by Junior Staudt on 07/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import Foundation

class TaxesCalculator {
    
    let config = Configuration.shared
    var product: Product!
    static let shared = TaxesCalculator()
    
    var dolarTax: Double = Configuration.shared.dolar
    var iofTax: Double = Configuration.shared.iof
    let formater = NumberFormatter()

    /*
    var dolarTaxValue: Double {
        if product.purchasedState!.taxRate == nil {
            return 0
        } else {
            return product.price * product.purchasedState!.taxRate/100
        }
    }
    
    var dolarTotal: Double {
        return
    }
    
    var iofValue: Double {
        return ((product.dolarTotal * dolarTax) * iofTax/100)
    }
    
    var realTotal: Double {
        return (product.dolarTotal * dolarTax)
    }
    
    func calculate(usingCreditCard: Bool) -> Double {
        var totalRealWithCreditCard = realTotal
        if usingCreditCard {
            totalRealWithCreditCard += iofValue
        }
        return totalRealWithCreditCard
    }
 */
        
    func convertToDouble(_ string: String) -> Double {
        formater.numberStyle = .none
        return formater.number(from: string)!.doubleValue
    }
    
    func getFormattedValue(of value: Double, withCurrency currency: String) -> String {
        formater.numberStyle = .currency
        formater.currencySymbol = currency
        formater.alwaysShowsDecimalSeparator = true
        return formater.string(for: value)!
    }
    
    private init() {
        formater.usesGroupingSeparator = true
    }
}
