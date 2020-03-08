//
//  SeparatorView.swift
//  WTextField
//
//  Created by Woddi on 07.03.2020.
//

import UIKit

final class SeparatorView: UIView {
    
    private var color: UIColor?
    private var percent: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func fill(with color: UIColor, by percent: CGFloat) {
        self.color = color
        self.percent = percent
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let color = color else {
            return
        }
        let topRect = CGRect(x: 0,
                             y: 0,
                             width: rect.size.width * percent,
                             height: rect.size.height)
        color.set()
        guard let topContext = UIGraphicsGetCurrentContext() else {
            return
        }
        topContext.fill(topRect)
    }
}
