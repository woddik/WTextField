//
//  WSeparatedCodeTextField.swift
//  WTextField
//
//  Created by Woddi on 09.03.2020.
//

import UIKit

open class WSeparatedCodeTextField: WBaseTextField {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var separatedTFStyleType: WMainTextField.Type = WMainTextField.self
    
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
    
    open override var isSecureTextEntry: Bool {
        didSet {
            updateSecure()
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
}

// MARK: - Private methods

private extension WSeparatedCodeTextField {
    
    var firstEmptyField: WBaseTextField? {
        return stackView.arrangedSubviews
            .first(where: { ($0 as? WBaseTextField)?.text.isEmptyOrNil == true }) as? WBaseTextField
    }
    
    func updateSecure() {
        stackView.arrangedSubviews.forEach({ ($0 as? UITextField)?.isSecureTextEntry = isSecureTextEntry })
    }
    
    func updateSpacing() {
        stackView.spacing = fieldsSpacing
        handleCodeCharCount()
    }
    
    func handleCodeCharCount() {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        (0..<codeCharCount).forEach({
            let field = generateTextField(at: $0)
            field.bind { [weak self] sender, event in
                if event == .valueChanged {
                    self?.didChangeText(sender.text?.stringDigitsOnly(), in: sender, at: sender.tag)
                } else if case let BindEvent.beginOrEndEditting(isBegin) = event, isBegin {
                    self?.fieldDidBeginEditing(sender)
                }
            }
            stackView.addArrangedSubview(field)
        })
    }
    
    func generateTextField(at index: Int) -> WMainTextField {
        let textField = separatedTFStyleType.init()
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.tag = index
        textField.enable(fields: [.border])
        return textField
    }
    
    func fieldDidBeginEditing(_ field: WBaseTextField) {
        field.text = ""
    }
    
    func getField(at index: Int) -> WMainTextField? {
        return (stackView.arrangedSubviews as? [WMainTextField])?.first(where: { $0.tag == index })
    }
    
    func didChangeText(_ text: String?, in field: WBaseTextField, at index: Int) {
        guard let text = text else {
            return
        }
        if text.count > 1 {
            separatedCopiedTextByFields(text, fromCurrent: index)
            return
        }
        if text.isEmpty {
            getField(at: index - 1)?.becomeFirstResponder()
        } else if text.count == 1 && index == codeCharCount - 1 {
            endEditing(true)
        } else {
            getField(at: index + 1)?.becomeFirstResponder()
        }
    }
    
    func separatedCopiedTextByFields(_ text: String, fromCurrent index: Int) {
        guard text.count > 0 && index < codeCharCount else {
            return
        }
        let char = text[0]
        let field = getField(at: index)
        field?.text = "\(char)"
        if index == codeCharCount - 1 {
            endEditing(true)
        }
        separatedCopiedTextByFields(String(text.dropFirst()), fromCurrent: index + 1)
    }
}

