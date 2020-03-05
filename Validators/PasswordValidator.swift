//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct PasswordValidator: ValidatorProtocol {
        
    // MARK: - Constants
    
    private struct Constants {
        static let minimumPassCount = 6
        static let maximumPassCount = 26
    }
    
    enum Validation: ErrorEnumLocalized {
        case validationPasswordTooShort
        case validationPasswordTooLong
        case validationPasswordShouldContainDigits
        case validationPasswordShouldContainLetters
        case validationPasswordIsNotCorrect
    }
    
    private let passwordRegex: String?
    
    init(passwordRegex: String? = nil) {
        self.passwordRegex = passwordRegex
    }
    
    func validate(_ object: String) -> WTextFieldErorr? {

        if let regex = passwordRegex, !object.isValid(for: regex) {
            return Validation.validationPasswordIsNotCorrect.asError
        }
        
        if object.count < Constants.minimumPassCount {
            return Validation.validationPasswordTooShort.asError
        }

        if object.count > Constants.maximumPassCount {
            return Validation.validationPasswordTooLong.asError
        }

        if !object.lowercased().containsDigits {
            return Validation.validationPasswordShouldContainDigits.asError
        }

        if !object.lowercased().containsSpecialSymbols {
            return Validation.validationPasswordShouldContainLetters.asError
        }
        
        return nil
    }
}
