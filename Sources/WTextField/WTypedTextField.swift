//
//  WTypedTextField.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import UIKit

open class WTypedTextField: WStyledTextField {

    public enum WRightViewMode {
        case none
        case editButton(edit: UIImage, close: UIImage)
        case clear(UIImage)
        case custom(UIImage, selector: Selector)
    }
    
    // MARK: - Private properties
    private var isFieldActive = false

    private var datePicker: UIDatePicker = UIDatePicker()
    private var actionButton: UIButton = {
        let btn = UIButton(frame: CGRect(origin: .zero,
                                         size: CGSize(width: 23,
                                                      height: 23)))
        return btn
    }()
    
    private var bind: EditEventCallback?

    // MARK: - Public properties
        
    private(set) var defaultFormatterEnable: Bool = true
    private(set) var defaultValidatorEnable: Bool = true

    private(set) var validator: ValidatorProtocol?
    private(set) var formatter: FormaterProtocol?
    
    /// Type of data in TextField that will be handled by validator and formatter
    open var dataType: WTextFieldDataType = .none {
        didSet {
            updateTypeSettings()
        }
    }

    /// Change textfield rightView mode. Default is none
    open var customRightViewMode: WRightViewMode = .none {
        willSet (newRightViewMode) {
            switch newRightViewMode {
            case .none:
                rightViewMode = UITextField.ViewMode.never
            case .editButton(let normal, let selected):
                let size = CGSize.init(width: 22, height: 44)
                configureRightButton(size: size, action: #selector(editText), image: normal, selectedImage: selected)
            case .clear(let image):
                let size = CGSize.init(width: 22, height: 44)
                configureRightButton(size: size, action: #selector(clearText), image: image)
            case .custom(let image, let selector):
                let size = CGSize.init(width: 22, height: 44)
                configureRightButton(size: size, action: selector, image: image)
            }
        }
    }
    
    /// Returns result of setted validator. Returns false if data is not valid.
    /// If validator is not setted up - returns true.
    open var isValid: Bool {
        guard let validator = validator else {
            return true
        }
        return validator.validate(text ?? "") == nil
    }
    
    // MARK: - Life cycle
    
    override public func configureUI() {
        super.configureUI()

    }
    
    public override func bind(callback: @escaping WBaseTextField.EditEventCallback) -> WBaseTextField {
        bind = callback
        return super.bind(callback: callback)
    }
    
    public func formatter(bind: @escaping (String?) -> String?) -> WBaseTextField {
        formatter = ClosureFormatter(callback: bind)
        return self
    }
    
    public func validator(bind: @escaping (_ object: String) -> WTextFieldError?) -> WBaseTextField {
        validator = ClosureValidator(callback: bind)
        return self
    }
    
    public override func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if let formatter = formatter {
            formatter.processTextFieldText(textField,
                                           shouldChangeCharactersIn: range,
                                           replacementString: string,
                                           validator: validator)
            bind?(self, WBaseTextField.BindEvent.valueChanged)
            return false
        } 
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    open override func handleStyle(_ style: WStyledTextField.TextFieldStyle) {
        super.handleStyle(style)
        
        switch style {
        case .highlighted:
            if case WRightViewMode.editButton = customRightViewMode {
                actionButton.isSelected = true
                isFieldActive = true
            }
        case .notHighlighted:
            if case WRightViewMode.editButton = customRightViewMode {
                actionButton.isSelected = false
            }
        default: break
        }
    }

    func setBtnPassImageFor(style: TextFieldStyle) {
        let newNormalImage: UIImage?
        let newSelectedImage: UIImage?
        let normalPassImage = actionButton.image(for: .normal)
        let selectedPassImage = actionButton.image(for: .selected)
        switch style {
        case .highlighted:
            newNormalImage = normalPassImage?.imageWithColor(color: colorSet.selected)
            newSelectedImage = selectedPassImage?.imageWithColor(color: colorSet.selected)
        case .notHighlighted:
            newNormalImage = normalPassImage?.imageWithColor(color: colorSet.deselected)
            newSelectedImage = selectedPassImage?.imageWithColor(color: colorSet.deselected)
        case .error:
            newNormalImage = normalPassImage?.imageWithColor(color: colorSet.error)
            newSelectedImage = selectedPassImage?.imageWithColor(color: colorSet.error)
        }
        
        actionButton.setImage(newNormalImage, for: .normal)
        actionButton.setImage(newSelectedImage, for: .selected)
    }
    // MARK: - Public methods
    
}

// MARK: - Private methods

private extension WTypedTextField {
    
    func updateTypeSettings() {
        updateFormatterAndValidator()
        
        switch dataType {
        case .enterPassword(let config), .newPassword(let config):
            if case WTextFieldDataType.enterPassword = dataType {
                textContentType = .password
            } else {
                textContentType = .newPassword

            }
            isSecureTextEntry = config.secureModIsEnable
            setRightView(actionButton)
            actionButton.isSelected = isSecureTextEntry
            if config.withSecureTogle {
                actionButton.addTarget(self, action: #selector(showOrHidePassword(_:)), for: .touchUpInside)
            }
        case .email:
            keyboardType = .emailAddress
            spellCheckingType = .no
            autocorrectionType = .no
        case .phoneNumber(let config):
            if text.isEmptyOrNil {
                setText(config.countryCode)
            }
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
    
    func updateFormatterAndValidator() {
        if defaultFormatterEnable {
            formatter = dataType.defaultFormatter
        }
        if defaultValidatorEnable {
            validator = dataType.defaultValidator
        }
    }
    
    func configureRightButton(size: CGSize, action: Selector, image: UIImage, selectedImage: UIImage? = nil) {
        actionButton = UIButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        actionButton.addTarget(self, action: action, for: UIControl.Event.touchUpInside)
        actionButton.setImage(image, for: .normal)
        actionButton.setImage(selectedImage, for: .selected)
        actionButton.imageView?.contentMode = .scaleAspectFit
        rightViewMode = UITextField.ViewMode.always
        rightView = actionButton
        setRightView(actionButton, animated: false)
    }
}

// MARK: - Date picker

// MARK: - Settings

private extension WTypedTextField {
    
    func configureDatePickerWith(configure: WTextFieldDateConfigurator) -> UIDatePicker {
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
    
    @objc func editText() {
        if isFieldActive {
            isFieldActive = false
            resignFirstResponder()
        } else {
            actionButton.isSelected = true
            isFieldActive = true
            becomeFirstResponder()
        }
    }
    
    @objc func clearText() {
        if case WTextFieldDataType.phoneNumber(let config) = dataType {
            setText(config.countryCode)
        } else {
            setText("")
        }
        setRightView(nil)
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
