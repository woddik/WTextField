//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct PhoneValidator: ValidatorProtocol {

    enum Validation: ErrorEnumLocalized {
        case validationPhoneNumberIncorrect
        case missingValidationData
    }
    
    private let config: WTypedTextField.WTextFieldPhoneConfigurator?
    private let regex: String?
    
    init(configure: WTypedTextField.WTextFieldPhoneConfigurator) {
        config = configure
        regex = nil
    }
    
    init(phoneRegex: String) {
        regex = phoneRegex
        config = nil
    }
    
    init() {
        config = nil
        regex = nil
    }
    
    func validate(_ object: String) -> WTextFieldError? {
        if let config = config {
            guard let phoneBody = removeCountryCode(from: object, countryCode: config.countryCode) else {
                return Validation.validationPhoneNumberIncorrect.asError
            }
    
            if phoneBody.count != config.maxLengthWithPlus {
                return Validation.validationPhoneNumberIncorrect.asError
            }
            return nil
        } else if let regex = regex {
            return object ~= regex ? nil : Validation.validationPhoneNumberIncorrect.asError
        }

        return nil
    }
    
}

// MARK: - Private methods

private extension PhoneValidator {
 
    func removeCountryCode(from phoneNumber: String, countryCode: String) -> String? {
        var temp = phoneNumber.stringDigitsOnly()
        
        if let rangeOfCountryCode = temp.range(of: countryCode.stringDigitsOnly()) {
            if rangeOfCountryCode.lowerBound == temp.startIndex &&
                rangeOfCountryCode.lowerBound != rangeOfCountryCode.upperBound {
                temp = String(temp[rangeOfCountryCode.upperBound..<temp.endIndex])
            }
        }
        
        return temp
    }
}
