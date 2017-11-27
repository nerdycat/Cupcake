//
//  Color.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * Create UIColor Object.
 * Color argument can be:
    1) UIColor object
    2) UIImage object, return a pattern image color
    3) "red", "green", "blue", "clear", etc. (any system color)
    5) "random": randomColor
    6) "255,0,0": RGB color
    7) "#FF0000" or "0xF00": Hex color
 
 * All the string representation can have an optional alpha value.
 
 * Usages: 
    Color([UIColor redColor])
    Color("red")
    Color("red,0.1")        //with alpha
    Color("255,0,0)
    Color("255,0,0,1")      //with alpha
    Color("#FF0000")
    Color("#F00,0.1")       //with alpha
    Color("random,0.5")
    Color(Img("image"))     //using image
    ...
 */
public func Color(_ any: Any?) -> UIColor? {
    if any == nil {
        return nil
    }
    
    if let color = any as? UIColor {
        return color;
    }
    
    if let image = any as? UIImage {
        return UIColor(patternImage: image)
    }
    
    guard any is String else {
        return nil
    }
    
    var alpha: CGFloat = 1
    var components = (any as! String).components(separatedBy: ",")
    
    if components.count == 2 || components.count == 4 {
        alpha = min(CGFloat(Float(components.last!) ?? 1), 1)
        components.removeLast()
    }
    
    var r: Int?, g: Int? , b: Int?
    
    if components.count == 1 {
        let string = components.first!
        let sel = NSSelectorFromString(string + "Color")
        
        //system color
        if let color = UIColor.cpk_safePerform(selector: sel) as? UIColor {
            return (alpha == 1 ? color : color.withAlphaComponent(alpha))
        }
        
        if string == "random" {
            r = Int(arc4random_uniform(256))
            g = Int(arc4random_uniform(256))
            b = Int(arc4random_uniform(256))
            
        } else if string.hasPrefix("#") {
            if string.cpk_length() == 4 {
                r = Int(string.subAt(1), radix:16)! * 17
                g = Int(string.subAt(2), radix:16)! * 17
                b = Int(string.subAt(3), radix:16)! * 17
                
            } else if string.cpk_length() == 7 {
                r = Int(string.subAt(1...2), radix:16)
                g = Int(string.subAt(3...4), radix:16)
                b = Int(string.subAt(5...6), radix:16)
            }
        }
        
    } else if components.count == 3 {
        r = Int(components[0])
        g = Int(components[1])
        b = Int(components[2])
    }
    
    if r != nil && g != nil && b != nil {
        return UIColor(red: CGFloat(r!) / 255.0,
                       green: CGFloat(g!) / 255.0,
                       blue: CGFloat(b!) / 255.0,
                       alpha: alpha)
    }
    
    return nil
}


