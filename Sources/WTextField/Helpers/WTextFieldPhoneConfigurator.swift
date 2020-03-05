//
//  WTextFieldPhoneConfigurator.swift
//  StarWallet
//
//  Created by Woddi on 05.03.2020.
//  Copyright © 2020 Woddi. All rights reserved.
//

import Foundation

public extension WTypedTextField {
    
    struct WTextFieldPhoneConfigurator {
        
        let maxLengthWithPlus: Int
        let countryCode: String
        var plusedCountryCode: String {
            return "+" + countryCode
        }
        
        init(maxLengthWithPlus: Int, countryCode: String) {
            self.maxLengthWithPlus = maxLengthWithPlus
            self.countryCode = countryCode
        }
        
        public static var ukrainePhone: WTextFieldPhoneConfigurator {
            return self.init(maxLengthWithPlus: 13, countryCode: "380")
        }
    }
}
