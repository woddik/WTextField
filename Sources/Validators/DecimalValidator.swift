//
//  DecimalValidator.swift
//  WTextField
//
//  Created by Woddi on 01.03.2020.
//

import Foundation

public struct DecimalValidator: ValidatorProtocol {
    
    enum Validation: ErrorEnumLocalized {
        case validationStringShouldContainOnlyDigits
    }
    
    public func validate(_ object: String) -> WTextFieldError? {
        if !object.containsDigitsOrSymbols {
            return Validation.validationStringShouldContainOnlyDigits.asError
        }
        return nil
    }
    
}
