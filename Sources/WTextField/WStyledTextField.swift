//
//  WStyledTextField.swift
//  WTextField
//
//  Created by Woddi on 04.03.2020.
//

import UIKit

public struct ColorConfigurator: WTextFieldColorSet {
    
    public let selected: UIColor
    
    public let deselected: UIColor
    
    public let error: UIColor
    
    public init(selected: UIColor = .black, deselected: UIColor = .black, error: UIColor = .black) {
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
    
    static var customPlaceholder: WTextFieldColorSet {
        return commonStyle
    }
    
    static var error: WTextFieldColorSet {
        return commonStyle
    }
    
    static var border: WTextFieldColorSet {
        return commonStyle
    }
    
    private static var commonStyle: WTextFieldColorSet {
        let deselectedColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.3)
        return ColorConfigurator(selected: .black, deselected: deselectedColor, error: .red)
    }
}

open class WStyledTextField: WBaseTextField {
    
    public enum TextFieldStyle {
        case highlighted
        case notHighlighted
        case error
    }
    
    // MARK: - Public properties
    
    open private(set) var colorSet: WTextFieldColorSet = ColorConfigurator.default
    open private(set) var placeholderColorSet: WTextFieldColorSet = ColorConfigurator.placeholder

    public private(set) var currentStyle: TextFieldStyle = .notHighlighted
    
    // MARK: - Public methods
    
    public func changeStyleTo(style: TextFieldStyle, animated: Bool = true) {
        currentStyle = style
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
