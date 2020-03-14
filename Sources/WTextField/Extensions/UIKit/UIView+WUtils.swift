//
//  UIView+Utils.swift
//  WTextField
//
//  Created by Woddi on 02.03.2020.
//

import UIKit

// MARK: - UIView.Direction

extension UIView {
    
    enum Direction {
        case top
        case right
        case bottom
        case left
    }
}

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

// MARK: - Constraints

extension UIView {
    
    func addConstraints(_ view: UIView, with insets: UIEdgeInsets = .zero, besides directions: [Direction] = []) {
        guard self != view else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if !directions.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top))
        }
        if !directions.contains(.right) {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right))
        }
        if !directions.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom))
        }
        if !directions.contains(.left) {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left))
        }
        NSLayoutConstraint.activate(constraints)
    }
}
