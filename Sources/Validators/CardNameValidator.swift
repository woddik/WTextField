//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct CardNameValidator: ValidatorProtocol {
    
    let maximumCount: Int
    let minimumCount: Int
    
    init(maximumCount: Int = 50, minimumCount: Int = 1) {
        self.maximumCount = maximumCount
        self.minimumCount = minimumCount
    }
    enum Validation: ErrorEnumLocalized {
        case validationCardNameTooLongInfo
    }
    
    func validate(_ object: String) -> WTextFieldError? {

        if object.count > maximumCount {
            let errorText = Validation.validationCardNameTooLongInfo.key + .space + "\(maximumCount)"
            return WTextFieldError(message: errorText)
        }
        
        if object.isEmpty {
            let errorText = Validation.validationCardNameTooLongInfo.key + .space + "\(minimumCount)"
            return WTextFieldError(message: errorText)
        }
        
        return nil
    }
}
