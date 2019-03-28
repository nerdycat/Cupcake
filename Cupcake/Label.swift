//
//  Label.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public var Label: UILabel {
    cpk_swizzleMethodsIfNeed()
    let label = UILabel()
    return label
}

public extension UILabel {
    
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
     * Setting font
     * font use Font() internally, so it can take any kind of values that Font() supported.
     * See Font.swift for more information.
     * Usages:
        .font(15)
        .font("20")
        .font("body")
        .font("Helvetica,15")
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
     * Setting numberOfLines
     * Usages:
        .lines(2)
        .lines(0)   //multilines
        .lines()    //same as .lines(0)
     */
    @objc @discardableResult func lines(_ numberOfLines: CGFloat = 0) -> Self {
        self.numberOfLines = Int(numberOfLines)
        return self
    }
    
    /** 
     * Setting lineSpacing
     * Usages:
        .lineGap(8)
     */
    @objc @discardableResult func lineGap(_ lineSpacing: CGFloat) -> Self {
        self.cpkLineGap = lineSpacing
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
     * Setup link handler.
     * Use onLink in conjunction with AttStr's link method to make text clickable.
     * This will automatically set isUserInteractionEnabled to true as well.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onLink({ text in print(text) })
        .onLink({ [weak self] text in   //capture self as weak reference when needed
            print(text)
        })
     */
    @discardableResult func onLink(_ closure: @escaping (String)->()) -> Self {
        self.isUserInteractionEnabled = true
        self.cpkLinkHandler = closure
        return self
    }
}

