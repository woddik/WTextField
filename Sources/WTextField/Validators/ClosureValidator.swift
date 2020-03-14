//
//  ClosureValidator.swift
//  WTextField
//
//  Created by Woddi on 06.03.2020.
//

import Foundation

struct ClosureValidator: ValidatorProtocol {
    
    private let validationCallback: (_ object: String) -> WTextFieldError?
    
    init(callback: @escaping (_ object: String) -> WTextFieldError?) {
        validationCallback = callback
    }
    
    func validate(_ object: String) -> WTextFieldError? {
        return validationCallback(object)
    }
}
