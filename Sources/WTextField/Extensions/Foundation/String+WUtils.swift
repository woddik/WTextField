//
//  String+Utils.swift
//  WTextField
//
//  Created by Woddi on 01.03.2020.
//

import Foundation

extension String {
    
    static var space: String {
        return " "
    }
    
    var notNilLast: String {
        guard let last = last else {
            return ""
        }
        return String(last)
    }
    
    var containsUppercased: Bool {
        return first(where: { $0.isUppercase}) != nil
    }
    
    var containsLowercased: Bool {
        return first(where: { $0.isLowercase }) != nil
    }
    
    var containsDigits: Bool {
        return rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    var containsDigitsOrSymbols: Bool {
        let characterSet = CharacterSet.decimalDigits.union(.decimalDigits)
        return rangeOfCharacter(from: characterSet) != nil
    }
    
    var containsLetters: Bool {
        return rangeOfCharacter(from: .letters) != nil
    }
    
    var containsSpecialSymbols: Bool {
        let characterSet = CharacterSet.letters.union(.decimalDigits)
        return rangeOfCharacter(from: characterSet.inverted) != nil
    }
    
    subscript (charIndex: Int) -> Character {
        return self[index(startIndex, offsetBy: charIndex)]
    }
    
    /// Returns only numbers from string
    ///
    /// - Returns: String with numbers or empty string if there was no numbers
    func removeFormat(exceptSymbolsFromString: String = "") -> String {
        return components(separatedBy: CharacterSet(charactersIn: exceptSymbolsFromString).inverted).joined()
    }
    
    func substring(fromIndex: Int, toIndex: Int) -> String? {
        let len = count
        if fromIndex < 0 || toIndex < 0 || fromIndex > len || toIndex > len || fromIndex > toIndex {
            return nil
        }
        
        let temp = self
        let diff = toIndex - fromIndex
        let startIndex = temp.index(temp.startIndex, offsetBy: fromIndex)
        let endIndex = temp.index(startIndex, offsetBy: diff)
        
        return String(temp[startIndex..<endIndex])
    }
    
    func isValid(for regexPattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) else {
            return false
        }
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
    }
    
    /// Returns only numbers from string
    ///
    /// - Returns: String with numbers or empty string if there was no numbers
    func stringDigitsOnly(exceptSymbolsFromString: String = "") -> String {
        let additionalCharSet = CharacterSet(charactersIn: exceptSymbolsFromString)
        let charSet = CharacterSet.decimalDigits.union(additionalCharSet).inverted
        return components(separatedBy: charSet).joined()
    }
    
    func cut(fromIndex: Int, toIndex: Int) -> String? {
        let len = count
        if fromIndex < 0 || toIndex < 0 || fromIndex > len || toIndex > len || fromIndex > toIndex {
            return nil
        }
        
        let temp = self
        let diff = toIndex - fromIndex
        let startIndex = temp.index(temp.startIndex, offsetBy: fromIndex)
        let endIndex = temp.index(startIndex, offsetBy: diff)
        
        let leftPart = String(temp[temp.startIndex..<startIndex])
        let rightPart = String(temp[endIndex..<temp.endIndex])
        
        return leftPart + rightPart
    }
    
    func insert(string: String, fromIndex: Int) -> String {
        let len = count
        let cur = min(max(0, fromIndex), len)
        let leftPart = substring(fromIndex: 0, toIndex: cur) ?? ""
        let rightPart = substring(fromIndex: cur, toIndex: len) ?? ""
        return leftPart + string + rightPart
    }
    
    func replace(with string: String, fromIndex: Int, toIndex: Int) -> String {
        let temp = cut(fromIndex: fromIndex, toIndex: toIndex) ?? ""
        return temp.insert(string: string, fromIndex: fromIndex)
    }
}

// MARK: - Regex

extension String {
    
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else {
            return false
        }
        
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
}

// MARK: - NSAttributedString

extension NSAttributedString {
    
    func changeOrAdd(attribute: NSAttributedString.Key, value: Any) -> NSAttributedString {
        let mutStr = NSMutableAttributedString(attributedString: self)
        mutStr.setAttributes([attribute: value], range: NSMakeRange(0, length))
        return mutStr
    }
}

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        guard let self = self else {
            return true
        }
        return self.isEmpty
    }
    
}
