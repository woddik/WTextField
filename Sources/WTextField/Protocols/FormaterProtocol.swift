//
//  FormaterProtocol.swift
//  StarWallet
//
//  Created by Woddi on 05.03.2020.
//  Copyright © 2020 Woddi. All rights reserved.
//

import UIKit

public protocol FormaterProtocol {
    
    func format(string: String?) -> String?
    
    func processTextFieldText(_ textField: UITextField,
                              shouldChangeCharactersIn range: NSRange,
                              replacementString string: String,
                              validator: ValidatorProtocol?)
    
    func deleteOneCharIn(text: String,
                         textField: UITextField,
                         shouldChangeCharactersIn range: NSRange,
                         replacementString string: String)
}

public extension FormaterProtocol {
    
    func processTextFieldText(_ textField: UITextField,
                              shouldChangeCharactersIn range: NSRange,
                              replacementString string: String,
                              validator: ValidatorProtocol?) {
        
        defaultProcessTextFieldText(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    func defaultProcessTextFieldText(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                                     replacementString string: String) {
        let text = textField.text ?? ""
        let numbersSet = CharacterSet.init(charactersIn: "0123456789.")
        
        if string.isEmpty && range.length == 1 {
            deleteOneCharIn(text: text, textField: textField,
                            shouldChangeCharactersIn: range, replacementString: string)
            return
        } else if range.length > 1 {
            var temp = text.cut(fromIndex: range.location, toIndex: range.location + range.length) ?? ""
            temp = temp.insert(string: string, fromIndex: range.location)
            textField.text = format(string: temp)
            guard let newPosition = textField.position(from: textField.beginningOfDocument,
                                                       offset: range.location + range.length) else {
                return
            }
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            return
        }

        let newText = format(string: text.insert(string: string, fromIndex: range.location)) ?? ""
        let strLen = string.count
        let oldLen = (textField.text ?? "").count
        let newLen = newText.count
        var oldLoc = range.location
        
        var char = text.substring(fromIndex: oldLoc, toIndex: oldLoc + 1)
        while char?.rangeOfCharacter(from: numbersSet) == nil && oldLoc < oldLen {
            oldLoc += 1
            char = text.substring(fromIndex: oldLoc, toIndex: oldLoc + 1)
        }
        
        let oldOffset = oldLen - oldLoc
        let diff = newLen - (oldLen + strLen)
        textField.text = newText

        let offset = oldOffset == 0 ? 0 : oldOffset + diff
        
        guard let newPosition = textField.position(from: textField.endOfDocument,
                                                   offset: -offset) else {
            return
        }
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
    
    func deleteOneCharIn(text: String,
                         textField: UITextField,
                         shouldChangeCharactersIn range: NSRange,
                         replacementString string: String) {
        let from = range.location
        let toIndx = from + range.length
        let formated = format(string: text.cut(fromIndex: from, toIndex: toIndx) ?? "")
        textField.text = formated
        
        guard let newPosition = textField.position(from: textField.beginningOfDocument, offset: from) else {
            return
        }
        
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
}
