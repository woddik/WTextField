//
//  WTextFieldDateConfigurator.swift
//  StarWallet
//
//  Created by Woddi on 05.03.2020.
//  Copyright © 2020 Woddi. All rights reserved.
//

import UIKit

public extension WTypedTextField {
    
    struct WTextFieldDateConfigurator {
        let minimumDate: Date
        let maximumDate: Date
        let mode: UIDatePicker.Mode
        let locale: Locale
        let dateFormate: String
        
        init(dateFormate: String, minimumDate: Date, maximumDate: Date, mode: UIDatePicker.Mode = .date, locale: Locale) {
            self.dateFormate = dateFormate
            self.minimumDate = minimumDate
            self.maximumDate = maximumDate
            self.mode = mode
            self.locale = locale
        }
    }
}
