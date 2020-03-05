//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct UpperCaseFormetter: FormaterProtocol {
    
    func format(string: String?) -> String? {
        return string?.uppercased()
    }
    
}
