//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct EmailValidator: ValidatorProtocol {
    
    // MARK: - Constants
    
    private struct Constants {
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+\\.[A-Za-z]{2,64}"
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }
    
    enum Validation: ErrorEnumLocalized {
        case validationEmailIncorrect
    }
    
    func validate(_ object: String) -> WTextFieldErorr? {
        if !Constants.emailPredicate.evaluate(with: object) {
            return Validation.validationEmailIncorrect.asError
        }
        return nil        
    }
}
