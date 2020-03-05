//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct PinCodeFormatter: FormaterProtocol {

    init(pinCodeLenght: Int = 4) {
        self.pinCodeLenght = pinCodeLenght
    }
    
    private let pinCodeLenght: Int

    func format(string: String?) -> String? {
        if (string?.count ?? 0) > pinCodeLenght {
            return string?.substring(fromIndex: 0, toIndex: pinCodeLenght)
        } else {
            return string
        }
    }
}
