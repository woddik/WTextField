
import UIKit

open class WBaseTextField: UITextField {
    
    typealias EditEventCallback = ((_ sender: WBaseTextField, _ event: BindEvent) -> Void)
    typealias ActionEventCallback = ((_ sender: WBaseTextField, _ event: BindEventAction) -> Void)
    
    enum BindEvent: Equatable {
        case valueChanged
        case beginOrEndEditting(isBegin: Bool)
    }
    
    enum BindEventAction: Equatable {
        case `return`
        case clear
    }
    
    // MARK: - Initializer
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefaults()
    }
    
    // MARK: - Private properties
    
    private let padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private var bind: EditEventCallback?
    private var bindActions: ActionEventCallback?

    private weak var customDelegate: UITextFieldDelegate?
    
    // MARK: - Life cycle
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open var delegate: UITextFieldDelegate? {
        get {
            return customDelegate
        }
        set {
            customDelegate = newValue
        }
    }
    
    // MARK: - Public methods
    
    /// set callback action for observe PMCTextField has change text value
    @discardableResult
    func bind(callback: @escaping EditEventCallback) -> WBaseTextField {
        bind = callback
        return self
    }
    
    /// set callback action for observe PMCTextField has change text value
    @discardableResult
    func bindAction(callback: @escaping ActionEventCallback) -> WBaseTextField {
        bindActions = callback
        return self
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        let placeholder = self.placeholder ?? ""
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:[.foregroundColor: color])
    }
}

// MARK: - Private methods

private extension WBaseTextField {
    
    func setupDefaults() {
        super.delegate = self
        
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
