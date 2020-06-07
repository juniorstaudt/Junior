//
//  Configuration.swift
//  ShopList
//
//  Created by Junior Staudt on 07/06/20.
//  Copyright © 2020 FIAP. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case iof = "iof"
    case dolar = "dolar"
}

class Configuration {
    
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    var iof: Double {
        get {
            return defaults.double(forKey: UserDefaultsKeys.iof.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.iof.rawValue)
        }
    }
    
    var dolar: Double {
        get {
            return defaults.double(forKey: UserDefaultsKeys.dolar.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.dolar.rawValue)
        }
    }
    
    private init() {
        if defaults.double(forKey: UserDefaultsKeys.iof.rawValue)  == 0 {
            defaults.set(6.38, forKey: UserDefaultsKeys.iof.rawValue)
        }
        if defaults.double(forKey: UserDefaultsKeys.dolar.rawValue) == 0 {
            defaults.set(4.969, forKey: UserDefaultsKeys.dolar.rawValue)
        }
        
    }
    
}
