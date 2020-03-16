//
//  WSeparatedCodeTextField.swift
//  WTextField
//
//  Created by Woddi on 09.03.2020.
//

import UIKit

open class WSeparatedCodeTextField: WBaseTextField {
    
    fileprivate enum UpdatingType {
        case font
        case keyboardStyle
        case secure
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var separatedTFStyleType: WMainTextField.Type = WMainTextField.self
    
    private var bind: EditEventCallback?
    
    private var cache: [Int: String] = [:]
    
    // MARK: - Public properties
    
    public var codeCharCount: Int = 4 {
        didSet {
            handleCodeCharCount()
        }
    }
    
    public var fieldsSpacing: CGFloat = 32 {
        didSet {
            updateSpacing()
        }
    }
    
    // MARK: - Life cycle
    
    open override var text: String? {
        get {
            return collectText()
        }
        set {
            if let textField = stackView.arrangedSubviews.first as? WMainTextField {
                didChangeText(newValue ?? "", in: textField, at: 0)
            }
        }
    }
    
    open override var isSecureTextEntry: Bool {
        didSet {
            updateSubFields(element: .secure)
        }
    }
    
    open override var font: UIFont? {
        didSet {
            updateSubFields(element: .font)
        }
    }
    
    open override var keyboardAppearance: UIKeyboardAppearance {
        didSet {
            updateSubFields(element: .keyboardStyle)
        }
    }
    
    override open func configureUI() {
        super.configureUI()
        textContentType = .oneTimeCode
        addSubview(stackView)
        addConstraints(stackView)
        updateSpacing()
    }
    
    override open func becomeFirstResponder() -> Bool {
        if let field = firstEmptyField {
            return field.becomeFirstResponder()
        }
        return false
    }
    
    // MARK: - Public methods
    
    /// Set text field with your style for displaing, WBaseTextField as default
    /// - Parameter type: Separated TF style
    public func setTextStyle<T: WMainTextField>(as type: T.Type) {
        separatedTFStyleType = type
        handleCodeCharCount()
    }
    
    /// set callback action for observe WBaseTextField has change text value
    @discardableResult
    public override func bind(callback: @escaping EditEventCallback) -> WBaseTextField {
        bind = callback
        return self
    }
    
}

// MARK: - Private methods

private extension WSeparatedCodeTextField {
    
    var firstEmptyField: WBaseTextField? {
        return stackView.arrangedSubviews
            .first(where: { ($0 as? WBaseTextField)?.text.isEmptyOrNil == true }) as? WBaseTextField
    }

    func updateSubFields(element: UpdatingType) {
        stackView.arrangedSubviews.forEach({
            let textField = ($0 as? UITextField)
            switch element {
            case .font:
                textField?.font = font
            case .keyboardStyle:
                textField?.keyboardAppearance = keyboardAppearance
            case .secure:
                textField?.isSecureTextEntry = isSecureTextEntry
            }
        })

    }

    func updateSpacing() {
        stackView.spacing = fieldsSpacing
        handleCodeCharCount()
    }
    
    func handleCodeCharCount() {
        cache.removeAll()
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        (0..<codeCharCount).forEach({
            self.cache[$0] = ""
            let field = generateTextField(at: $0)
            field.bind { [weak self] sender, event in
                guard let text = sender.text?.stringDigitsOnly() else {
                    return
                }
                if event == .valueChanged {
                    let index = sender.tag
                    if text.count > 1 {
                        let handledText = self?.cache[index]?.count == 0 ? text : String(text.dropFirst())
                        self?.separatePastedTextByFields(handledText, fromCurrent: index)
                    } else {
                        self?.didChangeText(text, in: sender, at: index)
                    }
                }
            }.bindAction { [weak self] sender, event in
                if event == .backspace {
                    self?.handleBackspaceActionField(at: sender.tag)
                }
            }
            stackView.addArrangedSubview(field)
        })
    }
    
    func generateTextField(at index: Int) -> WMainTextField {
        let textField = separatedTFStyleType.init()
        textField.keyboardAppearance = keyboardAppearance
        textField.font = font
        textField.isSecureTextEntry = isSecureTextEntry
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.tag = index
        textField.enable(fields: [.border])
        return textField
    }
    
    func getField(at index: Int) -> WMainTextField? {
        return (stackView.arrangedSubviews as? [WMainTextField])?.first(where: { $0.tag == index })
    }
    
    func didChangeText(_ text: String, in field: WBaseTextField, at index: Int) {
        if text.isEmpty {
            
        } else if text.count == 1 && index == codeCharCount - 1 {
            endEditing(true)
        } else {
            getField(at: index + 1)?.becomeFirstResponder()
        }
        cache[index] = text
        bind?(self, .valueChanged)
    }
    
    func handleBackspaceActionField(at index: Int) {
        getField(at: index - 1)?.becomeFirstResponder()
    }
    
    func separatePastedTextByFields(_ str: String, fromCurrent index: Int) {
        guard str.count > 0 && index < codeCharCount else {
            return
        }
        guard let field = getField(at: index) else {
            return
        }
        let charText = "\(str[0])"
        field.text = charText
        didChangeText(charText, in: field, at: index)

        separatePastedTextByFields(String(str.dropFirst()), fromCurrent: index + 1)
    }
    
    func collectText() -> String {
        return stackView.arrangedSubviews.compactMap({ ($0 as? UITextField)?.text }).joined()
    }
}
