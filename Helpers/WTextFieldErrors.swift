//
//  WTextFieldErrors.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import Foundation

enum ErrorType {
    enum Validation: EnumLocalized {
        case validationPhoneNumberIncorrect // rdy
        case validationNumberIncorrect // rdy
        case validationEmailIncorrect // rdy
        case validationPasswordTooShort // rdy
        case validationPasswordTooLong // rdy
        case validationPasswordShouldContainDigits // rdy
        case validationPasswordShouldContainLetters // rdy
        case validationPasswordIsNotCorrect // rdy
        case validationPasswordAndLoginShouldMatch
        case validationLoginTooShort
        case validationLoginTooLong
        case validationLoginContainsForbiddenChars
        case validationExpirationDateWrongFormat // rdy
        case validationExpirationDateIsExpired // rdy
        case validationCvvIncorrect // rdy
        case validationPinCodeIncorrect
        case validationFieldContainsForbiddenChars // rdy
        case validationSumShouldContainOnlyDigits
        case validationEmptyField
    }
    
    enum CostValidation: String {
        case validationSumShouldBeGreaterThen = "validate_sum_should_be_greater_then"
        case validationSumShouldBeLessThen = "validate_sum_should_be_less_then"
    }
    
    enum LengthValidation: EnumLocalized {
        case validationCardnameTooLongInfo // rdy
        case validationCardnameTooShortInfo // rdy
        case validationSMSCodeTooShort
        case validationNameTooShort // rdy
    }
    
    enum InternalInconsistency: String {
        case thisShouldntHappenReportBug = "this_shouldnt_happen_report_bug"
        case databaseError = "something_happend_with_database"
        case cardNotFound = "card_not_found"
    }
    
    enum Api: String {
        case apiUndefinedError = "api_undefined_error"
        case apiNoInternetConnectionError = "api_no_internet_connection_error"
        case apiSessionExpired = "api_session_expired"
    }
    
}

/// Errors for application
public struct WTextFieldErorr: Error, Codable {
    let code: Int
    let message: String
    
    init(code: Int = 0, message: String = "") {
        self.message = message
        self.code = code
    }
    
    init(error: Error) {
        let errorObject = error as NSError
        code = errorObject.code
        message = errorObject.localizedDescription
        
    }
    
    init(value: ErrorEnumLocalized, code: Int = 0) {
        message = value.key
        self.code = code
    }
    
}

