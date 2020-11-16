//
//  Styles.swift
//  Cupcake
//
//  Created by nerdycat on 2017/5/3.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit


/**
 * Some of the chainable property can be set as style.
 
 * There are two type of styles:
   1) Global style:
    Styles("GlobalStyleName").color("red").font(15)
   2) Local style:
    let localStyle = Styles.color("red").font(15)
    let localStyleFromExistingView = Styles(someView)
 
 * After creation, you can apply styles to any UIView:
    Label.styles("GlobalStyleName", localStyle)
    Button.styles(localStyle).font(17)
 */

public var Styles: StylesMaker {
    return StylesMaker()
}

public func Styles(_ globalStyleNameOrView: Any) -> StylesMaker {
    if let name = globalStyleNameOrView as? String {
        let makers = StylesMaker()
        StylesMaker.globalStyles[name] = makers
        return makers
    } else if let view = globalStyleNameOrView as? UIView {
        return StylesMaker(view: view)
    } else {
        return StylesMaker()
    }
}


public extension StylesMaker {
    
    //View
    @discardableResult func bg(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func tint(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func radius(_ cornerRadius: CGFloat) -> Self {
        return addStyle(key: #function, value: cornerRadius)
    }
    
    @discardableResult func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        var dict: Dictionary<String, Any> = ["borderWidth": borderWidth]
        if let color = borderColor {
            dict["borderColor"] = color
        }
        return addStyle(key: #function, value: dict)
    }
    
    @discardableResult func shadow(_ shadowOpacity: CGFloat,
                                   _ shadowRadius: CGFloat = 3,
                                   _ shadowOffsetX: CGFloat = 0,
                                   _ shadowOffsetY: CGFloat = 3) -> Self {
        
        let dict: Dictionary<String, CGFloat> = ["opacity": shadowOpacity,
                                                 "radius": shadowRadius,
                                                 "offsetX": shadowOffsetX,
                                                 "offsetY": shadowOffsetY]
    
        return addStyle(key: #function, value: dict)
    }
    
    @discardableResult func pin(_ options: CPKViewPinOptions...) -> Self {
        return addStyle(key: #function, value: options)
    }
    
    @discardableResult func touchInsets(_ p1: Any,
                                        _ p2: Any? = nil,
                                        _ p3: Any? = nil,
                                        _ p4: Any? = nil) -> Self {
        let insets = cpk_edgeInsetsFromParameters(p1, p2, p3, p4)
        return addStyle(key: #function, value: insets)
    }
    
    
    //Label
    @discardableResult func str(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func font(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func color(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func lines(_ numberOfLines: CGFloat = 0) -> Self {
        return addStyle(key: #function, value: numberOfLines)
    }
    
    @discardableResult func lineGap(_ lineSpacing: CGFloat) -> Self {
        return addStyle(key: #function, value: lineSpacing)
    }
    
    @discardableResult func align(_ textAlignment: NSTextAlignment) -> Self {
        return addStyle(key: #function, value: textAlignment)
    }
    
    
    //ImageView
    @discardableResult func img(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func mode(_ contentMode: UIViewContentMode_) -> Self {
        return addStyle(key: #function, value: contentMode)
    }
    
    //Button
    @discardableResult func highColor(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func highImg(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func highBg(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func padding(_ contentEdgeInsets: CGFloat...) -> Self {
        return addStyle(key: #function, value: contentEdgeInsets)
    }
    
    @discardableResult func gap(_ spacing: CGFloat) -> Self {
        return addStyle(key: #function, value: spacing)
    }
    
    @discardableResult func reversed(_ reversed: Bool = true) -> Self {
        return addStyle(key: #function, value: reversed)
    }
    
    
    //TextField
    @discardableResult func hint(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult func maxLength(_ length: CGFloat) -> Self {
        return addStyle(key: #function, value: length)
    }
    
    @discardableResult func secure(_ secureTextEntry: Bool = true) -> Self {
        return addStyle(key: #function, value: secureTextEntry)
    }
    
    @discardableResult func keyboard(_ keyboardType: UIKeyboardType) -> Self {
        return addStyle(key: #function, value: keyboardType)
    }
    
    @discardableResult func returnKey(_ returnKeyType: UIReturnKeyType) -> Self {
        return addStyle(key: #function, value: returnKeyType)
    }
    
    @discardableResult func clearMode(_ clearButtonMode: UITextFieldViewMode_) -> Self {
        return addStyle(key: #function, value: clearButtonMode)
    }
}




