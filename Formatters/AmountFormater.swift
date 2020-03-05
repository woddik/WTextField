//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

struct AmountFormater: FormaterProtocol {
    
    private let maxNumbersAfterPoint: Int?
    
    init(maxNumbersAfterPoint: Int? = nil) {
        self.maxNumbersAfterPoint = maxNumbersAfterPoint
    }
    
    func format(string: String?) -> String? {
        guard let result = string?.replacingOccurrences(of: ",", with: ".")
            .stringDigitsOnly(exceptSymbolsFromString: "-.").fixedIncorrectAmountZero else {
                return nil
        }
        var temp = result
        
        if let range = temp.range(of: ".") {
            let rrr = range.upperBound..<result.endIndex
            temp = temp.replacingOccurrences(of: ".", with: "", options: .caseInsensitive, range: rrr)
        }
        
        if let maxNumbersAfterPoint = maxNumbersAfterPoint,
            let pointRange = temp.range(of: ".") {
            let endIndex = temp.distance(from: temp.startIndex, to: pointRange.upperBound) + maxNumbersAfterPoint
            
            if let substring = temp.substring(fromIndex: 0, toIndex: endIndex) {
                return substring
            }
        }
        
        return temp.stringDigitsOnly(exceptSymbolsFromString: ".")
    }

}

fileprivate extension String {
    
    var fixedIncorrectAmountZero: String {
        guard count > 1 else {
            return self
        }
        if self[0] == "0" && self[1] != "." {
            return String(self.dropFirst()).fixedIncorrectAmountZero
        }
        return self
    }
}
