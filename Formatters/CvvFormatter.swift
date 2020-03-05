//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct CvvFormatter: FormaterProtocol {
    
    func format(string: String?) -> String? {
        if (string?.count ?? 0) > 3 {
            return string?.substring(fromIndex: 0, toIndex: 3)
        } else {
            return string
        }
    }
}
