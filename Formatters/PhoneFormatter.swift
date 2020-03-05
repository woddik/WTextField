//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

struct PhoneNumberFormater: FormaterProtocol {
    
    // MARK: - Constants
    
    private struct Constants {
        static let maxLengthWithPlus = 13
        static let countryCode = "380"
        static var plusedCountryCode: String {
            return "+" + countryCode
        }
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
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        
        if phoneNumber.count < Constants.plusedCountryCode.count {
            return Constants.plusedCountryCode
        }
        
        var simpleNumbers = phoneNumber.stringDigitsOnly(exceptSymbolsFromString: "+")
        
        if simpleNumbers.count > Constants.maxLengthWithPlus {
            let maxIndex = simpleNumbers.index(simpleNumbers.startIndex, offsetBy: Constants.maxLengthWithPlus)
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
        
        return Constants.plusedCountryCode
        
    }
    
    func prepareForFormat(_ phoneNumber: String) -> String? {
        guard let withoutCountryCode = removeCountryCode(phoneNumber) else {
            return nil
        }
        
        return Constants.plusedCountryCode + withoutCountryCode
    }
    
    func removeCountryCode(_ phoneNumber: String) -> String? {
        var withoutFormat = phoneNumber.stringDigitsOnly()
        
        if let rangeOfCountryCode = withoutFormat.range(of: "38") {
            if rangeOfCountryCode.lowerBound == withoutFormat.startIndex &&
                rangeOfCountryCode.lowerBound != rangeOfCountryCode.upperBound {
                withoutFormat = String(withoutFormat[rangeOfCountryCode.upperBound..<withoutFormat.endIndex])
            }
        }
        
        if let rangeOfZero = withoutFormat.range(of: "0") {
            if rangeOfZero.lowerBound == withoutFormat.startIndex && !rangeOfZero.isEmpty {
                withoutFormat = String(withoutFormat[rangeOfZero.upperBound..<withoutFormat.endIndex])
            }
        }
        
        return withoutFormat
    }

}
