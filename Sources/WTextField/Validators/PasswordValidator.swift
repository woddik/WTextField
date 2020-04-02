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
        case validationPasswordShouldContainsLowerAndUpperCases
    }
    
    private let config: WTypedTextField.WTextFieldPasswordConfigurator
    
    init(config: WTypedTextField.WTextFieldPasswordConfigurator) {
        self.config = config
    }
    
    func validate(_ object: String) -> WTextFieldError? {

        if let regex = config.validationOptions.first(where: { $0.isRegex })?.value, !object.isValid(for: regex) {
            return Validation.validationPasswordIsNotCorrect.asError
        }
        
        if object.count < config.minimumPassCount {
            return Validation.validationPasswordTooShort.asError
        }

        if object.count > config.maximumPassCount {
            return Validation.validationPasswordTooLong.asError
        }

        if config.validationOptions.contains(.digits) && !object.lowercased().containsDigits {
            return Validation.validationPasswordShouldContainDigits.asError
        }

        if config.validationOptions.contains(.specialSymbols) && !object.lowercased().containsSpecialSymbols {
            return Validation.validationPasswordShouldContainLetters.asError
        }
        if config.validationOptions.contains(.upperAndLowerCased) &&
            !(object.containsLowercased &&
            object.containsUppercased) {
            return Validation.validationPasswordShouldContainsLowerAndUpperCases.asError
        }
        
        return nil
    }
}
