//
//  WStyledTextField.swift
//  WTextField
//
//  Created by Woddi on 04.03.2020.
//

import UIKit

private struct ColorConfigurator: WTextFieldColorSet {
    
    let selected: UIColor
    
    let deselected: UIColor
    
    let error: UIColor
    
    init(selected: UIColor = .black, deselected: UIColor = .black, error: UIColor = .black) {
        self.selected = selected
        self.deselected = deselected
        self.error = error
    }
    
    static var `default`: WTextFieldColorSet {
        return ColorConfigurator()
    }
    
    static var placeholder: WTextFieldColorSet {
        let color = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.3)
        return ColorConfigurator(selected: color, deselected: color, error: color)
    }
}

public protocol WTextFieldColorSet {
    
    var selected: UIColor { get }
    
    var deselected: UIColor { get }
    
    var error: UIColor { get }
    
}

open class WStyledTextField: WBaseTextField {
    
    public enum TextFieldStyle {
        case highlighted
        case notHighlighted
        case error
    }
    
    // MARK: - Public properties
    
    public private(set) var colorSet: WTextFieldColorSet = ColorConfigurator.default
    public private(set) var placeholderColorSet: WTextFieldColorSet = ColorConfigurator.placeholder

    // MARK: - Public methods
    
    public func changeStyleTo(style: TextFieldStyle, animated: Bool = true) {
        layoutIfNeeded()
        
        UIView.animate(withDecision: true, animations: { [weak self] in
            self?.handleStyle(style)
            if animated {
                self?.layoutIfNeeded()
            }
        }) {
            if !animated {
                self.layoutIfNeeded()
            }
        }
    }
    
    open func handleStyle(_ style: TextFieldStyle) {
        switch style {
        case .highlighted:
            textColor = colorSet.selected
            attributedPlaceholder = attributedPlaceholder?.changeOrAdd(attribute: .foregroundColor,
                                                                       value: placeholderColorSet.selected)
        case .notHighlighted:
            textColor = colorSet.deselected
            attributedPlaceholder = attributedPlaceholder?.changeOrAdd(attribute: .foregroundColor,
                                                                       value: placeholderColorSet.deselected)
        case .error:
            textColor = colorSet.error
            attributedPlaceholder = attributedPlaceholder?.changeOrAdd(attribute: .foregroundColor,
                                                                       value: placeholderColorSet.error)

        }
    }

}
