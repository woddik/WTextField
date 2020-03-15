//
//  TextFieldColorSet.swift
//  WTextField
//
//  Created by Woddi on 31.01.2020.
//

import UIKit

public protocol WTextFieldColorSet {
    
    var selected: UIColor { get }
    
    var deselected: UIColor { get }
    
    var error: UIColor { get }
}
