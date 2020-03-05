//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

// Credit Card Type Values
///
/// - visa: Card number is a type of Visa
/// - mastercard: Card number is a type of Mastercard
/// - unknown: Card number type is unknown or a card number is invalid
enum PMCreditCardType {
    case visa
    case mastercard
    case space
    case unknown
}

struct CardValidator: ValidatorProtocol {
    // MARK: - Constants
    
    private struct Constants {
        static let visaRegex = NSPredicate(format: "SELF MATCHES \"^[4][0-9]*$\"")
        static let masterCardRegex = NSPredicate(format: "SELF MATCHES \"^[5][1-5][0-9]*$\"")
        static let spaceCardregex = NSPredicate(format: "SELF MATCHES \"^9804[0-9]*$\"")
        static let cardNumbersCount = 16
    }

    enum Validation: ErrorEnumLocalized {
        case validationNumberIncorrect
    }
    
    private let error = Validation.validationNumberIncorrect.asError

    let errorMessage = NSLocalizedString("validate_number_incorrect", comment: "")
    
    func validate(_ object: String) -> WTextFieldError? {
        let cardWithoutFromat = object.stringDigitsOnly()
        
        if cardWithoutFromat.count != Constants.cardNumbersCount {
            return error
        }
        
        guard let firstChar = cardWithoutFromat.substring(fromIndex: 0, toIndex: 1) else {
            return error
        }
        
        let cardNumbersSet = CharacterSet(charactersIn: "24569")
        if firstChar.rangeOfCharacter(from: cardNumbersSet) == nil {
            return error
        }
        return nil
        
    }
    
    static func getTypeOf(_ cardNumber: String) -> PMCreditCardType {
        let withoutFormat = cardNumber.stringDigitsOnly()
        
        if Constants.visaRegex.evaluate(with: withoutFormat) {
            return .visa
        }
        
        if Constants.masterCardRegex.evaluate(with: withoutFormat) {
            return .mastercard
        }
        
        if Constants.spaceCardregex.evaluate(with: withoutFormat) {
            return .space
        }
        
        return .unknown
    }
}
