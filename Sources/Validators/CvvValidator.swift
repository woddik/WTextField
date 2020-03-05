//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct CvvValidator: ValidatorProtocol {
    // MARK: - Constants
    
    private struct Constants {
        static let cvvDigitsCount = 3
    }
    
    enum Validation: ErrorEnumLocalized {
        case validationCvvIncorrect
    }
    
    func validate(_ object: String) -> WTextFieldError? {
        let withoutFormat = object.stringDigitsOnly()
        
        if withoutFormat.count != Constants.cvvDigitsCount {
            return Validation.validationCvvIncorrect.asError
        }
        
        return nil
    }
}
