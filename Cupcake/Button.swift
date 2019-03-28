//
//  Button.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/23.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public var Button: UIButton {
    cpk_swizzleMethodsIfNeed()
    let button = UIButton()
    cpk_higherHuggingAndResistance(forView: button)
    return button
}

public extension UIButton {
    
    /**
     * Setting normal title or normal attributedTitle
     * str can take any kind of value, even primitive type like Int.
     * Usages:
        .str(1024)
        .str("hello world")
        .str( AttStr("hello world").strikethrough() )
        ...
     */
    @objc @discardableResult func str(_ any: Any?) -> Self {
        if let attStr = any as? NSAttributedString {
            setAttributedTitle(attStr, for: .normal)
        } else if let any = any {
            setTitle(String(describing: any), for: .normal)
        } else {
            setTitle(nil, for: .normal)
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
        .font("Helvetica,15")
        .font(someLabel.font)
        ...
     **/
    @objc @discardableResult func font(_ any: Any) -> Self {
        self.titleLabel?.font = Font(any)
        return self
    }
    
    /**
     * Setting titleColor
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
        setTitleColor(Color(any), for: .normal)
        return self
    }
    
    /**
     * Setting highlighted titleColor
     * highColor use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .highColor(@"red")
        .highColor(@"#F00")
        .highColor(@"255,0,0")
        .highColor(someLabel.textColor)
        ...
     */
    @objc @discardableResult func highColor(_ any: Any?) -> Self {
        setTitleColor(Color(any), for: .highlighted)
        return self
    }
    
    /**
     * Setting normal image
     * img use Img() internally, so it can take any kind of values that Img() supported.
     * See Img.swift for more information.
     * Usages:
        .img("cat")
        .img("#button-background")
        .img("$home-icon")
        .img(someImage)
        ...
     */
    @objc @discardableResult func img(_ any: Any?) -> Self {
        let image = CPKImageOptional(any)
        setImage(image, for: .normal)
        if self.frame.isEmpty, let image = image {
            self.frame.size = image.size
        }
        return self
    }
    
    /**
     * Setting highlighted image
     * highImg use Img() internally, so it can take any kind of values that Img() supported.
     * See Img.swift for more information.
     * Usages:
        .highImg("cat")
        .highImg("#button-background")
        .highImg("$home-icon")
        .highImg(someImage)
        ...
     */
    @objc @discardableResult func highImg(_ any: Any?) -> Self {
        setImage(CPKImageOptional(any), for: .highlighted)
        return self
    }
    
    /**
     * Setting background with Color or Image.
     * bg use Img() internally, so it can take any kind of values that Img() supported.
     * See Img.swift for more information.
     * Usages:
        .bg(@"red")
        .bg(@"#F00")
        .bg(@"255,0,0")
        .bg(someView.backgroundColor)
        .bg("cat")      //using image
        .bg(someImage)  //using image
        ...
     */
    @objc @discardableResult override func bg(_ any: Any) -> Self {
        let image = CPKImageOptional(any)
        setBackgroundImage(image, for: .normal)
        cpk_masksToBoundsIfNeed()
        
        if self.frame.isEmpty, let image = image {
            self.frame.size = image.size
        }
        return self
    }
    
    /**
     * Setting highlighted background with Color or Image.
     * highBg use Img() internally, so it can take any kind of values that Img() supported.
     * See Img.swift for more information.
     * Usages:
        .highBg(@"red")
        .highBg(@"#F00")
        .highBg(@"255,0,0")
        .highBg(someView.backgroundColor)
        .highBg("cat")      //using image
        .highBg(someImage)  //using image
        ...
     */
    @objc @discardableResult func highBg(_ any: Any?) -> Self {
        setBackgroundImage(CPKImageOptional(any), for: .highlighted)
        cpk_masksToBoundsIfNeed()
        return self
    }
    
    /**
     * Setting contentEdgeInsets
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
     * Setting spacing between title and image.
     * Usages:
        .gap(10)
     */
    @objc @discardableResult func gap(_ spacing: CGFloat) -> Self {
        self.cpkGap = spacing
        let halfGap = spacing / 2
        
        self.titleEdgeInsets = UIEdgeInsetsMake_(0, halfGap, 0, -halfGap)
        self.imageEdgeInsets = UIEdgeInsetsMake_(0, -halfGap, 0, halfGap)
        
        var insets = self.cpkInsets ?? UIEdgeInsetsMake_(0, 0, 0, 0)
        insets.left += halfGap
        insets.right += halfGap
        self.contentEdgeInsets = insets
        
        return self
    }
    
    /**
     * Swapping title and image position.
     * Usages:
        .reversed()
        .reversed(false)
     */
    @objc @discardableResult func reversed(_ reversed: Bool = true) -> Self {
        let t = reversed ? CATransform3DMakeScale(-1, 1, 1) : CATransform3DIdentity
        self.layer.sublayerTransform = t
        self.imageView?.layer.transform = t
        self.titleLabel?.layer.transform = t
        return self
    }
    
    /**
     * Enable multilines for Button.
     * Usages:
        .lines(2)
        .lines(0)   //multilines
        .lines()    //same as .lines(0)
     */
    @objc @discardableResult func lines(_ numberOfLines: CGFloat = 0) -> Self {
        self.titleLabel?.numberOfLines = Int(numberOfLines)
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
        return self
    }
}


