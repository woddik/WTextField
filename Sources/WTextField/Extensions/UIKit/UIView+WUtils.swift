//
//  UIView+Utils.swift
//  WTextField
//
//  Created by Woddi on 02.03.2020.
//

import UIKit

extension UIView {
    
    static func animate(withDecision isAnimated: Bool,
                        animations: @escaping (() -> Void),
                        completion: (() -> Void)? = nil) {
        guard isAnimated else {
            animations()
            completion?()
            return
        }
        
        let parameters = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.230, y: 1.000),
                                                 controlPoint2: CGPoint(x: 0.320, y: 1.000))
        
        let animator = UIViewPropertyAnimator(duration: TimeInterval(0.4),
                                              timingParameters: parameters)
        animator.addAnimations(animations)
        animator.addCompletion { _ in
            completion?()
        }
        animator.startAnimation()
    }
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
