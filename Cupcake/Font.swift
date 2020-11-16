//
//  Font.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * Create UIFont object.
 * Font argument can be:
    1) UIFont object
    2) 15: systemFontOfSize 15
    3) "15": boldSystemFontOfSize 15
    4) "headline", "body", "caption1", and any other UIFontTextStyle.
    5) "Helvetica,15": fontName + fontSize, separated by comma.
 
 * Usages: 
    Font(someLabel.font),
    Font(15)
    Font("15")
    Font("body")
    Font("Helvetica,15")
    ...
 */
public func Font(_ any: Any) -> UIFont {
    if let font = any as? UIFont {
        return font
    }
    
    if let string = any as? String {
        let elements = string.components(separatedBy: ",")
        if elements.count == 2 {
            return UIFont(name: elements[0], size: CGFloat(Float(elements[1])!))!
        }
        
        if let fontSize = Float(string), fontSize > 0 {
            return UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        }
        
        let value = "UICTFontTextStyle" + string.capitalized
        return UIFont.preferredFont(forTextStyle: UIFontTextStyle_(rawValue: value))
    }
    
    return UIFont.systemFont(ofSize: CPKFloat(any))
}


