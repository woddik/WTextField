//
//  WMainTextField.swift
//  WTextField
//
//  Created by Woddi on 07.03.2020.
//

import UIKit

open class WMainTextField: WTypedTextField {
    
    public enum Element: TextFieldColorSet, CaseIterable, Hashable {
        case customPlaceHolder
        case border
        case error
        
        public var selected: UIColor {
            switch self {
            case .customPlaceHolder: return .black
            case .border: return .black
            case .error: return .black
            }
        }
        
        public var deselected: UIColor {
            switch self {
            case .customPlaceHolder: return .lightGray
            case .border: return .lightGray
            case .error: return .lightGray
            }
        }
        
        public var error: UIColor {
            switch self {
            case .customPlaceHolder: return .red
            case .border: return .red
            case .error: return .red
            }
        }
    }

    // MARK: - Private properties
    
    private let lblCustomPlaceholder = UILabel()
    private let viewBorder = SeparatorView()
    private let lblError = UILabel()
    
    private var placeholderIsSmall: Bool = false
    
    private var separatorCalculatedTopInset: CGFloat {
        var height: CGFloat = fieldHeight
        height += separatorTopInset < 0 ? 0 : separatorTopInset
        height += enabledFields.contains(.customPlaceHolder) ? topInsetForCustomPlaceholder : 0
        return height
    }
    
    // MARK: - Public properties
    
    // MARK: - Error label
    
    open var errorLabelDistanceToSelf: CGFloat { 0 }
    public var errorLabelHeight: CGFloat? {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Text wich will be shown as error
    open var errorText: String? {
        get {
            return lblError.text
        }
        set {
            lblError.text = newValue
            if newValue.isEmptyOrNil {
                changeStyleTo(style: isFirstResponder ? .highlighted : .notHighlighted)
            }
            setNeedsLayout()
        }
    }
    
    open var errorLabelVisibleOnlyWhenError: Bool = true {
        didSet {
            lblError.alpha = errorLabelVisibleOnlyWhenError ? currentStyle == .error ? 1 : 0 : 1
        }
    }

    // MARK: - Custom Placeholder
    
    open var placeholderHeight: CGFloat { 22 }
    open var customPlaceholderUppedHeight: CGFloat { 13 }
    open var uppedPlaceholderTopInset: CGFloat { 8 }
    open var topInsetForCustomPlaceholder: CGFloat { 26 }
    open var customPlaceholderScale: CGFloat { 0.65 }

    open var customPlaceholderText: String? {
        get {
            return lblCustomPlaceholder.text
        }
        set {
            lblCustomPlaceholder.text = newValue
            if lblCustomPlaceholder.bounds.size.width == 0 {
                lblCustomPlaceholder.sizeToFit()
                updateCustomPlaceholder()
            }
        }
    }
    
    open var customPlaceholderTextColor: UIColor? {
        didSet {
            lblCustomPlaceholder.textColor = customPlaceholderTextColor
        }
    }
    
    // MARK: - Separator
    
    open var separatorTopInset: CGFloat { 0 }
    open var separatorViewHeight: CGFloat { 1 }
    
    // MARK: - Colors
    open var customPlaceholderColorSet: TextFieldColorSet {
        return Element.customPlaceHolder
    }
    
    open var borderColorSet: TextFieldColorSet {
        return Element.border
    }
    
    open var errorColorSet: TextFieldColorSet {
        return Element.error
    }
    
    // MARK: - Fonts
    
    private(set) var customPlaceholderFont: UIFont = .systemFont(ofSize: 14)
    private(set) var errorLabelFont: UIFont = .systemFont(ofSize: 12)
    
    // MARK: -
    
    open private(set) var enabledFields: [Element] = Element.allCases
    
    open override var totalHeight: CGFloat {
        let height = super.totalHeight
        
        let separatoInFrameInset = separatorTopInset < 0 ? 0 : separatorTopInset
        var resultHeight = height + separatorViewHeight + separatoInFrameInset + errorLabelDistanceToSelf
        resultHeight += errorLabelHeight ?? lblError.bounds.height
        resultHeight += enabledFields.contains(.customPlaceHolder) ? topInsetForCustomPlaceholder : 0
        
        return resultHeight
    }

    // MARK: - Life cycle
    
    open override var placeholder: String? {
        didSet {
            movePlaceholderUp(animated: false)
        }
    }
    
    /// Insets for text in textField
    open override var padding: UIEdgeInsets {
        return UIEdgeInsets(top: enabledFields.contains(.customPlaceHolder) ? topInsetForCustomPlaceholder : 0,
                            left: 0,
                            bottom: 0,
                            right: 0)
        
    }
    
    public override func configureUI() {
        super.configureUI()
        updateViewElements()
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        if let errorLabelHeight = errorLabelHeight,
            let errorHeightConstraint = lblError.constraints.first(where: { $0 == lblError.heightAnchor }) {
            errorHeightConstraint.constant = errorLabelHeight
        } else if let errorLabelHeight = errorLabelHeight {
            lblError.heightAnchor.constraint(equalToConstant: errorLabelHeight).isActive = true
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateCustomPlaceholder()
    }
    
    open func setText(_ newText: String?, withFormating: Bool = true, animated: Bool = false) {
        super.setText(newText, withFormating: withFormating)
        guard let newText = newText, let customPlaceholderText = customPlaceholderText else {
            return
        }
        
        if newText.isEmpty && !customPlaceholderText.isEmpty {
            movePlaceholderDown(animated: animated)
        } else {
            movePlaceholderUp(animated: animated)
        }
    }
    
    open override func setText(_ newText: String?, withFormating: Bool = true) {
        setText(newText, withFormating: withFormating, animated: false)
    }
    
    open override func handleStyle(_ style: WStyledTextField.TextFieldStyle) {
        super.handleStyle(style)
        
        switch style {
        case .highlighted:
            viewBorder.backgroundColor = borderColorSet.selected
            if errorLabelVisibleOnlyWhenError {
                lblError.alpha = 0
            }
            lblError.textColor = errorColorSet.selected
            lblCustomPlaceholder.textColor = customPlaceholderColorSet.selected
            
        case .notHighlighted:
            viewBorder.backgroundColor = borderColorSet.deselected
            if errorLabelVisibleOnlyWhenError {
                lblError.alpha = 0
            }
            lblError.textColor = errorColorSet.deselected
            lblCustomPlaceholder.textColor = customPlaceholderColorSet.deselected
        case .error:
            viewBorder.backgroundColor = borderColorSet.error
            if errorLabelVisibleOnlyWhenError {
                lblError.alpha = 1
            }
            lblError.textColor = errorColorSet.error
            lblCustomPlaceholder.textColor = customPlaceholderColorSet.error

        }
        setNeedsLayout()

    }
    
    // MARK: - Public methods
    
    /// Choose enabled fields type
    public func enable(fields: [Element]) {
        enabledFields = Array(Set(fields))
        updateViewElements()
    }
    
    /// Remove placeholder and move placeholder text down for any data type
    public func removeDefaultPlaceholder() {
        placeholder = nil
        movePlaceholderDown(animated: false)
    }
    
    /// Fill separator with color above default color
    /// - Parameters:
    ///   - color: filled color
    ///   - percent: percent of separator lengh for filling strart from 0 to 1
    func fillSeparator(with color: UIColor, by percent: CGFloat) {
        viewBorder.fill(with: color, by: percent)
    }
    
    /// Use it when textfield needs to show error message
    open func showError(text: String? = nil) {
        if let text = text {
            errorText = text
        }
        changeStyleTo(style: .error, animated: false)
    }
    
    open func showValidationError(animated: Bool = false) {
        let validationResult = validator?.validate(text ?? "")
        errorText = validationResult?.message
        changeStyleTo(style: .error, animated: animated)
    }
}

// MARK: - Private methods

private extension WMainTextField {
    
    func allEnabledViews() -> [UIView] {
        return enabledFields.compactMap { viewFor(type: $0) }
    }
    
    func viewFor(type: Element) -> UIView {
        switch type {
        case .customPlaceHolder: return lblCustomPlaceholder
        case .border: return viewBorder
        case .error: return lblError
        }
    }
    
    func updateViewElements() {
        lblCustomPlaceholder.removeFromSuperview()
        lblError.removeFromSuperview()
        viewBorder.removeFromSuperview()
        
        enabledFields.forEach({
            switch $0 {
            case .customPlaceHolder:
                setupCustomPlaceholder()
            case .border:
                setupBorderView()
            case .error:
                setupErrorLabelWith()
            }
        })
    }

}

//=========================================================
// MARK: - Custom placeholder handling
//=========================================================
private extension WMainTextField {
    
    func setupCustomPlaceholder() {
        addSubview(lblCustomPlaceholder)
        var newRect = textRect(forBounds: bounds)
        newRect.origin.y = padding.top
        newRect.size.height = placeholderHeight
        lblCustomPlaceholder.frame = newRect
        lblCustomPlaceholder.font = customPlaceholderFont
        lblCustomPlaceholder.adjustsFontSizeToFitWidth = true
    }
    
    func updateCustomPlaceholder() {
        guard lblCustomPlaceholder.superview != nil else {
            return
        }
        if placeholderIsSmall {
            let newWidth = bounds.size.width * customPlaceholderScale
            lblCustomPlaceholder.frame = CGRect(x: 0,
                                            y: uppedPlaceholderTopInset,
                                            width: newWidth,
                                            height: customPlaceholderUppedHeight)
        } else {
            var newRect = textRect(forBounds: bounds)
            newRect.origin.y = padding.top
            newRect.size.height = customPlaceholderUppedHeight
            lblCustomPlaceholder.frame = newRect
        }
    }
    
    func movePlaceholderUp(animated: Bool) {
        guard !placeholderIsSmall else {
            return
        }
        
        placeholderIsSmall = true
        UIView.animate(withDecision: animated, animations: { [weak self] in
            self?.movePlaceholderToTop()
        })
    }
    
    func movePlaceholderDown(animated: Bool) {
        guard placeholderIsSmall, placeholder?.isEmpty ?? true else {
            return
        }
        
        placeholderIsSmall = false
        UIView.animate(withDecision: animated, animations: { [weak self] in
            self?.movePlaceholderToBottom()
        })
    }
    
    func movePlaceholderToTop() {
        let newWidth = frame.width * customPlaceholderScale
        lblCustomPlaceholder.transform = lblCustomPlaceholder.transform.scaledBy( x: customPlaceholderScale,
                                                                                  y: customPlaceholderScale)
        lblCustomPlaceholder.frame = CGRect(x: 0,
                                            y: uppedPlaceholderTopInset,
                                            width: newWidth,
                                            height: customPlaceholderUppedHeight)
    }
    
    func movePlaceholderToBottom() {
        lblCustomPlaceholder.transform = lblCustomPlaceholder.transform.scaledBy( x: 1 / customPlaceholderScale,
                                                                                    y: 1 / customPlaceholderScale)
        var newRect = textRect(forBounds: bounds)
        newRect.origin.y = padding.top
        newRect.size.height = placeholderHeight
        lblCustomPlaceholder.frame = newRect
    }
}

//=========================================================
// MARK: - Error label handling
//=========================================================
private extension WMainTextField {
    
    private func setupErrorLabelWith() {
        addSubview(lblError)
        
        lblError.font = errorLabelFont
        lblError.translatesAutoresizingMaskIntoConstraints = false
        lblError.isExclusiveTouch = false
        lblError.numberOfLines = 0
        lblError.lineBreakMode = .byWordWrapping
        var tmpConstraints = [lblError.leftAnchor.constraint(equalTo: leftAnchor),
                              lblError.rightAnchor.constraint(equalTo: rightAnchor),
                              bottomAnchor.constraint(equalTo: lblError.bottomAnchor,
                                                      constant: errorLabelDistanceToSelf)]
        if let height = errorLabelHeight {
            tmpConstraints.append(lblError.heightAnchor.constraint(equalToConstant: height))
        }
        NSLayoutConstraint.activate(tmpConstraints)
    }
}

//=========================================================
// MARK: - Border view handling
//=========================================================
private extension WMainTextField {
    
    func setupBorderView() {
        addSubview(viewBorder)
        viewBorder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([viewBorder.leftAnchor.constraint(equalTo: leftAnchor),
                                     viewBorder.rightAnchor.constraint(equalTo: rightAnchor),
                                     viewBorder.topAnchor.constraint(equalTo: topAnchor,
                                                                        constant: separatorCalculatedTopInset),
                                     viewBorder.heightAnchor.constraint(equalToConstant: separatorViewHeight)])
    }
}
