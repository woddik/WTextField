//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

struct ExpirationDateFormatter: FormaterProtocol {
    
    func format(string: String?) -> String? {
        return formatCardNumber(string)
    }

}

// MARK: - Private methods

private extension ExpirationDateFormatter {
    
    func formatCardNumber(_ cardNumber: String?) -> String? {
        let maxLength = 4
        
        guard let card = cardNumber else {
            return nil
        }
        
        do {
            let regexOptions = NSRegularExpression.Options.caseInsensitive
            let matchingOptions = NSRegularExpression.MatchingOptions.withTransparentBounds
            let regex = try NSRegularExpression(pattern: "[^[0-9]]", options: regexOptions)
            var range = NSRange.init(location: 0, length: card.count)
            var simpleNumbers = regex.stringByReplacingMatches(in: card, options: matchingOptions,
                                                               range: range, withTemplate: "")
            
            if simpleNumbers.count > maxLength {
                let maxIndex = simpleNumbers.index(simpleNumbers.startIndex, offsetBy: maxLength)
                simpleNumbers = String(simpleNumbers[..<maxIndex])
            }
            
            range = NSRange.init(location: 0, length: simpleNumbers.count)
            let compareOptions = String.CompareOptions.regularExpression
            
            simpleNumbers = checkAndFix(month: simpleNumbers)
            let length = simpleNumbers.count
            
            if length < 2 {
                return simpleNumbers.replacingOccurrences(of: "(\\d+)", with: "$1", options: compareOptions, range: nil)
            } else if length == 2 {
                return simpleNumbers.replacingOccurrences(of: "(\\d{2})", with: "$1/", options: compareOptions,
                                                          range: nil)
            } else {
                var month = simpleNumbers.substring(fromIndex: 0, toIndex: 2) ?? ""
                month = checkAndFix(month: month)
                simpleNumbers = simpleNumbers.replace(with: month, fromIndex: 0, toIndex: 2)
            }
            
            return simpleNumbers.replacingOccurrences(of: "(\\d{2})(\\d+)",
                                                      with: "$1/$2", options: compareOptions,
                                                      range: nil)
        } catch {
            return nil
        }
    }
    
    func checkAndFix(month: String) -> String {
        if month.count == 1 && (month != "0" && month != "1") {
            return "0" + month
        }
        
        if month.count == 2 {
            if Int(month) ?? 0 > 12 {
                return "12"
            }
            if Int(month) ?? 0 < 1 {
                return "01"
            }
        }
        
        return month
    }
}
