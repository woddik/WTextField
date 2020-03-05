//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct ExpirationDateValidator: ValidatorProtocol {

    // MARK: - Constants
    
    private struct Constants {
        static let dateFormate = "MM/yy"
    }
    
    enum Validation: ErrorEnumLocalized {
        case validationExpirationDateWrongFormat
        case validationExpirationDateIsExpired
    }

    // MARK: - Private properties

    private static let formater = DateFormatter()
    private let calendar = Calendar(identifier: .gregorian)
    
    // MARK: - Public methods
    
    func validate(_ object: String) -> WTextFieldError? {
        var componentsToAdd = DateComponents()
        componentsToAdd.month = 1
        
        ExpirationDateValidator.formater.dateFormat = Constants.dateFormate

        guard let expirationDate = ExpirationDateValidator.formater.date(from: object) else {
            return Validation.validationExpirationDateWrongFormat.asError
        }
        
        let components = calendar.dateComponents([.year, .month], from: expirationDate)
        
        guard let startOfMonth = calendar.date(from: components),
            let lastDateOfMonth = calendar.date(byAdding: componentsToAdd, to: startOfMonth),
            lastDateOfMonth.compare(Date()) != ComparisonResult.orderedAscending else {
                return Validation.validationExpirationDateIsExpired.asError
        }
        
        return nil
    }
}
