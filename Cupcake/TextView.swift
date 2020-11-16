//
//  TextView.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/25.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public var TextView: UITextView  {
    cpk_swizzleMethodsIfNeed()
    return  UITextView().font(17)
}

public extension UITextView {
    
    /**
     * Setting text or attributedText
     * str can take any kind of value, even primitive type like Int.
     * Usages:
        .str(1024)
        .str("hello world")
        .str( AttStr("hello world").strikethrough() )
        ...
     */
    @objc @discardableResult func str(_ any: Any?) -> Self {
        if let attStr = any as? NSAttributedString {
            self.attributedText = attStr
        } else if let any = any {
            self.text = String(describing: any)
        } else {
            self.text = nil
        }
        return self
    }
    
    /**
     * Setting placeholder or attributedPlaceholder
     * hint can take any kind of value, even primitive type like Int.
     * Usages:
        .hint(1024)
        .hint("Enter here")
        .hint( AttStr("Enter here").font(13) )
     */
    @objc @discardableResult func hint(_ any: Any?) -> Self {
        cpk_setPlaceholder(any)
        return self
    }
    
    /**
     * Setting font
     * font use Font() internally, so it can take any kind of values that Font() supported.
     * See Font.siwft for more information.
     * Usages:
        .font(15)
        .font("20")
        .font("body")
        .font(someLabel.font)
        ...
     **/
    @objc @discardableResult func font(_ any: Any) -> Self {
        self.font = Font(any)
        return self
    }
    
    /**
     * Setting textColor
     * color use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .color(@"red")
        .color(@"#F00")
        .color(@"255,0,0")
        .color(someLabel.textColor)
        ...
     */
    @objc @discardableResult func color(_ any: Any) -> Self {
        self.textColor = Color(any)
        return self
    }
    
    /**
     * Max input length
     * Usages:
        .maxLength(10)
     */
    @objc @discardableResult func maxLength(_ length: CGFloat) -> Self {
        self.cpkMaxLength = Int(length)
        return self
    }
    
    /**
     * contentEdgeInsets for UITextView
     * Usages:
        .padding(10)                //top: 10, left: 10, bottom: 10, right: 10
        .padding(10, 20)            //top: 10, left: 20, bottom: 10, right: 20
        .padding(10, 20, 30)        //top: 10, left: 20, bottom: 0 , right: 30
        .padding(10, 20, 30, 40)    //top: 10, left: 20, bottom: 30, right: 40
     */
    @discardableResult func padding(_ contentEdgeInsets: CGFloat...) -> Self {
        cpk_updatePadding(contentEdgeInsets, forView: self)
        return self
    }
    
    /**
     * Setting textAlignment
     * Usages:
        .align(.center)
        .align(.justified)
        ...
     */
    @objc @discardableResult func align(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    /**
     * Setup text changed handler.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onChange({ textView in /* ... */ })
        .onChange({ _ in /* ... */ })
        .onChange({ [weak self] textView in /* ... */ }) //capture self as weak reference when needed
     */
    @discardableResult func onChange(_ closure: @escaping (UITextView)->()) -> Self {
        self.cpkTextChangedClosure = cpk_generateCallbackClosure(closure, nil)
        return self
    }
}



