//
//  WSeparatedCodeTextField.swift
//  WTextField
//
//  Created by Woddi on 09.03.2020.
//

import UIKit

class WSeparatedCodeTextField: WBaseTextField {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
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
    
    override func configureUI() {
        super.configureUI()
        textContentType = .oneTimeCode
        addSubview(stackView)
        addConstraints(stackView)
        updateSpacing()
    }
    
    override func becomeFirstResponder() -> Bool {
        if let field = firstEmptyField {
            return field.becomeFirstResponder()
        }
        return false
    }
}

// MARK: - Private methods

private extension WSeparatedCodeTextField {
    
    var firstEmptyField: WBaseTextField? {
        return stackView.arrangedSubviews
            .first(where: { ($0 as? WBaseTextField)?.text.isEmptyOrNil == true }) as? WBaseTextField
    }
    
    func updateSpacing() {
        stackView.spacing = fieldsSpacing
        handleCodeCharCount()
    }
    
    func handleCodeCharCount() {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        (0..<codeCharCount).forEach({
            let field = generateTextField(at: $0)
            field.bind { sender, event in
                if event == .valueChanged {
                    self.didChangeText(sender.text?.stringDigitsOnly(), in: sender, at: sender.tag)
                } else if case let BindEvent.beginOrEndEditting(isBegin) = event, isBegin {
                    self.fieldDidBeginEditing(sender)
                }
            }
            stackView.addArrangedSubview(field)
        })
    }
    
    func generateTextField(at index: Int) -> WMainTextField {
        let textField = WMainTextField()
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

