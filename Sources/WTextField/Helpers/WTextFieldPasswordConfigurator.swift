//
//  WTextFieldPasswordConfigurator.swift
//  WTextField
//
//  Created by Woddi on 06.03.2020.
//

import UIKit

public extension WTypedTextField {
    
    struct SecureConfigurator {
        public let secureModIsEnable: Bool
        public let withSecureTogle: Bool
        public let showPassImage: UIImage
        public let hidePassImage: UIImage
        
        public static var `default`: SecureConfigurator {
            var showImage = UIImage()
            var hideImage = UIImage()
            if #available(iOS 13.0, *) {
                showImage = UIImage(systemName: "eye") ?? UIImage()
                hideImage = UIImage(systemName: "eye.slash") ?? UIImage()
            }
            return self.init(secureModIsEnable: true,
                             withSecureTogle: true,
                             showPassImage: showImage,
                             hidePassImage: hideImage)
        }
    }
    
    struct ValidationOption: Hashable {
        
        private enum ObjectKeys: String, Hashable {
            case specialSymbols
            case upperAndLowerCased
            case digits
            case passwordRegex
        }
        
        // MARK: - Public properties
        
        public static var specialSymbols: ValidationOption { ValidationOption(identifier: .specialSymbols) }
        public static var upperAndLowerCased: ValidationOption { ValidationOption(identifier: .upperAndLowerCased) }
        public static var digits: ValidationOption { ValidationOption(identifier: .digits) }
        
        public static func passwordRegex(_ regex: String) -> ValidationOption {
            return ValidationOption(identifier: .passwordRegex, value: regex)
        }
        
        public let value: String?

        public var isRegex: Bool {
            return identifier == .passwordRegex
        }
        
        // MARK: - Private properties
        
        private let identifier: ObjectKeys
        
        // MARK: - Initializer
        
        private init(identifier: ObjectKeys, value: String? = nil) {
            self.identifier = identifier
            self.value = value
        }
    }
    
    struct WTextFieldPasswordConfigurator {
        // MARK: - Constants
        
        private struct Constants {
            static let minimumPassCount: Int = 6
            static let maximumPassCount: Int = 26
        }
        
        // MARK: - Public properties
        
        public static var `default`: WTextFieldPasswordConfigurator {
            return WTextFieldPasswordConfigurator(minimumPassCount: Constants.minimumPassCount,
                                                  maximumPassCount: Constants.maximumPassCount)
        }
        
        public static func defaultWithRegex(_ regex: String) -> WTextFieldPasswordConfigurator {
            return WTextFieldPasswordConfigurator(minimumPassCount: Constants.minimumPassCount,
                                                  maximumPassCount: Constants.maximumPassCount,
                                                  validationOptions: .defaultWithRegex(regex))
        }
        
        public let minimumPassCount: Int
        public let maximumPassCount: Int
        public let secureModIsEnable: Bool
        public let withSecureTogle: Bool
        public let showPassImage: UIImage
        public let hidePassImage: UIImage
        public let validationOptions: [ValidationOption]
        
        // MARK: - Initializer
        
        public init(minimumPassCount: Int,
                    maximumPassCount: Int,
                    secureModIsEnable: Bool,
                    withSecureTogle: Bool,
                    showPassImage: UIImage,
                    hidePassImage: UIImage,
                    validationOptions: [ValidationOption] = .default) {
            self.minimumPassCount = minimumPassCount
            self.maximumPassCount = maximumPassCount
            self.secureModIsEnable = secureModIsEnable
            self.withSecureTogle = withSecureTogle
            self.showPassImage = showPassImage
            self.hidePassImage = hidePassImage
            self.validationOptions = validationOptions
        }
        
        public init(minimumPassCount: Int,
                    maximumPassCount: Int,
                    secureConfig: SecureConfigurator = .default,
                    validationOptions: [ValidationOption] = .default) {

            self.init(minimumPassCount: minimumPassCount,
                      maximumPassCount: maximumPassCount,
                      secureModIsEnable: secureConfig.secureModIsEnable,
                      withSecureTogle: secureConfig.withSecureTogle,
                      showPassImage: secureConfig.showPassImage,
                      hidePassImage: secureConfig.hidePassImage,
                      validationOptions: validationOptions)
        }
    }
}

// MARK: - Array WTypedTextField.ValidationOption

public extension Array where Element == WTypedTextField.ValidationOption {
    
    static var `default`: [WTypedTextField.ValidationOption] {
        return [.specialSymbols, .upperAndLowerCased, .digits]
    }
    
    static func defaultWithRegex(_ regex: String) -> [WTypedTextField.ValidationOption] {
        return [.specialSymbols, .upperAndLowerCased, .digits, .passwordRegex(regex)]
    }
}
