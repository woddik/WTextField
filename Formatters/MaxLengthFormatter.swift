//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct MaxLengthFormatter: FormaterProtocol {
    private let maxLength: Int?
    
    init(maxLength: Int? = nil) {
        self.maxLength = maxLength
    }
    
    func format(string: String?) -> String? {
        guard let maxLength = maxLength else {
            return string
        }
        
        if (string?.count ?? 0) > maxLength {
            return string?.substring(fromIndex: 0, toIndex: maxLength)
        } else {
            return string
        }
    }
}
