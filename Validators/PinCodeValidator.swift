//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct PinCodeValidator: ValidatorProtocol {
    
    enum Validation: ErrorEnumLocalized {
        case validationPinCodeIncorrect
    }
    
    private let pinCodeCount: Int
    
    init(pinCodeCount: Int = 4) {
        self.pinCodeCount = pinCodeCount
    }
    
    func validate(_ object: String) -> WTextFieldError? {
        let withoutFormat = object.stringDigitsOnly()
    
        if withoutFormat.count != pinCodeCount {
            return Validation.validationPinCodeIncorrect.asError
        }
        
        return nil
    }
}
