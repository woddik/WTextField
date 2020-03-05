//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct SMSCodeFormater: FormaterProtocol {
    
    private let maxDigitsCount: Int
    
    init(_ maxDigits: Int = 6) {
        maxDigitsCount = maxDigits
    }
    
    func format(string: String?) -> String? {

        guard let text = string else {
            return nil
        }
        
        let onlyDigits = text.stringDigitsOnly()
        
        guard onlyDigits.count <= maxDigitsCount else {
            return String(text.dropLast())
        }
        
        var result = ""

        for (index, char) in onlyDigits.enumerated() {
            
            if index % 2 == 0 && char != " " && index != 0 {
                result.append(" ")
            }
            
            result.append(char)

        }
        
        return result
    }
    
}
