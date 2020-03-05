//
//  WTextFieldDataType.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import Foundation

public enum WTextFieldDataType {
    case none
    case phoneNumber(config: WTypedTextField.WTextFieldPhoneConfigurator = .ukrainePhone)
    case email
    case login
    case enterPassword
    @available(iOS 12.0, *) case newPassword
    case topUpCost
    case transferByCardCost
    case card
    case expirationDate
    case cvv
    case creditCardName
    case date(config: WTypedTextField.WTextFieldDateConfigurator)
    case numberOnly
    case decimalOnly
    case upperCase
    case pinCode
    case smsCode
    case name
    case moneyAmount
    
    var defaultFormatter: FormaterProtocol? {
        switch self {
        case .phoneNumber(let config): return PhoneNumberFormater(configure: config)
        case .topUpCost: return DecimalFormatter(maxNumbersAfterPoint: 2, maxValue: nil)
        case .transferByCardCost: return DecimalFormatter(maxNumbersAfterPoint: 2, maxValue: nil)
        case .card: return CardNumberFormatter()
        case .expirationDate: return ExpirationDateFormatter()
        case .cvv: return CvvFormatter()
        case .creditCardName: return NameFormater()
        case .numberOnly: return NumbersFormatter()
        case .decimalOnly: return DecimalFormatter(maxNumbersAfterPoint: 2)
        case .upperCase: return UpperCaseFormetter()
        case .pinCode: return PinCodeFormatter()
        case .smsCode: return SMSCodeFormater()
        case .name: return NameFormater()
        case .moneyAmount: return DecimalFormatter(maxNumbersAfterPoint: 2, maxValue: nil)
        default: return nil
        }
    }
    
    var defaultValidator: ValidatorProtocol? {
        switch self {
        case .phoneNumber(let config): return PhoneValidator(configure: config)
        case .email: return EmailValidator()
        case .login: return LoginValidator()
        case .enterPassword, .newPassword: return PasswordValidator()
        case .topUpCost: return CostValidator()
        case .transferByCardCost: return CostValidator()
        case .card: return CardValidator()
        case .expirationDate: return ExpirationDateValidator()
        case .cvv: return CvvValidator()
        case .creditCardName: return CardNameValidator()
        case .numberOnly: return NumberValidator()
        case .decimalOnly: return DecimalValidator()
        case .pinCode: return PinCodeValidator()
        case .smsCode: return PinCodeValidator()
        case .name: return NameValidator()
        default: return nil
        }
    }
    
}
