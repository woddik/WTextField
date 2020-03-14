//
//  UIImage+WUtils.swift
//  WTextField
//
//  Created by Woddi on 06.03.2020.
//

import UIKit

extension UIImage {
    
    func imageWithColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        if let cgImage = cgImage {
            context?.clip(to: rect, mask: cgImage)
        }
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
