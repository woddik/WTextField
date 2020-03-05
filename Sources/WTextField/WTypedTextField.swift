//
//  WTypedTextField.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import UIKit

public protocol FormaterProtocol {
    
    func format(string: String?) -> String?
    
//    func processTextFieldText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
//                              replacementString string: String)
}

public protocol ValidatorProtocol {
    
    func validate(_ object: String) -> WTextFieldError?
    
}

open class WTypedTextField: WStyledTextField {
    
    private(set) var defaultFormatterEnable: Bool = true
    private(set) var defaultValidatorEnable: Bool = true

    private var datePicker: UIDatePicker = UIDatePicker()
    private var actionButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero,
                                         size: CGSize(width: 23,
                                                      height: 23)))
        return btn
    }()
    
    private var validator: ValidatorProtocol?
    private var formatter: FormaterProtocol?
    
    /// Type of data in TextField that will be handled by validator and formatter
    open var dataType: WTextFieldDataType = .none {
        didSet {
            updateTypeSettings()
        }
    }

    // MARK: - Life cycle
    
    override public func configureUI() {
        super.configureUI()
        if defaultFormatterEnable {
            formatter = dataType.defaultFormatter
        }
        if defaultValidatorEnable {
            validator = dataType.defaultValidator
        }
    }
    
    // MARK: - Public methods

    
}

// MARK: - Private methods

private extension WTypedTextField {
    
    func updateTypeSettings() {
        switch dataType {
        case .enterPassword:
            textContentType = .password
            isSecureTextEntry = true
            setRightView(actionButton)
            actionButton.isSelected = isSecureTextEntry
            actionButton.addTarget(self, action: #selector(showOrHidePassword(_:)), for: .touchUpInside)
        case .newPassword:
            if #available(iOS 12.0, *) {
                textContentType = .newPassword
            }
            isSecureTextEntry = true
            setRightView(actionButton)
            actionButton.isSelected = isSecureTextEntry
            actionButton.addTarget(self, action: #selector(showOrHidePassword(_:)), for: .touchUpInside)
        case .email:
            keyboardType = .emailAddress
            spellCheckingType = .no
            autocorrectionType = .no
        case .phoneNumber:
            keyboardType = .numberPad
        case .expirationDate:
            keyboardType = .numberPad
        case .card:
            keyboardType = .numberPad
        case .topUpCost:
            keyboardType = .decimalPad
        case .transferByCardCost:
            keyboardType = .decimalPad
        case .cvv:
            keyboardType = .numberPad
            isSecureTextEntry = true
        case .creditCardName:
            keyboardType = .alphabet
        case .date(let config):
            datePicker = configureDatePickerWith(configure: config)
            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
            inputView = datePicker
        case .numberOnly:
            keyboardType = .numberPad
        case .decimalOnly:
            keyboardType = .decimalPad
        case .smsCode:
            keyboardType = .numberPad
        case .name:
            keyboardType = .alphabet
        case .pinCode:
            keyboardType = .numberPad
            isSecureTextEntry = true
        case .moneyAmount:
            keyboardType = .decimalPad
        case .none:
            formatter = nil
            validator = nil
            fallthrough
        default:
            keyboardType = .default
            isSecureTextEntry = false
            inputView = nil
            datePicker.removeTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
    }
}

// MARK: - Date picker

// MARK: - DateConfigurator

public extension WTypedTextField {
    
    struct DateConfigurator {
        let minimumDate: Date
        let maximumDate: Date
        let mode: UIDatePicker.Mode
        let locale: Locale
        let dateFormate: String
        
        init(dateFormate: String, minimumDate: Date, maximumDate: Date, mode: UIDatePicker.Mode = .date, locale: Locale) {
            self.dateFormate = dateFormate
            self.minimumDate = minimumDate
            self.maximumDate = maximumDate
            self.mode = mode
            self.locale = locale
        }
    }
}

// MARK: - Settings

private extension WTypedTextField {
    
    func configureDatePickerWith(configure: DateConfigurator) -> UIDatePicker {
        return configureDatePicker(minimumDate: configure.minimumDate,
                                   maximumDate: configure.maximumDate,
                                   mode: configure.mode,
                                   locale: configure.locale)
    }
    
    func configureDatePicker(minimumDate: Date,
                             maximumDate: Date,
                             mode: UIDatePicker.Mode,
                             locale: Locale) -> UIDatePicker {
        datePicker.datePickerMode = mode
        datePicker.locale = locale
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        
        return datePicker
    }
    
    //=========================================================
    // MARK: - Helpers
    //=========================================================
    func currentLocale() -> Locale {
        switch Locale.current.languageCode ?? "" {
        case "uk":
            return Locale.init(identifier: "uk_UA")
        case "ru":
            return Locale.init(identifier: "ru_RU")
        default:
            return Locale.init(identifier: "en_US")
        }
    }
}

// MARK: - Private methods

private extension WTypedTextField {
    
    enum PMCTextFieldViewPosition {
        case left
        case right
    }
    
    func setSideView(_ customView: UIView?, position: PMCTextFieldViewPosition, animated: Bool = true) {
        let newSideViewMode: UITextField.ViewMode = customView != nil ? .always : .never
        let oldSideViewMode: UITextField.ViewMode = position == .left ? leftViewMode : rightViewMode
        
        if newSideViewMode != oldSideViewMode {
            let alpha: CGFloat = customView == nil ? 1 : 0
            customView?.alpha = alpha
            UIView.animate(withDecision: animated,
                           animations: { [weak self] in
                            if position == .left {
                                self?.leftView = customView
                                self?.leftViewMode = newSideViewMode
                            } else {
                                self?.rightView = customView
                                self?.rightViewMode = newSideViewMode
                            }
                            if animated {
                                self?.layoutIfNeeded()
                            }
                }, completion: {
                    UIView.animate(withDecision: animated,
                                   animations: {
                                    customView?.alpha = 1 - alpha
                    })
            })
        }
    }
}

// MARK: - Actions

private extension WTypedTextField {
    
    @objc func showOrHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = !isSecureTextEntry
        if isFirstResponder {
            let tmpText = text
            text = nil
            text = tmpText
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker?) {
        guard let datePicker = sender, case WTextFieldDataType.date(let config) = dataType else {
            return
        }
        let formater = DateFormatter()
        formater.dateFormat = config.dateFormate//"dd.MM.yyyy"
        
        text = formater.string(from: datePicker.date)
        sendActions(for: .editingChanged)
    }
}

// MARK: - Right view settings

public extension WTypedTextField {
    
    /// Setting custom view to right view in textfield
    ///
    /// - Parameters:
    ///   - rightView: Custom right view
    ///   - animated: Show view with animation
    func setRightView(_ view: UIView?, animated: Bool = true) {
        setSideView(view, position: .right, animated: animated)
    }
    
    /// Setting custom view to left view in textfield
    ///
    /// - Parameters:
    ///   - leftView: Custom left view
    ///   - animated: Show view with animation
    func setLeftView(_ view: UIView?, animated: Bool = true) {
        setSideView(view, position: .left, animated: animated)
    }
    
    
}
