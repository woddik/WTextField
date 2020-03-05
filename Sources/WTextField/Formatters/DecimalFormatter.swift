//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import UIKit

struct DecimalFormatter: FormaterProtocol {

    private let maxNumbersAfterPoint: Int?
    private let maxValue: Double?
        
    init(maxNumbersAfterPoint: Int? = nil, maxValue: Double? = nil) {
        self.maxNumbersAfterPoint = maxNumbersAfterPoint
        self.maxValue = maxValue
    }

    func format(string: String?) -> String? {
        guard let result = string?.replacingOccurrences(of: ",", with: ".")
            .stringDigitsOnly(exceptSymbolsFromString: "-.") else {
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
                return checkForMaxValue(substring, with: maxNumbersAfterPoint)
            }
        }

        return checkForMaxValue(temp)
    }
    
}

// MARK: - Private methods

private extension DecimalFormatter {
    
    private func checkForMaxValue(_ temp: String, with maxNumbersAfterPoint: Int? = nil) -> String? {
        if let maxValue = maxValue {
            let curValue = Double(temp) ?? 0
            if curValue > maxValue {
                if let maxNumbersAfterPoint = maxNumbersAfterPoint {
                    return String(format: "%.\(maxNumbersAfterPoint)f", maxValue)
                } else {
                    return "\(maxValue)"
                }
            }
        }
        
        return temp
    }
}
