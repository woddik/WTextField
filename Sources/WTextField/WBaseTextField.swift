
import UIKit

open class WBaseTextField: UITextField {
    
    public typealias EditEventCallback = ((_ sender: WBaseTextField, _ event: BindEvent) -> Void)
    public typealias ActionEventCallback = ((_ sender: WBaseTextField, _ event: BindEventAction) -> Void)
    
    public enum BindEvent: Equatable {
        case valueChanged
        case beginOrEndEditting(isBegin: Bool)
    }
    
    public enum BindEventAction: Equatable {
        case `return`
        case clear
        case backspace
    }
    
    // MARK: - Initializer
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
        configureUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
        configureUI()
    }
    
    // MARK: - Private properties
    
    private var bind: EditEventCallback?
    private var bindActions: ActionEventCallback?

    private weak var customDelegate: UITextFieldDelegate?
    
    private var heightConstraint = NSLayoutConstraint()

    private var paddingIncludedVies: UIEdgeInsets {
        return UIEdgeInsets(top: padding.top,
                            left: padding.left + (leftView == nil ? 0 : 8),
                            bottom: padding.bottom,
                            right: padding.right)
    }
    // MARK: - Public properties
    
    open var fieldHeight: CGFloat {
        let tmpTextField = UITextField()
        tmpTextField.font = font
        tmpTextField.sizeToFit()
        return tmpTextField.bounds.height
    }

    open var totalHeight: CGFloat {
        return fieldHeight
    }
    
    open var padding: UIEdgeInsets {
        return .zero
    }
    
    // MARK: - Life cycle
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if newSuperview is UIStackView {
            heightConstraint.priority = UILayoutPriority.init(1000)
        }
    }
    
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let res = super.resignFirstResponder()
        setNeedsLayout()
        layoutIfNeeded()
        return res
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.textRect(forBounds: bounds)
        return origin.inset(by: paddingIncludedVies)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.placeholderRect(forBounds: bounds)
        return origin.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let origin = super.editingRect(forBounds: bounds)
        return origin.inset(by: paddingIncludedVies)
    }
    
    override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.rightViewRect(forBounds: bounds)
        let diff = padding.top - newRect.size.height / 2 + 7
        newRect.origin.y = diff
        
        return newRect
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.leftViewRect(forBounds: bounds)
        let diff = padding.top - newRect.size.height / 2 + 7
        newRect.origin.y = diff
        
        return newRect
    }
    
    override open var delegate: UITextFieldDelegate? {
        get {
            return customDelegate
        }
        set {
            customDelegate = newValue
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint.constant = totalHeight
    }
    
    // MARK: - Public methods
    
    /// method calling after any init
    open func configureUI() { }
    
    open override func deleteBackward() {
        super.deleteBackward()
        bindActions?(self, .backspace)
    }
    
    /// set callback action for observe WBaseTextField has change text value
    @discardableResult
    public func bind(callback: @escaping EditEventCallback) -> WBaseTextField {
        bind = callback
        return self
    }
    
    /// set callback action for observe WBaseTextField ccomplete action
    @discardableResult
    public func bindAction(callback: @escaping ActionEventCallback) -> WBaseTextField {
        bindActions = callback
        return self
    }
    
    public func setPlaceholderColor(_ color: UIColor) {
        let placeholder = self.placeholder ?? attributedPlaceholder?.string ?? ""
            
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: color])
    }
    
    /// Setting text to textField.
    /// - Parameters:
    ///   - newText: Simple text
    ///   - withFormating: use current formatter and return formated text in callback if exist
    open func setText(_ newText: String?, withFormating: Bool = true) {
        text = newText
        if withFormating {
            _ = textField(self, shouldChangeCharactersIn: NSRange.init(location: 0, length: 0), replacementString: "")
        }
    }
}

// MARK: - Private methods

private extension WBaseTextField {
    
    func setupDefaults() {
        super.delegate = self
        
        borderStyle = .none
        contentVerticalAlignment = .top
        heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: totalHeight)
        heightConstraint.priority = UILayoutPriority.init(900)
        
        NSLayoutConstraint.activate([heightConstraint])
        
        addTarget(self, action: #selector(didChangeText(_:)), for: .editingChanged)
    }

}

// MARK: - Private methods

private extension WBaseTextField {
    
    @IBAction func didChangeText(_ sender: WBaseTextField) {
        bind?(self, .valueChanged)
    }
}

// MARK: - UITextFieldDelegate

extension WBaseTextField: UITextFieldDelegate {

    @available(iOS 2.0, *)
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return customDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        bind?(self, .beginOrEndEditting(isBegin: true))
        customDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return customDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField) {
        bind?(self, .beginOrEndEditting(isBegin: false))
        customDelegate?.textFieldDidEndEditing?(textField)
    }
    
    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        bind?(self, .beginOrEndEditting(isBegin: false))
        customDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    
    @available(iOS 2.0, *)
    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return customDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
    
    
    @available(iOS 2.0, *)
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        bindActions?(self, .clear)
        return customDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    @available(iOS 2.0, *)
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bindActions?(self, .return)
        return customDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
}
