//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

struct PhoneNumberFormater: FormaterProtocol {
    
    private let config: WTypedTextField.WTextFieldPhoneConfigurator
    
    init(configure: WTypedTextField.WTextFieldPhoneConfigurator) {
        config = configure
    }
    
    func processTextFieldText(_ textField: UITextField,
                              shouldChangeCharactersIn range: NSRange,
                              replacementString string: String,
                              validator: ValidatorProtocol?) {
        
        if let validator = validator, validator.validate(string) == nil {
            textField.text = format(string: string)
            
            return
        }
        defaultProcessTextFieldText(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func format(string: String?) -> String? {
        guard let phoneWithoutFormat = string?.stringDigitsOnly() else {
            return nil
        }
        
        guard let preparedString = prepareForFormat(phoneWithoutFormat) else {
            return nil
        }
        
        return formatPhoneNumber(preparedString)
    }
    
    func deleteOneCharIn(text: String,
                         textField: UITextField,
                         shouldChangeCharactersIn range: NSRange,
                         replacementString string: String) {
        var from = range.location
        let toIndx = from + range.length

        if text.substring(fromIndex: from, toIndex: toIndx)?.containsSpecialSymbols == true && from > 0 {
            from -= 1
        }
        let formated = format(string: text.cut(fromIndex: from, toIndex: toIndx) ?? "")
        let isCharRemoved = textField.text != formated
        let position = isCharRemoved ? textField.beginningOfDocument : textField.endOfDocument

        textField.text = formated
        
        guard let newPosition = textField.position(from: position, offset: from) else {
            return
        }
        
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        
        if phoneNumber.count < config.plusedCountryCode.count {
            return config.plusedCountryCode
        }
        
        var simpleNumbers = phoneNumber.stringDigitsOnly(exceptSymbolsFromString: "+")
        
        if simpleNumbers.count > config.maxLengthWithPlus {
            let maxIndex = simpleNumbers.index(simpleNumbers.startIndex, offsetBy: config.maxLengthWithPlus)
            simpleNumbers = String(simpleNumbers[..<maxIndex])
        }
        
        let firstCharIndex = simpleNumbers.index(simpleNumbers.startIndex, offsetBy: 1)
        let firstChar = String(simpleNumbers[..<firstCharIndex])
        
        let length = simpleNumbers.count
        let compareOptions = String.CompareOptions.regularExpression
        if firstChar == "+" {
            if length <= 6 {
                return simpleNumbers.replacingOccurrences(of: "(\\d{3})(\\d+)",
                                                          with: "$1 ($2)", options: compareOptions,
                                                          range: nil)
            }
            if length <= 9 {
                return simpleNumbers.replacingOccurrences(of: "(\\d{3})(\\d{2})(\\d+)",
                                                          with: "$1 ($2) $3", options: compareOptions,
                                                          range: nil)
            }
            
            if length <= 11 {
                return simpleNumbers.replacingOccurrences(of: "(\\d{3})(\\d{2})(\\d{3})(\\d+)",
                                                          with: "$1 ($2) $3 $4", options: compareOptions,
                                                          range: nil)
            }
            
            return simpleNumbers.replacingOccurrences(of: "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d+)",
                                                      with: "$1 ($2) $3 $4 $5", options: compareOptions,
                                                      range: nil)
        }
        
        return config.plusedCountryCode
        
    }
    
    func prepareForFormat(_ phoneNumber: String) -> String? {
        guard let withoutCountryCode = removeCountryCode(phoneNumber) else {
            return nil
        }
        
        return config.plusedCountryCode + withoutCountryCode
    }
    
    func removeCountryCode(_ phoneNumber: String) -> String? {
        var withoutFormat = phoneNumber.stringDigitsOnly()
        
        if let rangeOfCountryCode = withoutFormat.range(of: config.countryCode.dropLast()) {
            if rangeOfCountryCode.lowerBound == withoutFormat.startIndex &&
                rangeOfCountryCode.lowerBound != rangeOfCountryCode.upperBound {
                withoutFormat = String(withoutFormat[rangeOfCountryCode.upperBound..<withoutFormat.endIndex])
            }
        }
        
        if let rangeOfZero = withoutFormat.range(of: config.countryCode.notNilLast) {
            if rangeOfZero.lowerBound == withoutFormat.startIndex && !rangeOfZero.isEmpty {
                withoutFormat = String(withoutFormat[rangeOfZero.upperBound..<withoutFormat.endIndex])
            }
        }
        
        return withoutFormat
    }

}
