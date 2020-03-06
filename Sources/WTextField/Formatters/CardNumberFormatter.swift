//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

import UIKit

struct CardNumberFormatter: FormaterProtocol {
    
    // MARK: - Constants
    
    private struct Constants {
        static let maxLength = 16
    }
    
    func format(string: String?) -> String? {
        return formatCardNumber(string)
    }
    
    /// Replacing card numbers with '*' symbol
    ///
    /// - Parameters:
    ///   - string: CardNumber string, can be with format and without it
    ///   - secureFrom: The index of number in card number, from 0 to 16
    ///   - count: Count of secured numbers in cradNumber
    /// - Returns: Formated secured card number
    public func securedFormat(string: String, secureFrom: Int = 6, count: Int = 6) -> String? {
        let withoutFormat = string.stringDigitsOnly(exceptSymbolsFromString: "*")
            
        let len = withoutFormat.count 
        
        if secureFrom > len {
            return formatCardNumber(withoutFormat)
        }
        
        let fromIndex = secureFrom
        let toIndex = min(max(fromIndex, fromIndex + count), len)
        let securedString = String(repeating: "*", count: (toIndex - fromIndex))
        let securedWithoutFormat = withoutFormat.replace(with: securedString, fromIndex: fromIndex, toIndex: toIndex)
        
        return formatCardNumber(securedWithoutFormat, secured: true)
    }
    
}

// MARK: - Private methods

private extension CardNumberFormatter {
    
    func formatCardNumber(_ cardNumber: String?, secured: Bool = false) -> String? {
        
        guard let card = cardNumber else {
            return nil
        }
        do {
            let regexOptions = NSRegularExpression.Options.caseInsensitive
            let matchingOptions = NSRegularExpression.MatchingOptions.withTransparentBounds
            let pattern: String = secured ? "[^[0-9*]]" : "[^[0-9]]"
            let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
            var range = NSRange.init(location: 0, length: card.count)
            var simpleNumbers = regex.stringByReplacingMatches(in: card, options: matchingOptions,
                                                               range: range, withTemplate: "")
            
            if simpleNumbers.count > Constants.maxLength {
                let maxIndex = simpleNumbers.index(simpleNumbers.startIndex, offsetBy: Constants.maxLength)
                simpleNumbers = String(simpleNumbers[..<maxIndex])
            }
            
            let length = simpleNumbers.count
            range = NSRange.init(location: 0, length: simpleNumbers.count)
            let compareOptions = String.CompareOptions.regularExpression
            
            if length <= 4 {
                return simpleNumbers.replacingOccurrences(of: "(\\S+)",
                                                          with: "$1", options: compareOptions,
                                                          range: nil)
            }
            if length < 9 {
                return simpleNumbers.replacingOccurrences(of: "(\\S{4})(\\S+)",
                                                          with: "$1 $2", options: compareOptions,
                                                          range: nil)
            }
            
            if length < 13 {
                return simpleNumbers.replacingOccurrences(of: "(\\S{4})(\\S{4})(\\S+)",
                                                          with: "$1 $2 $3", options: compareOptions,
                                                          range: nil)
            }
            
            return simpleNumbers.replacingOccurrences(of: "(\\S{4})(\\S{4})(\\S{4})(\\S+)",
                                                      with: "$1 $2 $3 $4", options: compareOptions,
                                                      range: nil)
            
        } catch {
            return nil
        }
    }
}
