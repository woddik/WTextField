//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct NameFormater: FormaterProtocol {
    
    func format(string: String?) -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: " ")
        characterSet.invert()
        return string?.trimmingCharacters(in: characterSet).trimmingCharacters(in: .decimalDigits)
    }

}
