//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

struct CostValidator: ValidatorProtocol {

    enum Validation: ErrorEnumLocalized {
        case validationSumShouldBeGreaterThen
        case validationSumShouldContainOnlyDigits
        case validationEmptyField
    }
    
    let minimumCost: Int
    
    init(minimumCost: Int = 0) {
        self.minimumCost = minimumCost
    }
    
    func validate(_ object: String) -> WTextFieldErorr? {
        if object.isEmpty {
            return Validation.validationEmptyField.asError
        }
        
        guard let costAmount = Double(object) else {
            return Validation.validationSumShouldContainOnlyDigits.asError
        }
        
        if costAmount < Double(minimumCost) {
            let errorText = Validation.validationSumShouldBeGreaterThen.key + .space + "\(minimumCost)"
            return WTextFieldErorr(message: errorText)
        }
        
        return nil
    }
}
