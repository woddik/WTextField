//
//  eManat
//
//  Created by Konstantin Sidorovich on 6/26/19.
//  Copyright © 2019 SDK.finance. All rights reserved.
//

import Foundation

struct LoginValidator: ValidatorProtocol {
    
    // MARK: - Constants
    
    private struct Constants {
        static let minimumLoginLengh = 6
        static let maximumLoginLengh = 50
        static let forbiddenCharactersString =
        """
        \u{0}\u{1}\u{2}\u{3}\u{4}\u{5}\u{6}\u{7}\u{8}\u{9}\u{a}\u{b}\u{c}\u{d}\u{e}\u{f}
        \u{10}\u{11}\u{12}\u{13}\u{14}\u{15}\u{16}\u{17}\u{18}\u{19}\u{1a}\u{1b}\u{1c}\u{1d}\u{1e}\u{1f}
        \u{20}\u{22}\u{25}\u{27}
        """
    }
    
    enum Validation: ErrorEnumLocalized {
        case validationLoginTooShort
        case validationLoginTooLong
        case validationLoginContainsForbiddenChars
    }
    
    func validate(_ object: String) -> WTextFieldErorr? {
        if object.count < Constants.minimumLoginLengh {
            return Validation.validationLoginTooShort.asError
        }
        
        if object.count > Constants.maximumLoginLengh {
            return Validation.validationLoginTooLong.asError
        }
        

        let forbiddenCharacters = CharacterSet(charactersIn: Constants.forbiddenCharactersString)
        
        if object.lowercased().rangeOfCharacter(from: forbiddenCharacters) != nil {
            return Validation.validationLoginContainsForbiddenChars.asError
        }
        return nil
    }
}
