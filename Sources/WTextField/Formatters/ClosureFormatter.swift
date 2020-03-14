//
//  ClosureFormatter.swift
//  WTextField
//
//  Created by Woddi on 06.03.2020.
//

import Foundation

struct ClosureFormatter: FormaterProtocol {
    
    private let formatterCallback: (_ object: String?) -> String?
    
    init(callback: @escaping (_ object: String?) -> String?) {
        formatterCallback = callback
    }
    
    func format(string: String?) -> String? {
        return formatterCallback(string)
    }
}
