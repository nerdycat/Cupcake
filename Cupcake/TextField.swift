//
//  TextField.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/24.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public var TextField: UITextField  {
    cpk_swizzleMethodsIfNeed()
    let textField = UITextField()
    textField.enablesReturnKeyAutomatically = true
    textField.returnKeyType = .done
    return textField
}

public extension UITextField {
    
    /**
     * Setting text or attributedText
     * str can take any kind of value, even primitive type like Int.
     * Usages:
        .str(1024)
        .str("hello world")
        .str( AttStr("hello world").strikethrough() )
        ...
     */
    @objc @discardableResult public func str(_ any: Any) -> Self {
        if let attStr = any as? NSAttributedString {
            self.attributedText = attStr
        } else {
            self.text = String(describing: any)
        }
        return self
    }
    
    /**
     * Setting placeholder or attributedPlaceholder
     * hint can take any kind of value, even primitive type like Int.
     * Usages:
        .hint(1024)
        .hint("Enter your name")
        .hint( AttStr("Enter your name").font(13) )
     */
    @objc @discardableResult public func hint(_ any: Any) -> Self {
        if let attStr = any as? NSAttributedString {
            self.attributedPlaceholder = attStr
        } else {
            self.placeholder = String(describing: any)
        }
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
    @objc @discardableResult public func font(_ any: Any) -> Self {
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
    @objc @discardableResult public func color(_ any: Any) -> Self {
        self.textColor = Color(any)
        return self
    }
    
    /**
     * Max input length
     * Usages:
        .maxLength(10)
     */
    @objc @discardableResult public func maxLength(_ length: CGFloat) -> Self {
        self.cpkMaxLength = Int(length)
        return self
    }
    
    /**
     * contentEdgeInsets for UITextField
     * Usages:
        .padding(10)                //top: 10, left: 10, bottom: 10, right: 10
        .padding(10, 20)            //top: 10, left: 20, bottom: 10, right: 20
        .padding(10, 20, 30)        //top: 10, left: 20, bottom: 0 , right: 30
        .padding(10, 20, 30, 40)    //top: 10, left: 20, bottom: 30, right: 40
     */
    @discardableResult public func padding(_ contentEdgeInsets: CGFloat...) -> Self {
        cpk_updatePadding(contentEdgeInsets, forView: self)
        return self
    }
    
    /**
     * secureTextEntry
     * Usages:
        .secure()           //secureTextEntry = true
        .secure(false)      //secureTextEntry = false
     */
    @objc @discardableResult public func secure(_ secureTextEntry: Bool = true) -> Self {
        self.isSecureTextEntry = secureTextEntry
        return self
    }
    
    /**
     * Setting textAlignment
     * Usages:
        .align(.center)
        .align(.justified)
        ...
     */
    @objc @discardableResult public func align(_ textAlignment: NSTextAlignment) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
    /**
     * Setting keyboardType
     * Usages:
        .keyboard(.numberPad)
        .keyboard(.emailAddress)
        ...
     */
    @objc @discardableResult public func keyboard(_ keyboardType: UIKeyboardType) -> Self {
        self.keyboardType = keyboardType
        return self
    }
    
    /**
     * Setting returnKeyType
     * Usages:
        .returnKey(.send)
        .returnKey(.google)
        ...
     */
    @objc @discardableResult public func returnKey(_ returnKeyType: UIReturnKeyType) -> Self {
        self.returnKeyType = returnKeyType
        return self
    }
    
    /**
     * Setting clearButtonMode
     * Usages:
        .clearMode(.whileEditing)
        .clearMode(.always)
        ...
     */
    @objc @discardableResult public func clearMode(_ clearButtonMode: UITextFieldViewMode) -> Self {
        self.clearButtonMode = clearButtonMode
        return self
    }
    
    /**
     * Setup text changed handler.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onChange({ textField in /* ... */ })
        .onChange({ _ in /* ... */ })
        .onChange({ [weak self] textField in /* ... */ }) //capture self as weak reference when needed
     */
    @discardableResult public func onChange(_ closure: @escaping (UITextField)->()) -> Self {
        self.cpkTextChangedClosure = cpk_generateCallbackClosure(closure, nil)
        return self
    }
    
    /**
     * Setup enter finished handler.
     * The handler will be called when user click the return button.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onFinish({ textField in /* ... */ })
        .onFinish({ _ in /* ... */ })
        .onFinish({ [weak self] textField in /* ... */ })   //capture self as weak reference when needed
     */
    @discardableResult public func onFinish(_ closure: @escaping (UITextField)->()) -> Self {
        self.cpkDidEndOnExistClosure = cpk_generateCallbackClosure(closure, nil)
        return self
    }
}



