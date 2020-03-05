//
//  NumberValidator.swift
//  WTextField
//
//  Created by Woddi on 01.03.2020.
//

import Foundation

public struct NumberValidator: ValidatorProtocol {
    
    enum Validation: ErrorEnumLocalized {
        case validationStringShouldContainOnlyDigits
    }
    
    public func validate(_ object: String) -> WTextFieldError? {
        if object.containsLetters || object.containsSpecialSymbols {
            return Validation.validationStringShouldContainOnlyDigits.asError
        }
        return nil
    }
    
}
