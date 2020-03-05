//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct NameValidator: ValidatorProtocol {
        
    enum Validation: ErrorEnumLocalized {
        case validationNameTooShort
    }
    
    private let minimumCount: Int
    
    init(minimumCount: Int = 2) {
        self.minimumCount = minimumCount
    }
    
    func validate(_ object: String) -> WTextFieldError? {
        let letters = object.components(separatedBy: CharacterSet.decimalDigits).joined()
                
        if letters.count < minimumCount {
            let errorText = Validation.validationNameTooShort.key + .space + "\(minimumCount)"
            return WTextFieldError(message: errorText)
        }
        
        return nil
    }
}
