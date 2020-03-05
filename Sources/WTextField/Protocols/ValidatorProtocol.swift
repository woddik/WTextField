//
//  ValidatorProtocol.swift
//  StarWallet
//
//  Created by Woddi on 05.03.2020.
//  Copyright © 2020 Woddi. All rights reserved.
//

import Foundation

public protocol ValidatorProtocol {
    
    func validate(_ object: String) -> WTextFieldError?
    
}
