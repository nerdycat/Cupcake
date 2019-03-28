//
//  Img.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * Create UIImage object.
 * Img argument can be:
    1) UIImage object
    2) "imageName"
    3) "#imageName": stretchable image
    4) "$imageName": template image
    5) Any color value that Color() supported.
 
 * Prefixing image name with # character will create a stretchable image.
 * Prefixing image name with $ character will create a template image.
 * Passing a color value will create an 1x1 size image with specific color.
 
 * Usages:
    Img(someImage)
    Img("cat")
    Img("#button-background")
    Img("$home-icon")
    Img("33,33,33,0.5")
    Img("red").resize(100, 100)
    ...
 */
public func Img(_ any: Any) -> UIImage {
    
    if let image = any as? UIImage {
        return image
    }
    
    if let string = any as? String {
        let stretching = string.hasPrefix("#")
        let templating = string.hasPrefix("$")
        
        let imageName = (stretching || templating) ? string.subFrom(1) : string
        var image = UIImage(named: imageName)
        
        if stretching {
            if image == nil {
                image = UIImage(named: string)
            } else {
                let leftCap = Int(image!.size.width) / 2
                let topCap = Int(image!.size.height) / 2
                image = image?.stretchableImage(withLeftCapWidth:leftCap, topCapHeight: topCap)
            }
        }
        
        if templating {
            if image == nil {
                image = UIImage(named: string)
            } else {
                image = image?.withRenderingMode(.alwaysTemplate)
            }
        }
        
        if image != nil {
            return image!
        }
    }
    
    if let color = Color(any) {
        return cpk_onePointImageWithColor(color)
    } else {
        assert(false, "invalid image")
        return UIImage()
    }
}


public extension UIImage {
    
    /**
     * Resize image.
     * When passing integer value, it means the target size.
     * When passing floating value, it means multiply with original size.
     * Usages: 
        .resize(100, 100)       //resize to 100x100
        .resize(100)            //same as .resize(100, 100)
        .resize(0.8, 0.8)       //0.8 * original size
        .resize(0.8)            //same as .resize(0.8, 0.8)
     */
    @discardableResult func resize(_ p1: Any, _ p2: Any? = nil) -> UIImage {
        var newWidth: CGFloat = 0
        var newHeight: CGFloat = 0
        
        if let width = p1 as? Int {
            newWidth = CGFloat(width)
        } else {
            newWidth = CPKFloat(p1) * self.size.width
        }
        
        if p2 == nil {
            newHeight = newWidth
            
        } else {
            if let height = p2 as? Int {
                newHeight = CGFloat(height)
            } else {
                newHeight = CPKFloat(p2!) * self.size.height
            }
        }
        
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        let hasAlpha = cpk_imageHasAlphaChannel(self)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, self.scale)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


