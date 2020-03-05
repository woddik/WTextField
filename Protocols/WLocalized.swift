//
//  WLocalized.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import UIKit

// MARK: - Localized

/**
 For example: 'Localized'
 
 enum MainStrings: String, Localized  {
    case title
    case subTitle = "sub_title"
 }
 
 enum OtherString: EnumLocalized  {
    case mainText
 }
 
 ->| In Localisable.strings file should be:
 
 MainStrings.title = "Some text";
 MainStrings.sub_title = "Some text";
 
 OtherString.mainText = "Some text"
 
 Use case:
 
 myLabel.text = OtherString.mainText.key
 */

/**
 Description: LocalizedImages
 working like 'Localized', but property imageValue will return UIImage? that will get by localized 'key'
 where key or rawValue MUST be the same as image name in 'Assets'
 */

protocol Localized {
    
    var key: String { get }
    
}

extension Localized where Self: RawRepresentable, Self.RawValue == String {
    
    var key: String {
        return NSLocalizedString("\(type(of: self)).\(rawValue)", comment: "")
    }
    
}

protocol EnumLocalized: Localized { }

extension EnumLocalized {
    
    var key: String {
        return NSLocalizedString("\(type(of: self)).\(self)", comment: "")
    }
    
}

protocol ErrorEnumLocalized: Error, EnumLocalized {
    
    var asError: WTextFieldErorr { get }
    
    func asErrorWith(code: Int) -> WTextFieldErorr
}

extension ErrorEnumLocalized {
    
    var asError: WTextFieldErorr {
        return asErrorWith(code: 0)
    }
    
    func asErrorWith(code: Int) -> WTextFieldErorr {
        return WTextFieldErorr(value: self, code: code)
    }
    
}

protocol LocalizedImages: EnumLocalized { }

extension LocalizedImages {
    
    var imageValue: UIImage? {
        return UIImage(named: key)
    }
}
