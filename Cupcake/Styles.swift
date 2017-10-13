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
    @discardableResult public func bg(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func tint(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func radius(_ cornerRadius: CGFloat) -> Self {
        return addStyle(key: #function, value: cornerRadius)
    }
    
    @discardableResult public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        var dict: Dictionary<String, Any> = ["borderWidth": borderWidth]
        if let color = borderColor {
            dict["borderColor"] = color
        }
        return addStyle(key: #function, value: dict)
    }
    
    @discardableResult public func shadow(_ shadowOpacity: CGFloat,
                                          _ shadowRadius: CGFloat = 3,
                                          _ shadowOffsetX: CGFloat = 0,
                                          _ shadowOffsetY: CGFloat = 3) -> Self {
        
        let dict: Dictionary<String, CGFloat> = ["opacity": shadowOpacity,
                                                 "radius": shadowRadius,
                                                 "offsetX": shadowOffsetX,
                                                 "offsetY": shadowOffsetY]
    
        return addStyle(key: #function, value: dict)
    }
    
    @discardableResult public func pin(_ options: CPKViewPinOptions...) -> Self {
        return addStyle(key: #function, value: options)
    }
    
    @discardableResult public func touchInsets(_ p1: Any,
                                               _ p2: Any? = nil,
                                               _ p3: Any? = nil,
                                               _ p4: Any? = nil) -> Self {
        let insets = cpk_edgeInsetsFromParameters(p1, p2, p3, p4)
        return addStyle(key: #function, value: insets)
    }
    
    
    //Label
    @discardableResult public func str(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func font(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func color(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func lines(_ numberOfLines: CGFloat = 0) -> Self {
        return addStyle(key: #function, value: numberOfLines)
    }
    
    @discardableResult public func lineGap(_ lineSpacing: CGFloat) -> Self {
        return addStyle(key: #function, value: lineSpacing)
    }
    
    @discardableResult public func align(_ textAlignment: NSTextAlignment) -> Self {
        return addStyle(key: #function, value: textAlignment)
    }
    
    
    //ImageView
    @discardableResult public func img(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func mode(_ contentMode: UIViewContentMode) -> Self {
        return addStyle(key: #function, value: contentMode)
    }
    
    
    //Button
    @discardableResult public func highColor(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func highImg(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func highBg(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func padding(_ contentEdgeInsets: CGFloat...) -> Self {
        return addStyle(key: #function, value: contentEdgeInsets)
    }
    
    @discardableResult public func gap(_ spacing: CGFloat) -> Self {
        return addStyle(key: #function, value: spacing)
    }
    
    @discardableResult public func reversed(_ reversed: Bool = true) -> Self {
        return addStyle(key: #function, value: reversed)
    }
    
    
    //TextField
    @discardableResult public func hint(_ any: Any) -> Self {
        return addStyle(key: #function, value: any)
    }
    
    @discardableResult public func maxLength(_ length: CGFloat) -> Self {
        return addStyle(key: #function, value: length)
    }
    
    @discardableResult public func secure(_ secureTextEntry: Bool = true) -> Self {
        return addStyle(key: #function, value: secureTextEntry)
    }
    
    @discardableResult public func keyboard(_ keyboardType: UIKeyboardType) -> Self {
        return addStyle(key: #function, value: keyboardType)
    }
    
    @discardableResult public func returnKey(_ returnKeyType: UIReturnKeyType) -> Self {
        return addStyle(key: #function, value: returnKeyType)
    }
    
    @discardableResult public func clearMode(_ clearButtonMode: UITextFieldViewMode) -> Self {
        return addStyle(key: #function, value: clearButtonMode)
    }
}




