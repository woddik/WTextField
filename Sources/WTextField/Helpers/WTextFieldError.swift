//
//  WTextFieldErrors.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import Foundation

/// Errors for application
public struct WTextFieldError: Error, Codable {
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

