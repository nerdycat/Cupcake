//
//  View.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/22.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public var View: UIView {
    cpk_swizzleMethodsIfNeed()
    let view = UIView()
    return view
}

public extension UIView {
    
    /**
     * Setting background with Color or Image.
     * bg use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .bg(@"red")
        .bg(@"#F00")
        .bg(@"255,0,0")
        .bg(someView.backgroundColor)
        .bg("cat")      //using image
        ...
     */
    @objc @discardableResult func bg(_ any: Any) -> Self {
        self.backgroundColor = Color(any) ?? Color(Img(any))
        return self
    }
    
    /**
     * Setting tintColor
     * tint use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .tint("red")
        .tint("#00F")
     */
    @objc @discardableResult func tint(_ any: Any) -> Self {
        self.tintColor = Color(any)
        return self
    }
    
    /**
     * Setting cornerRadius
     * radius support auto rounding, which is a very useful trick when working with AutoLayout.
     * Auto rounding will alway set cornerRadius to half of the height not matter what size it is.
     * Usages:
        .radius(10)
        .radius(-1)   //passing negative number means using auto rounding
     */
    @objc @discardableResult func radius(_ cornerRadius: CGFloat) -> Self {
        if cornerRadius < 0 {
            self.layer.cornerRadius = self.bounds.height / 2
            self.cpkAutoRoundingRadius = true
        } else {
            self.layer.cornerRadius = cornerRadius
            self.cpkAutoRoundingRadius = false
        }
        
        cpk_masksToBoundsIfNeed()
        return self
    }
    
    /**
     * Setting border with borderWidth and borderColor (optional).
     * border's second argument use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .border(1)
        .border(1, "red")
     */
    @objc @discardableResult func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = Color(borderColor)?.cgColor
        return self
    }
    
    /**
     * Drop shadow with opacity, radius (optional), offset (optional) and color (optional).
     * shadow's color argument use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .shadow(1)
        .shadow(0.7, 2)
        .shadow(0.7, 3, 0, 0)
        .shadow(0.7, 3, 0, 0, "red")
     */
    @objc @discardableResult func shadow(_ shadowOpacity: CGFloat,
                                         _ shadowRadius: CGFloat = 3,
                                         _ shadowOffsetX: CGFloat = 0,
                                         _ shadowOffsetY: CGFloat = 3,
                                         _ shadowColor: Any? = nil) -> Self {
        
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: shadowOffsetX, height: shadowOffsetY)
        if let color = Color(shadowColor) {
            self.layer.shadowColor = color.cgColor
        }
        return self
    }
    
    
    /**
     * Apply at most 4 styles to view.
     * See Styles.swift for more information.
     Usages:
        .styles(myStyle)
        .styles(myStyle1, myStyle2, "globalStyle1")
        .styles(someView)       //retrieve styles direct from view
     */
    @objc @discardableResult func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        var array = Array<Any>()
        array.append(s1)
        
        if s2 != nil { array.append(s2!) }
        if s3 != nil { array.append(s3!) }
        if s4 != nil { array.append(s4!) }
        
        for styles in array {
            if let style = styles as? StylesMaker {
                style.applyTo(view: self)
                
            } else if let name = styles as? String {
                if let style = StylesMaker.globalStyles[name] {
                    style.applyTo(view: self)
                }
                
            } else if let view = styles as? UIView {
                Styles(view).applyTo(view: self)
            }
        }
        return self
    }
    
    /**
     * Setting touch insets.
     * Very useful for extending touch area.
     * It can take variety of forms.
     * Usages:
        .touchInsets(10)                    //top: 10, left: 10, bottom: 10, right: 10
        .touchInsets(10, 20)                //top: 10, left: 20, bottom: 10, right: 20
        .touchInsets(10, 20, 30)            //top: 10, left: 20, bottom: 0 , right: 30
        .touchInsets(10, 20, 30, 40)        //top: 10, left: 20, bottom: 30, right: 40
     */
    @objc @discardableResult func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        self.cpkTouchInsets = cpk_edgeInsetsFromParameters(p1, p2, p3, p4)
        return self
    }

    /**
     * Setup click handler.
     * This will automatically set isUserInteractionEnabled to true as well.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onClick({ view in /* ... */ })             //the view being clicked is pass as parameter
        .onClick({ _ in /* ... */ })                //if you don't care at all
        .onClick({ [weak self] _ in /* ... */ })    //capture self as weak reference when needed
     */
    @objc @discardableResult func onClick(_ closure: @escaping (UIView)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    /**
     * Same as onClick but with zero parameter.
     */
    @objc @discardableResult func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    /**
     * Add current view to superview.
     * Usages:
        .addTo(superView)
     */
    @objc @discardableResult func addTo(_ superview: UIView) -> Self {
        superview.addSubview(self)
        return self
    }
    
    /**
     * Add multiply subviews at the same time.
     * Usages:
        .addSubviews(view1, view2, view3)
     */
    @discardableResult func addSubviews(_ children: Any...) -> Self {
        func addChildren(_ children: Array<Any>) {
            for child in children {
                if let view = child as? UIView {
                    self.addSubview(view)
                } else if let array = child as? Array<UIView> {
                    addChildren(array)
                }
            }
        }
        
        addChildren(children)
        return self
    }
}



public extension UIView {
    
    /**
     * Setting layout margins.
     * Very useful when embed in StackView.
     * It can take variety of forms.
     * Usages:
        .margin(10)                     //top: 10, left: 10, bottom: 10, right: 10
        .margin(10, 20)                 //top: 10, left: 20, bottom: 10, right: 20
        .margin(10, 20, 30)             //top: 10, left: 20, bottom: 0 , right: 30
        .margin(10, 20, 30, 40)         //top: 10, left: 20, bottom: 30, right: 40
     */
    @objc @discardableResult func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        self.layoutMargins = cpk_edgeInsetsFromParameters(p1, p2, p3, p4)
        return self
    }
    
    /**
     * An easy way to setup constraints relative to superview.
     * You can pass multiply options at the same time.
     
     * Usages:
        .pin(.x(20))                    //add left constraint
        .pin(.x("20"))                  //add left margin constraint
        .pin(.y(20))                    //add top constraint
        .pin(.y("20"))                  //add top margin constraint
        .pin(.xy(20, 20))               //and left and top constraints
     
        .pin(.w(100))                   //add width constraint
        .pin(.h(100))                   //add height constraint
        .pin(.wh(100, 100))             //add width and height constraints
     
        .pin(.xywh(20, 20, 100, 100))   //add left, top, width and height constraints
     
        .pin(.maxX(-20))                //add right constraint
        .pin(.maxX("-20"))              //add right margin constraint
        .pin(.maxY(-20))                //add bottom constraint
        .pin(.maxY("-20"))              //add bottom margin constraint
        .pin(.maxXY("-20", "-20"))      //add right and bottom constraints
     
        .pin(.centerX(0))               //add centerX constriant
        .pin(.centerY(0))               //add centerY constraint
        .pin(.centerXY(0, 0))           //add centerX and centerY constraints
        .pin(.center)                   //add centerX and centerY constraints with offset of 0
     
        .pin(.whRatio(2))               //width = height * 2 constraint
        .pin(.ratio)                    //width = height * currentSizeRatio constraint, very useful for ImageView
     
        .pin(.lowHugging)               //Low content hugging priority, very useful when embed in StackView.
                                        //The lowest hugging view will take as much space as possible.
     
        .pin(.lowRegistance)            //Low content compression resistance priority, very useful when embed in StackView.
                                        //The lowest resistance view will be compressed when there are no more space available.
     
        .pin(100)                       //shorthand for .pin(.h(100))
        .pin(100, 100)                  //shorthand for .pin(.wh(100, 100))
        .pin(20, 20, 100, 100)          //shorthand for .pin(.xywh(20, 20, 100, 100))
     
        //pass multiply options at the same time
        .pin(.xy(20, 20), .maxX(-20), 100)
        .pin(100, 100, .center)
        ...
     */
    @discardableResult func pin(_ options: CPKViewPinOptions...) -> Self {
        cpk_pinOptions(options, forView: self)
        return self
    }
    
    /**
     * Making constraints just like SnapKit.
     * makeCons will only create new constraints when needed.
     * Usages:
        .makeCons({
            _.left.top.equal(someView).offset(20, 20)
            _.size.equal(100, 100)
        })
     */
    @objc @discardableResult func makeCons(_ closure: (ConsMaker)->()) -> Self {
        let maker = ConsMaker(firstItem: self)
        closure(maker)
        maker.updateConstraints()
        return self
    }
    
    /**
     * Remake constarints just like SnapKit.
     * remakeCons will remove all previous installed constarints first.
     * Usages:
        .makeCons({
            _.center.equal(someView)
            _.size.equal(anotherView)
        })
     */
    @objc @discardableResult func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        let maker = ConsMaker(firstItem: self)
        closure(maker)
        maker.remakeConstraints()
        return self
    }
    
    /**
     * Embed self into superview with optional edge constraints.
     * Passing nil means no constraint.
     * Usages:
        .embedIn(superview)                     //top: 0,  left: 0,  bottom: 0,  right: 0
        .embedIn(superview, 10)                 //top: 10, left: 10, bottom: 10, right: 10
        .embedIn(superview, 10, 20)             //top: 10, left: 20, bottom: 10, right: 20
        .embedIn(superview, 10, 20, 30)         //top: 10, left: 20, right: 30
        .embedIn(superview, 10, 20, 30, 40)     //top: 10, left: 20, bottom: 30, right: 40
        .embedIn(superview, 10, 20, nil)        //top: 10, left: 20
     
     * Passing string value instead of CGFloat will constraint to superview's margin.
     * This is useful when embed in controller's view whose margin may not be 0.
     * Usages:
        .embedIn(superview, "10", 20, "30", 40) //topMargin: 10, left: 20, bottomMargin: 30, right: 40
     */
    @objc @discardableResult func embedIn(_ superview: UIView,
                                          _ p1: Any? = "", _ p2: Any? = "",
                                          _ p3: Any? = "", _ p4: Any? = "") -> Self {
        
        superview.addSubview(self)
        let edge = cpk_edgeInsetsTupleFromParameters(p1, p2, p3, p4)
        
        makeCons({
            if let top = edge.0 {
                if let topValue = top as? CGFloat {
                    $0.top.offset(topValue)
                } else if let topMarginValue = CPKFloatOptional(top) {
                    $0.top.equal(superview).topMargin.offset(topMarginValue)
                }
            }
            if let left = edge.1 {
                if let leftValue = left as? CGFloat {
                    $0.left.offset(leftValue)
                } else if let leftMarginValue = CPKFloatOptional(left) {
                    $0.left.equal(superview).leftMargin.offset(leftMarginValue)
                }
            }
            if let bottom = edge.2 {
                if let bottomValue = bottom as? CGFloat {
                    $0.bottom.offset(-bottomValue)
                } else if let bottomMarginValue = CPKFloatOptional(bottom) {
                    $0.bottom.equal(superview).bottomMargin.offset(-bottomMarginValue)
                }
            }
            if let right = edge.3 {
                if let rightValue = right as? CGFloat {
                    $0.right.offset(-rightValue)
                } else if let rightMarginValue = CPKFloatOptional(right) {
                    $0.right.equal(superview).rightMargin.offset(-rightMarginValue)
                }
            }
        })
        
        return self
    }
}


public enum CPKViewPinOptions {
    case x(Any)                     //passing value for left constraint, passing string value for left margin constraint
    case y(Any)                     //passing value for top constraint, passing string value for top margin constraint
    case xy(Any, Any)               //x + y
    
    case w(CGFloat)                 //width constraint
    case h(CGFloat)                 //height constraint
    case wh(CGFloat, CGFloat)       //width and height constraints
    
    case xywh(CGFloat, CGFloat,     //left, top, width and height constraints
              CGFloat, CGFloat)
    
    case maxX(Any)                  //passing value for right constraint, passing string value for right margin constraint
    case maxY(Any)                  //passing value for bottom constraint, passing string value for bottom margin constraint
    case maxXY(Any, Any)            //maxX + maxY
    
    case centerX(CGFloat)           //centerX constraint
    case centerY(CGFloat)           //centerY constraint
    case centerXY(CGFloat, CGFloat) //centerX and centerY constraints
    case center                     //centerX and centerY constraints with offset of 0
    
    case whRatio(CGFloat)           //width = height * ratio constraint
    case ratio                      //width = height * currentSizeRatio constraint
    
    case hhp(UILayoutPriority)      //horizontal content hugging priority
    case vhp(UILayoutPriority)      //vertical content hugging priority
    case hrp(UILayoutPriority)      //horizontal content compression resistance priority
    case vrp(UILayoutPriority)      //vertical content compression resistance priority
    
    case lowHugging                 //low content hugging priority
    case lowResistance              //low content compression resistance priority
    
    case ___value(CGFloat)          //private usage
}


