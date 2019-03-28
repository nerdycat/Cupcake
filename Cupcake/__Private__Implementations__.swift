//
//  __Private__Implementations.swift
//  Cupcake
//
//  Created by nerdycat on 2017/6/8.
//  Copyright © 2017 nerdycat. All rights reserved.
//


import UIKit
import UIKit.UIGestureRecognizerSubclass



/**
 * Note:
 * This file contains most of the implementation codes.
 * You don't have to know the details while using Cupcake.
 */




#if swift(>=4.2)

public typealias UITextFieldViewMode_ = UITextField.ViewMode
public typealias UITableViewStyle_ = UITableView.Style
public typealias UITableViewCellStyle_ = UITableViewCell.CellStyle
public typealias UITableViewCellAccessoryType_ = UITableViewCell.AccessoryType
public typealias UIViewContentMode_ = UIView.ContentMode
public typealias UILayoutConstraintAxis_ = NSLayoutConstraint.Axis

typealias UIFontTextStyle_ = UIFont.TextStyle
typealias NSLayoutAttribute_ = NSLayoutConstraint.Attribute
typealias NSLayoutRelation_ = NSLayoutConstraint.Relation
typealias NSAttributedStringKey_ = NSAttributedString.Key
typealias UIAlertActionStyle_ = UIAlertAction.Style
typealias UIAlertControllerStyle_ = UIAlertController.Style

private let UITableViewAutomaticDimension_ = UITableView.automaticDimension
let UILayoutFittingCompressedSize_ = UIView.layoutFittingCompressedSize

func UIEdgeInsetsMake_(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
}

func UIEdgeInsetsInsetRect_(_ rect: CGRect, _ insets: UIEdgeInsets) -> CGRect {
    return rect.inset(by: insets)
}

#else

public typealias UITextFieldViewMode_ = UITextFieldViewMode
public typealias UITableViewStyle_ = UITableViewStyle
public typealias UITableViewCellStyle_ = UITableViewCellStyle
public typealias UITableViewCellAccessoryType_ = UITableViewCellAccessoryType
public typealias UIViewContentMode_ = UIViewContentMode
public typealias UILayoutConstraintAxis_ = UILayoutConstraintAxis

typealias UIFontTextStyle_ = UIFontTextStyle
typealias NSLayoutAttribute_ = NSLayoutAttribute
typealias NSLayoutRelation_ = NSLayoutRelation
typealias NSAttributedStringKey_ = NSAttributedStringKey
typealias UIAlertActionStyle_ = UIAlertActionStyle
typealias UIAlertControllerStyle_ = UIAlertControllerStyle

private let UITableViewAutomaticDimension_ = UITableViewAutomaticDimension
let UILayoutFittingCompressedSize_ = UILayoutFittingCompressedSize

func UIEdgeInsetsMake_(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top, left, bottom, right)
}

func UIEdgeInsetsInsetRect_(_ rect: CGRect, _ insets: UIEdgeInsets) -> CGRect {
    return UIEdgeInsetsInsetRect(rect, insets)
}

#endif





//MARK: Utils

func Sel(_ any: Any) -> Selector? {
    if let sel = any as? Selector {
        return sel
        
    } else if let selString = any as? String {
        return NSSelectorFromString(selString)
        
    } else {
        return nil
    }
}

func CPKFloat(_ any: Any?) -> CGFloat {
    if any == nil { return 0 }
    
    if let result = CPKFloatOptional(any) {
        return result
    } else {
        assert(false, "invalid float")
        return 0
    }
}

func CPKFloatOptional(_ any: Any?) -> CGFloat? {
    
    if any == nil {
        return nil
        
    } else {
        if let value = any as? CGFloat { return value }
        if let value = any as? String { let f = Float(value); return f != nil ? CGFloat(f!) : nil }
        
        if let value = any as? Int { return CGFloat(value) }
        if let value = any as? UInt { return CGFloat(value) }
        
        if let value = any as? Double { return CGFloat(value) }
        if let value = any as? Float { return CGFloat(value) }
        
        if let value = any as? Int8 { return CGFloat(value) }
        if let value = any as? UInt8 { return CGFloat(value) }
        if let value = any as? Int16 { return CGFloat(value) }
        if let value = any as? UInt16 { return CGFloat(value) }
        if let value = any as? Int32 { return CGFloat(value) }
        if let value = any as? UInt32 { return CGFloat(value) }
        if let value = any as? Int64 { return CGFloat(value) }
        if let value = any as? UInt64 { return CGFloat(value) }
        
        return nil
    }
}

func CPKStringValueOptional(_ any: Any?) -> CGFloat? {
    if let str = any as? String {
        let f = Float(str)
        return f != nil ? CGFloat(f!) : nil
    } else {
        return nil
    }
}

func CPKImageOptional(_ any: Any?) -> UIImage? {
    return (any != nil ? Img(any!) : nil)
}

func cpk_onePointImageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    let hasAlpha = cpk_colorHasAlphaChannel(color)
    UIGraphicsBeginImageContextWithOptions(rect.size, !hasAlpha, UIScreen.main.scale)
    
    let context = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor)
    context.fill(rect)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image!
}

fileprivate func cpk_colorHasAlphaChannel(_ color: UIColor) -> Bool {
    return color.cgColor.alpha < 1;
}

func cpk_imageHasAlphaChannel(_ image: UIImage) -> Bool {
    if let alphaInfo = image.cgImage?.alphaInfo {
        return alphaInfo == .first ||
            alphaInfo == .last ||
            alphaInfo == .premultipliedFirst ||
            alphaInfo == .premultipliedLast
    } else {
        return false
    }
}

func cpk_edgeInsetsFromArray(_ insetArray: [CGFloat]) -> UIEdgeInsets {
    if insetArray.count == 0 {
        return UIEdgeInsetsMake_(0, 0, 0, 0)
        
    } else if insetArray.count == 1 {
        let m1 = insetArray[0]
        return UIEdgeInsetsMake_(m1, m1, m1, m1)
        
    } else if insetArray.count == 2 {
        let m1 = insetArray[0]
        let m2 = insetArray[1]
        return UIEdgeInsetsMake_(m1, m2, m1, m2)
        
    } else if insetArray.count == 3 {
        let m1 = insetArray[0]
        let m2 = insetArray[1]
        let m3 = insetArray[2]
        return UIEdgeInsetsMake_(m1, m2, 0, m3)
        
    } else {
        let m1 = insetArray[0]
        let m2 = insetArray[1]
        let m3 = insetArray[2]
        let m4 = insetArray[3]
        return UIEdgeInsetsMake_(m1, m2, m3, m4)
    }
}

func cpk_edgeInsetsFromParameters(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> UIEdgeInsets {
    var array = [CGFloat]()
    array.append(CPKFloat(p1))
    
    if p2 != nil { array.append(CPKFloat(p2!)) }
    if p3 != nil { array.append(CPKFloat(p3!)) }
    if p4 != nil { array.append(CPKFloat(p4!)) }
    
    return cpk_edgeInsetsFromArray(array)
}

func cpk_edgeInsetsTupleFromParameters(_ p1: Any? = "",
                                       _ p2: Any? = "",
                                       _ p3: Any? = "",
                                       _ p4: Any? = "")
    
    -> (Any?, Any?, Any?, Any?) {
        
        var leftOffset: Any?
        var rightOffset: Any?
        var topOffset: Any?
        var bottomOffset: Any?
        
        let isValidP1 = !(p1 is String) || ((p1 as! String) != "")
        let isValidP2 = !(p2 is String) || ((p2 as! String) != "")
        let isValidP3 = !(p3 is String) || ((p3 as! String) != "")
        let isValidP4 = !(p4 is String) || ((p4 as! String) != "")
        
        if isValidP1 && isValidP2 && isValidP3 && isValidP4 {
            topOffset = (p1 is String) ? p1 : CPKFloatOptional(p1)
            leftOffset = (p2 is String) ? p2 : CPKFloatOptional(p2)
            bottomOffset = (p3 is String) ? p3 : CPKFloatOptional(p3)
            rightOffset = (p4 is String) ? p4 : CPKFloatOptional(p4)
            
        } else if isValidP1 && isValidP2 && isValidP3 {
            topOffset = (p1 is String) ? p1 : CPKFloatOptional(p1)
            leftOffset = (p2 is String) ? p2 : CPKFloatOptional(p2)
            rightOffset = (p3 is String) ? p3 : CPKFloatOptional(p3)
            
        } else if isValidP1 && isValidP2 {
            topOffset = (p1 is String) ? p1 : CPKFloatOptional(p1)
            leftOffset = (p2 is String) ? p2 : CPKFloatOptional(p2)
            bottomOffset = topOffset
            rightOffset = leftOffset
            
        } else if isValidP1 {
            topOffset = (p1 is String) ? p1 : CPKFloatOptional(p1)
            leftOffset = topOffset
            bottomOffset = topOffset
            rightOffset = topOffset
            
        } else {
            topOffset = CGFloat(0)
            leftOffset = CGFloat(0)
            bottomOffset = CGFloat(0)
            rightOffset = CGFloat(0)
        }
        
        return (topOffset, leftOffset, bottomOffset, rightOffset)
}

func cpk_reversedEdgeInsetsFromArray(_ insetArray: [CGFloat]) -> UIEdgeInsets {
    var insets = cpk_edgeInsetsFromArray(insetArray)
    insets.top = -insets.top
    insets.left = -insets.left
    insets.bottom = -insets.bottom
    insets.right = -insets.right
    return insets
}

func cpk_higherHuggingAndResistance(forView view: UIView) {
    view.setContentHuggingPriority(251, for: .horizontal)
    view.setContentHuggingPriority(251, for: .vertical)
    view.setContentCompressionResistancePriority(751, for: .horizontal)
    view.setContentCompressionResistancePriority(751, for: .vertical)
}

func cpk_limitTextInput(_ textInput: UITextInput, maxLength: Int) -> Bool {
    
    if textInput.markedTextRange?.start != nil {
        return true
        
    } else {
        if maxLength > 0, let view = textInput as? UIView {
            if let text = view.value(forKey: "text") as? String {
                
                if text.cpk_length() > maxLength {
                    let newText = text.subTo(maxLength)
                    var needResetCursorPosition = false
                    
                    let selectedRange = textInput.selectedTextRange
                    
                    if selectedRange != nil && selectedRange!.isEmpty {
                        let cursorPosition = selectedRange!.start
                        
                        if let maxPosition = textInput.position(from: textInput.beginningOfDocument,
                                                                offset: maxLength) {
                            if textInput.compare(cursorPosition, to: maxPosition) == .orderedAscending {
                                needResetCursorPosition = true
                            }
                        }
                    }
                    
                    view.setValue(newText, forKey: "text")
                    
                    if needResetCursorPosition {
                        textInput.selectedTextRange = selectedRange
                    }
                }
            }
        }
        
        return false
    }
}

func cpk_getTopViewController() -> UIViewController? {
    func getTopViewController(root: UIViewController?) -> UIViewController? {
        if let navVC = root as? UINavigationController {
            return getTopViewController(root: navVC.viewControllers.last)
            
        } else if let tabVC = root as? UITabBarController {
            return getTopViewController(root: tabVC.selectedViewController)
            
        } else if root != nil, let presentedVC = root!.presentedViewController {
            return presentedVC
            
        } else {
            return root
        }
    }
    
    let window = UIApplication.shared.delegate?.window
    return getTopViewController(root: window??.rootViewController)
}

func cpk_commonAncestorFor(item1: UIView?, item2: UIView?) -> UIView? {
    if let view1 = item1 {
        if let view2 = item2 {
            
            var view: UIView? = view1
            while view != nil && !view2.isDescendant(of: view!) {
                view = view?.superview
            }
            
            return view
            
        } else {
            return item1
        }
        
    } else {
        return item2
    }
}

func cpk_updatePadding(_ padding: [CGFloat], forView view: UIView) {
    if let button = view as? UIButton {
        var insets = cpk_edgeInsetsFromArray(padding)
        button.cpkInsets = insets
        let halfGap = (button.cpkGap ?? 0) / 2
        
        insets.left += halfGap
        insets.right += halfGap
        button.contentEdgeInsets = insets
        
    } else if let textField = view as? UITextField {
        textField.cpkPadding = cpk_edgeInsetsFromArray(padding)
        
    } else if let textView = view as? UITextView {
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = cpk_edgeInsetsFromArray(padding)
    }
}

func cpk_pinOptions(_ options: [CPKViewPinOptions], forView view: UIView) {
    view.makeCons({
        var values = [CGFloat]()
        let priority: UILayoutPriority = 999
        
        for option in options {
            switch option {
            case let .x(offset):
                if let value = CPKStringValueOptional(offset) {
                    $0.left.equal("superview").leftMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(offset) {
                    $0.left.equal(value).priority(priority)
                }
                
            case let .y(offset):
                if let value = CPKStringValueOptional(offset) {
                    $0.top.equal("superview").topMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(offset) {
                    $0.top.equal(value).priority(priority)
                }
                
            case let .w(value):
                view.frame.size.width = value
                $0.width.equal(value).priority(priority)
                
            case let .h(value):
                view.frame.size.height = value
                view.cpk_updateCornerRadiusIfNeed()
                $0.height.equal(value).priority(priority)
            
            case let .xy(v1, v2):
                if let value = CPKStringValueOptional(v1) {
                    $0.left.equal("superview").leftMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(v1) {
                    $0.left.equal(value).priority(priority)
                }
                if let value = CPKStringValueOptional(v2) {
                    $0.top.equal("superview").topMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(v2) {
                    $0.top.equal(value).priority(priority)
                }
                
            case let .wh(v1, v2):
                view.frame.size = CGSize(width: v1, height: v2)
                view.cpk_updateCornerRadiusIfNeed()
                $0.width.height.equal(v1, v2).priority(priority)
                
            case let .xywh(v1, v2, v3, v4):
                view.frame = CGRect(x: v1, y: v2, width: v3, height: v4)
                view.cpk_updateCornerRadiusIfNeed()
                $0.left.top.width.height.equal(v1, v2, v3, v4).priority(priority);
            
            case let .maxX(offset):
                if let value = CPKStringValueOptional(offset) {
                    $0.right.equal("superview").rightMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(offset) {
                    $0.right.equal(value).priority(priority)
                }
                
            case let .maxY(offset):
                if let value = CPKStringValueOptional(offset) {
                    $0.bottom.equal("superview").bottomMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(offset) {
                    $0.bottom.equal(value).priority(priority)
                }
                
            case let .maxXY(v1, v2):
                if let value = CPKStringValueOptional(v1) {
                    $0.right.equal("superview").rightMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(v1) {
                    $0.right.equal(value).priority(priority)
                }
                if let value = CPKStringValueOptional(v2) {
                    $0.bottom.equal("superview").bottomMargin.offset(value).priority(priority)
                } else if let value = CPKFloatOptional(v2) {
                    $0.bottom.equal(value).priority(priority)
                }
                
            case let .centerX(offset):
                $0.centerX.equal(offset)
                
            case let .centerY(offset):
                $0.centerY.equal(offset)
                
            case let .centerXY(v1, v2):
                $0.center.equal(v1, v2)
                
            case let .whRatio(ratio): $0.width.equal(view).height.multiply(ratio)
                
            case .center:
                $0.center.equal(0)
                
            case .ratio:
                $0.width.equal(view).height.multiply(view.frame.width / view.frame.height)
                
            case let .hhp(value): view.setContentHuggingPriority(value, for: .horizontal)
            case let .vhp(value): view.setContentHuggingPriority(value, for: .vertical)
            case let .hrp(value): view.setContentCompressionResistancePriority(value, for: .horizontal)
            case let .vrp(value): view.setContentCompressionResistancePriority(value, for: .vertical)
                
            case .lowHugging:
                view.setContentHuggingPriority(kLowPriority, for: .horizontal)
                view.setContentHuggingPriority(kLowPriority, for: .vertical)
                
            case .lowResistance:
                view.setContentCompressionResistancePriority(kLowPriority, for: .horizontal)
                view.setContentCompressionResistancePriority(kLowPriority, for: .vertical)
                
            case let .___value(value):
                values.append(value)
            }
        }
        
        if values.count == 1 {
            view.frame.size.height = values[0]
            view.cpk_updateCornerRadiusIfNeed()
            $0.height.equal(values[0]).priority(priority)
        } else if values.count == 2 {
            view.frame.size = CGSize(width: values[0], height: values[1])
            view.cpk_updateCornerRadiusIfNeed()
            $0.size.equal(values[0], values[1]).priority(priority)
        } else if values.count == 4 {
            view.frame = CGRect(x: values[0], y: values[1], width: values[2], height: values[3])
            view.cpk_updateCornerRadiusIfNeed()
            $0.origin.size.equal(values[0], values[1], values[2], values[3]).priority(priority)
        }
    })
}

func cpk_canActivateConstraint(_ constraint: NSLayoutConstraint) -> Bool {
    return cpk_commonAncestorFor(item1: constraint.firstItem as? UIView,
                                 item2: constraint.secondItem as? UIView) != nil
}










































//MARK: Private extensions

fileprivate var cpkObjectAssociatedObject: UInt8 = 0

let CPKLabelLinkAttributeName    = "CPKLabelLink"
let CPKLabelLinkAttributeValue   = "CPKLabelLinkValue"

fileprivate let CPKLinkColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)


public extension NSObject {
    
    @discardableResult
    static func cpk_swizzle(method1: Any, method2: Any) -> Bool {
        var s1 = method1 as? Selector
        var s2 = method2 as? Selector
        
        if s1 == nil, let name = method1 as? String {
            s1 = NSSelectorFromString(name)
        }
        
        if s2 == nil, let name = method2 as? String {
            s2 = NSSelectorFromString(name)
        }
        
        if s1 == nil || s2 == nil {
            return false
        }
        
        var m1 = class_getInstanceMethod(self, s1!)
        var m2 = class_getInstanceMethod(self, s2!)
        
        if m1 == nil || m2 == nil {
            return false
        }
        
        class_addMethod(self, s1!, method_getImplementation(m1!), method_getTypeEncoding(m1!))
        class_addMethod(self, s2!, method_getImplementation(m2!), method_getTypeEncoding(m2!))
        
        m1 = class_getInstanceMethod(self, s1!)
        m2 = class_getInstanceMethod(self, s2!)
        method_exchangeImplementations(m1!, m2!)
        
        return true
    }
    
//    @discardableResult
//    public static func cpk_swizzleClass(method1: Any, method2: Any) -> Bool {
//        return object_getClass(self).cpk_swizzle(method1: method1, method2: method2)
//    }
    
    @discardableResult
    func cpk_safePerform(selector: Selector) -> Any? {
        if self.responds(to: selector) {
            return self.perform(selector).takeRetainedValue()
        } else {
            return nil
        }
    }
    
    @discardableResult
    static func cpk_safePerform(selector: Selector) -> Any? {
        if self.responds(to: selector) {
            return self.perform(selector).takeRetainedValue()
        } else {
            return nil
        }
    }
    
    func cpk_associatedObjectFor(key: String) -> Any? {
        if let dict = objc_getAssociatedObject(self, &cpkObjectAssociatedObject) as? NSMutableDictionary {
            return dict[key]
        } else {
            return nil
        }
    }
    
    func cpk_setAssociated(object: Any?, forKey key: String) {
        var dict = objc_getAssociatedObject(self, &cpkObjectAssociatedObject) as? NSMutableDictionary
        
        if dict == nil {
            dict = NSMutableDictionary()
            objc_setAssociatedObject(self, &cpkObjectAssociatedObject, dict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        dict![key] = object
    }
}



extension String {
    func cpk_length() -> NSInteger {
        #if swift(>=3.2)
            return self.count
        #else
            return self.characters.count
        #endif
    }
    
    func cpk_substring(with range: Range<String.Index>) -> String {
        #if swift(>=4.0)
            return String(self[range])
        #else
            return self.substring(with: range)
        #endif
    }
    
    func cpk_substring(to index: String.Index) -> String {
        #if swift(>=4.0)
            return String(self[..<index])
        #else
            return self.substring(to: index)
        #endif
    }
    
    func cpk_substring(from index: String.Index) -> String {
        #if swift(>=4.0)
            return String(self[index...])
        #else
            return self.substring(from: index)
        #endif
    }
}


extension NSMutableAttributedString {
    
    private var cpkSelectedRanges: NSMutableIndexSet {
        get {
            var indexSet = cpk_associatedObjectFor(key: #function) as? NSMutableIndexSet
            if indexSet == nil {
                indexSet = NSMutableIndexSet()
                cpk_setAssociated(object: indexSet, forKey: #function)
            }
            return indexSet!
        }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    private var cpkIsJustSelectingRange: Bool {
        get { return (cpk_associatedObjectFor(key: #function) as? Bool) ?? false }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    var cpkPreventOverrideAttribute: Bool {
        get { return (cpk_associatedObjectFor(key: #function) as? Bool) ?? false }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    func cpk_select(range: NSRange?, setFlag: Bool = true) {
        if !self.cpkIsJustSelectingRange {
            self.cpkSelectedRanges.removeAllIndexes()
        }
        
        if range != nil {
            self.cpkSelectedRanges.add(in: range!)
        }
        
        if setFlag {
            self.cpkIsJustSelectingRange = true
        }
    }
    
    func cpk_addAttribute(_ name: String, value: Any, range: NSRange) {
        #if swift(>=4.0)
            addAttribute(NSAttributedStringKey_(rawValue: name), value: value, range: range)
        #else
            addAttribute(name, value: value, range: range)
        #endif
    }
    
    func cpk_addAttribute(name: String, value: Any) {
        self.cpkIsJustSelectingRange = false
        
        self.cpkSelectedRanges.enumerateRanges({ (range, stop) in
            
            if name == CPKLabelLinkAttributeName {
                cpk_addAttribute(name, value: value, range: range)
                cpk_addAttribute("NSColor", value: CPKLinkColor, range: range)
                
            } else {
                if self.cpkPreventOverrideAttribute {
                    cpk_addAttributeIfNotExisted(name: name, value: value, range: range)
                } else {
                    cpk_addAttribute(name, value: value, range: range)
                }
            }
        });
    }
    
    func cpk_addAttributeIfNotExisted(name: String, value: Any, range: NSRange) {
        let indexSets = NSMutableIndexSet(indexesIn: range)
        
        #if swift(>=4.0)
            enumerateAttribute(NSAttributedStringKey_(rawValue: name),
                               in: range,
                               options: NSAttributedString.EnumerationOptions(rawValue: 0))
            { (value, range, stop) in
            if value != nil {
                indexSets.remove(in: range)
            }
        }
        #else
            enumerateAttribute(name,
                               in: range,
                               options: NSAttributedString.EnumerationOptions(rawValue: 0))
            { (value, range, stop) in
            if value != nil {
                indexSets.remove(in: range)
            }
        }
        #endif
        
        indexSets.enumerateRanges({ (range, stop) in
            cpk_addAttribute(name, value: value, range: range)
        })
    }
    
    func cpk_addParagraphAttribute(key: String, value: Any, range: NSRange? = nil) {
        let targetRange = range ?? NSMakeRange(0, self.length)
        var mutableStyle: NSMutableParagraphStyle
        
        if let paraStyle = attribute("NSParagraphStyle",
                                     at: targetRange.location,
                                     longestEffectiveRange: nil,
                                     in: targetRange) as? NSParagraphStyle {
            
            mutableStyle = paraStyle.mutableCopy() as! NSMutableParagraphStyle
            
        } else {
            mutableStyle = NSMutableParagraphStyle()
            mutableStyle.lineBreakMode = .byTruncatingTail
        }
        
        mutableStyle.setValue(value, forKey: key)
        cpk_addAttribute("NSParagraphStyle", value: mutableStyle, range: targetRange)
    }
}


fileprivate var __flagForMethodSwizzle__: Bool = false

func cpk_swizzleMethodsIfNeed() {
    if !__flagForMethodSwizzle__ {
        __flagForMethodSwizzle__ = true
        
        UIView.cpk_swizzle(method1: "setBounds:",
                           method2: #selector(UIView.cpk_setBounds))
        UIView.cpk_swizzle(method1: #selector(UIView.point(inside:with:)),
                           method2: #selector(UIView.cpk_point(inside:with:)))
        
        UILabel.cpk_swizzle(method1: #selector(setter: UILabel.text),
                            method2: #selector(UILabel.ner_setText(_:)))
        
        
        UITextField.cpk_swizzle(method1: #selector(UITextField.textRect(forBounds:)),
                                method2: #selector(UITextField.cpk_textRect(forBounds:)))
        UITextField.cpk_swizzle(method1: #selector(UITextField.editingRect(forBounds:)),
                                method2: #selector(UITextField.cpk_editingRect(forBounds:)))
        
        UITextView.cpk_swizzle(method1: "dealloc", method2: #selector(UITextView.cpk_deinit))
    }
}

extension UIApplication {
    open override var next: UIResponder? {
        cpk_swizzleMethodsIfNeed()
        return super.next
    }
}


extension UIView {
    
    var cpkAutoRoundingRadius: Bool {
        get { return cpk_associatedObjectFor(key: #function) as? Bool ?? false }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    var cpkTouchInsets: UIEdgeInsets? {
        get { return cpk_associatedObjectFor(key: #function) as? UIEdgeInsets }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    @objc func cpk_setBounds(_ frame: CGRect) {
        cpk_setBounds(frame)
        cpk_updateCornerRadiusIfNeed()
    }
    
    @objc func cpk_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let insets = self.cpkTouchInsets {
            let rect = UIEdgeInsetsInsetRect_(self.bounds, insets)
            return rect.contains(point)
        } else {
            return self.cpk_point(inside: point, with: event)
        }
    }
    
    @objc func cpk_masksToBoundsIfNeed() {
        self.layer.masksToBounds = false
    }
    
    fileprivate func cpk_updateCornerRadiusIfNeed() {
        if self.cpkAutoRoundingRadius {
            self.layer.cornerRadius = self.bounds.height / 2
            cpk_masksToBoundsIfNeed()
        }
    }
    
    func cpk_onClick(_ closureOrTarget: Any, _ action: Any? = nil) {
        func cpk_onClickInner(target: Any, action: Any ) {
            var sel = action as? Selector
            if sel == nil, let methodName = action as? String {
                sel = NSSelectorFromString(methodName)
            }
            
            if let button = (self as Any) as? UIButton {
                button.addTarget(target, action: sel!, for: .touchUpInside)
            } else {
                let tap = UITapGestureRecognizer.init(target: target, action: sel!)
                self.addGestureRecognizer(tap)
            }
        }
        
        isUserInteractionEnabled = true
        
        if let action = action {
            cpk_onClickInner(target: closureOrTarget, action: action)
        } else {
            cpk_onClickInner(target: self, action: #selector(UIView.cpk_onClickHandler))
            cpk_setAssociated(object: closureOrTarget, forKey: "cpk_OnClick")
        }
    }
    
    @objc func cpk_onClickHandler() {
        let callback = cpk_associatedObjectFor(key: "cpk_OnClick")
        
        if let closure = callback as? ()->() {
            closure()
        } else if let closure = callback as? ()->(Any) {
            let _ = closure()
        } else if let closure = callback as? (UIView)->() {
            closure(self)
        } else if let closure = callback as? ((UILabel)->()), let view = (self as Any) as? UILabel {
            closure(view)
        } else if let closure = callback as? ((UIImageView)->()), let view = (self as Any) as? UIImageView {
            closure(view)
        } else if let closure = callback as? ((UIButton)->()), let view = (self as Any) as? UIButton {
            closure(view)
        } else if let closure = callback as? ((UITextField)->()), let view = (self as Any) as? UITextField {
            closure(view)
        } else if let closure = callback as? ((UITextView)->()), let view = (self as Any) as? UITextView {
            closure(view)
        } else if let closure = callback as? ((CPKStackView)->()), let view = (self as Any) as? CPKStackView {
            closure(view)
        } else if let closure = callback as? ((Any)->()) {
            closure(self)
        }
    }
    
    func cpk_onTap(_ closure: @escaping ()->Void) {
        isUserInteractionEnabled = true
        
        let sel = #selector(UIView.cpk_onTapHandler)
        if let button = (self as Any) as? UIButton {
            button.addTarget(self, action: sel, for: .touchUpInside)
        } else {
            let tap = UITapGestureRecognizer.init(target: self, action: sel)
            self.addGestureRecognizer(tap)
        }
        cpk_setAssociated(object: closure, forKey: "cpk_OnTap")
    }
    
    @objc func cpk_onTapHandler() {
        let callback = cpk_associatedObjectFor(key: "cpk_OnTap")
        if let closure = callback as? ()->() {
            closure()
        }
    }
    
    func cpk_generateCallbackClosure(_ closureOrTarget: Any, _ action: Any? = nil) -> Any? {
        if action == nil {
            return closureOrTarget
            
        } else {
            if let target = closureOrTarget as? NSObject {
                weak var weakTarget = target
                weak var weakSelf = self
                let sel = Sel(action!)
                
                return {
                    let _ = weakTarget?.perform(sel, with: weakSelf)
                    return
                }
                
            } else {
                return nil
            }
        }
    }
}


extension UILabel {
    override func cpk_masksToBoundsIfNeed() {
        self.layer.masksToBounds = self.layer.cornerRadius > 0
    }
}


extension UIImageView {
    override func cpk_masksToBoundsIfNeed() {
        self.layer.masksToBounds = self.layer.cornerRadius > 0 && self.image != nil
    }
}


extension UIButton {
    var cpkGap: CGFloat? {
        get { return cpk_associatedObjectFor(key: #function) as? CGFloat }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    var cpkInsets: UIEdgeInsets? {
        get { return cpk_associatedObjectFor(key: #function) as? UIEdgeInsets }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    override func cpk_masksToBoundsIfNeed() {
        let img = image(for: .normal)
        let highImg = image(for: .highlighted)
        let bgImg = backgroundImage(for: .normal)
        let highBgImg = backgroundImage(for: .highlighted)
        
        let hasImage = (img != nil || highImg != nil || bgImg != nil || highBgImg != nil)
        self.layer.masksToBounds = (self.layer.cornerRadius > 0 && hasImage)
    }
}


extension UITextField {
    var cpkMaxLength: Int {
        get { return cpk_associatedObjectFor(key: #function) as? Int ?? 0 }
        set { cpk_setAssociated(object: newValue, forKey: #function); cpk_watchTextChange() }
    }
    
    var cpkPadding: UIEdgeInsets {
        get { return cpk_associatedObjectFor(key: #function) as? UIEdgeInsets ?? UIEdgeInsetsMake_(0, 0, 0, 0) }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    var cpkTextChangedClosure: Any? {
        get { return cpk_associatedObjectFor(key: #function) }
        set { cpk_setAssociated(object: newValue, forKey: #function); cpk_watchTextChange() }
    }
    
    var cpkDidEndOnExistClosure: Any? {
        get { return cpk_associatedObjectFor(key: #function) }
        set { cpk_setAssociated(object: newValue, forKey: #function); cpk_watchOnEndEvent() }
    }
    
    @objc public func cpk_textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = self.cpk_textRect(forBounds: bounds)
        return UIEdgeInsetsInsetRect_(rect, self.cpkPadding)
    }
    
    @objc public func cpk_editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = cpk_editingRect(forBounds: bounds)
        return UIEdgeInsetsInsetRect_(rect, self.cpkPadding)
    }
    
    private func cpk_watchTextChange() {
        let sel = #selector(cpk_textDidChange)
        removeTarget(self, action: sel, for: .editingChanged)
        addTarget(self, action: sel, for: .editingChanged)
    }
    
    private func cpk_watchOnEndEvent() {
        let sel = #selector(cpk_didEndOnExit)
        removeTarget(self, action: sel, for: .editingDidEndOnExit)
        addTarget(self, action: sel, for: .editingDidEndOnExit)
    }
    
    @objc func cpk_textDidChange() {
        let hasMarked = cpk_limitTextInput(self, maxLength: self.cpkMaxLength)
        if !hasMarked {
            if let closure = self.cpkTextChangedClosure as? (UITextField)->() {
                closure(self)
            }
        }
    }
    
    @objc func cpk_didEndOnExit() {
        if let closure = self.cpkDidEndOnExistClosure as? (UITextField)->() {
            closure(self)
        }
    }
}


extension AttStrSelectionOptions : ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: String) {
        self = .match(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self = .match(value)
    }
    
    public init(stringLiteral value: String) {
        self = .match(value)
    }
}


extension CPKViewPinOptions : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = .___value(CGFloat(value))
    }
    
    public init(floatLiteral value: Float) {
        self = .___value(CGFloat(value))
    }
}


#if swift(>=4.0)
extension UILayoutPriority : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = UILayoutPriority(rawValue: Float(value))
    }
    public init(floatLiteral value: Float) {
        self = UILayoutPriority(rawValue: value)
    }
}
extension NSAttributedStringKey_ : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = NSAttributedStringKey_(rawValue: value)
    }
}
#endif












































//MARK: AlertMaker

public class AlertMaker {
    var cpkTitle: Any?
    var cpkMessage: Any?
    var cpkTint: Any?
    var cpkStyle: UIAlertControllerStyle_
    
    private var actions = [UIAlertAction]()
    
    init(style: UIAlertControllerStyle_) {
        self.cpkStyle = style
    }
    
    func cpk_addAction(style: UIAlertActionStyle_, title: Any, handler: (()->())? ) {
        var titleString: String?
        var titleColor: UIColor?
        
        if let attTitle = title as? NSAttributedString {
            titleString = attTitle.string
            titleColor = attTitle.attribute("NSColor", at: 0, effectiveRange: nil) as? UIColor
        } else {
            titleString = String(describing: title)
        }
        
        let action = UIAlertAction(title: titleString, style: style) { (action) in
            if let callback = handler {
                callback()
            }
        }
        
        if titleColor != nil {
            action.setValue(titleColor!, forKey: "titleTextColor")
        }
        
        actions.append(action)
    }
    
    func cpk_present(_ inside: UIViewController?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: self.cpkStyle)
        alert.view.tintColor = Color(self.cpkTint)
        
        if let attTitle = self.cpkTitle as? NSAttributedString {
            alert.setValue(attTitle, forKey: "attributedTitle")
        } else if let title = self.cpkTitle {
            alert.title = String(describing: title)
        }
        
        if let attMessage = self.cpkMessage as? NSAttributedString {
            alert.setValue(attMessage, forKey: "attributedMessage")
        } else if let message = self.cpkMessage {
            alert.message = String(describing: message)
        }
        
        for action in self.actions {
            alert.addAction(action)
        }
        
        if let vc = (inside ?? cpk_getTopViewController()) {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}















































//MARK: ConsMaker

public class ConsAtts: NSObject {
    @discardableResult
    func addAttributes(_ attributes: NSLayoutAttribute_...) -> Cons {
        //only for override
        return Cons(firstItem: UIView())
    }
}

public class Cons: ConsAtts {
    private let firstItem: UIView
    private var secondItem: UIView?
    private var secondItemReferToSuperview = false
    
    var relation = NSLayoutRelation_.equal
    
    var firstItemAttributes = [NSLayoutAttribute_]()
    var secondItemAttributes = [NSLayoutAttribute_]()
    
    var multiplierValues = [CGFloat]()
    var constantValues = [CGFloat]()
    var priorityValues = [UILayoutPriority]()
    
    var storePointers = [UnsafeMutablePointer<NSLayoutConstraint>]()
    
    
    init(firstItem: UIView) {
        self.firstItem = firstItem
        self.firstItem.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult
    override func addAttributes(_ attributes: NSLayoutAttribute_...) -> Cons {
        for att in attributes {
            if secondItem == nil && !secondItemReferToSuperview {
                firstItemAttributes.append(att)
            } else {
                secondItemAttributes.append(att)
            }
        }
        return self
    }
    
    func updateSecondItem(_ item2OrValues: [Any]) {
        if let item2 = item2OrValues.first as? UIView {
            self.secondItem = item2
            
        } else if let item2 = item2OrValues.first as? String {
            if item2 == "self" {
                self.secondItem = self.firstItem
            } else if item2 == "superview" {
                self.secondItem = nil
                self.secondItemReferToSuperview = true
            } else {
                assert(false, "invalid second item")
            }
            
        } else {
            self.secondItem = nil
            for any in item2OrValues {
                
                if let point = any as? CGPoint {
                    self.constantValues.append(point.x)
                    self.constantValues.append(point.y)
                    
                } else if let size = any as? CGSize {
                    self.constantValues.append(size.width)
                    self.constantValues.append(size.height)
                    
                } else if let rect = any as? CGRect {
                    self.constantValues.append(rect.origin.x)
                    self.constantValues.append(rect.origin.y)
                    self.constantValues.append(rect.size.width)
                    self.constantValues.append(rect.size.height)
                    
                } else if let insets = any as? UIEdgeInsets {
                    self.constantValues.append(insets.top)
                    self.constantValues.append(insets.left)
                    self.constantValues.append(insets.bottom)
                    self.constantValues.append(insets.right)
                    
                } else {
                    self.constantValues.append(CPKFloat(any))
                }
            }
        }
    }
    
    private func multiplierValue(atIndex index: Int) -> CGFloat {
        var multiplier: CGFloat = 1
        
        if index < multiplierValues.count {
            multiplier = multiplierValues[index]
        } else if let last = multiplierValues.last {
            multiplier = last
        }
        
        return multiplier != 0 ? multiplier : 1
    }
    
    private func constantValue(atIndex index: Int) -> CGFloat {
        var constant: CGFloat = 0
        
        if index < constantValues.count {
            constant = constantValues[index]
        } else if let last = constantValues.last {
            constant = last
        }
        
        return constant
    }
    
    private func priorityValue(atIndex index: Int) -> UILayoutPriority {
        var priority: UILayoutPriority = 1000
        
        if index < priorityValues.count {
            priority = priorityValues[index]
        } else if let last = priorityValues.last {
            priority = last
        }
        
        return priority
    }
    
    private func secondItemValue(att1: NSLayoutAttribute_) -> UIView? {
        var secondItem = self.secondItem
        if (secondItem == nil && att1 != .width && att1 != .height) {
            secondItem = self.firstItem.superview
        }
        return secondItem
    }
    
    fileprivate func makeConstraints() -> [NSLayoutConstraint] {
        var layoutConstraints = [NSLayoutConstraint]()
        
        for i in 0..<firstItemAttributes.count {
            let att1 = firstItemAttributes[i]
            let att2 = (i < secondItemAttributes.count ? secondItemAttributes[i] : att1)
            
            let multiplier = multiplierValue(atIndex:i)
            let constant = constantValue(atIndex: i)
            let priority = priorityValue(atIndex: i)
            
            let secondItem =  secondItemValue(att1: att1)
            
            let c = NSLayoutConstraint(item: self.firstItem,
                                       attribute: att1,
                                       relatedBy: self.relation,
                                       toItem: secondItem,
                                       attribute: att2,
                                       multiplier: multiplier,
                                       constant: constant)
            
            #if swift(>=4.0)
            c.priority = priority
            #else
            c.priority = Float(priority)
            #endif
            layoutConstraints.append(c)
        }
        
        return layoutConstraints
    }
    
    fileprivate func shouldDelayMakingConstraints() -> Bool {
        
        for att in self.firstItemAttributes {
            if !((att == .width || att == .height) && self.secondItem == nil)  {
                if self.firstItem.superview == nil {
                    return true
                }
            }
        }
        
        return false
    }
}


public class ConsMaker: ConsAtts {
    private let firstItem: UIView
    private var cons = [Cons]()
    
    init(firstItem: UIView) {
        self.firstItem = firstItem
    }
    
    @discardableResult
    override func addAttributes(_ attributes: NSLayoutAttribute_...) -> Cons {
        let c = Cons(firstItem: firstItem)
        cons.append(c)
        
        for att in attributes {
            c.addAttributes(att)
        }
        return c
    }
    
    private func activiteConstraints(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
        self.firstItem.cpk_addInstalledConstraints(constraints)
    }
    
    private func shouldDelayMakingConstraints() -> Bool {
        for c in cons {
            if c.shouldDelayMakingConstraints() {
                return true
            }
        }
        return false
    }
    
    func remakeConstraints() {
        self.firstItem.cpk_removeAllInstalledConstraints()
        
        func makeConstraintsPrivate() {
            var layoutConstraints = [NSLayoutConstraint]()
            for c in cons {
                let constraints = c.makeConstraints()
                layoutConstraints.append(contentsOf: constraints)
                
                for (index, constraint) in constraints.enumerated() {
                    if index < c.storePointers.count {
                        let pointer = c.storePointers[index]
                        pointer.pointee = constraint
                    }
                }
            }
            activiteConstraints(layoutConstraints)
        }
        
        if shouldDelayMakingConstraints() {
            DelayedConstraints.addOperation(makeConstraintsPrivate)
        } else {
            makeConstraintsPrivate()
        }
    }
    
    func updateConstraints() {
        
        func updateConstraintsPrivate() {
            var newConstraints = [NSLayoutConstraint]()
            
            for c in cons {
                let layoutConstraints = c.makeConstraints()
                
                for (index, constraint) in layoutConstraints.enumerated() {
                    var target = constraint
                    
                    if let old = self.firstItem.cpk_similarInstalledConstraint(constraint) {
                        old.constant = constraint.constant
                        target = old
                        
                    } else {
                        newConstraints.append(constraint)
                    }
                    
                    if index < c.storePointers.count {
                        let pointer = c.storePointers[index]
                        pointer.pointee = target
                    }
                }
            }
            
            activiteConstraints(newConstraints)
        }
        
        if shouldDelayMakingConstraints() {
            DelayedConstraints.addOperation(updateConstraintsPrivate)
        } else {
            updateConstraintsPrivate()
        }
    }
}


fileprivate extension UIView {
    var cpkInstalledConstraints: NSHashTable<NSLayoutConstraint> {
        var hash = cpk_associatedObjectFor(key: "cpkInstalledConstraints") as? NSHashTable<NSLayoutConstraint>
        if (hash == nil) {
            hash = NSHashTable.weakObjects()
            cpk_setAssociated(object: hash, forKey: "cpkInstalledConstraints")
        }
        return hash!
    }
    
    func cpk_similarInstalledConstraint(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint? {
        for target in self.cpkInstalledConstraints.allObjects {
            if target.cpk_isSimilarTo(constraint: constraint) {
                return target
            }
        }
        return nil;
    }
    
    func cpk_addInstalledConstraints(_ constraints: [NSLayoutConstraint]) {
        let hash = self.cpkInstalledConstraints
        for constraint in constraints {
            hash.add(constraint)
        }
    }
    
    func cpk_removeAllInstalledConstraints() {
        NSLayoutConstraint.deactivate(self.cpkInstalledConstraints.allObjects)
        self.cpkInstalledConstraints.removeAllObjects()
    }
}

fileprivate extension NSLayoutConstraint {
    func cpk_isSimilarTo(constraint: NSLayoutConstraint) -> Bool {
        return  self.firstItem === constraint.firstItem &&
            self.secondItem === constraint.secondItem &&
            self.firstAttribute == constraint.firstAttribute &&
            self.secondAttribute == constraint.secondAttribute &&
            self.relation == constraint.relation &&
            self.priority == constraint.priority &&
            self.multiplier == constraint.multiplier
    }
}

fileprivate class DelayedConstraints {
    private static var delayedOperations = [()->()]()
    private static var isWaiting = false
    
    class func addOperation(_ operation: @escaping ()->()) {
        
        delayedOperations.append(operation)
        
        if !isWaiting {
            isWaiting = true
            
            CFRunLoopPerformBlock(CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue, {
                for o in delayedOperations { o() }
                delayedOperations.removeAll()
                isWaiting = false
            })
        }
    }
}














































/**
 * StylesMaker
 */
let CPKStylesBorderWidth = "CPKBorderWidth"
let CPKStyleBOrderColor = "CPKBorderColor"

public class StylesMaker: NSObject {
    static var globalStyles = Dictionary<String, StylesMaker>()
    
    private var styles = Dictionary<String, Any>()
    
    convenience init(view: UIView) {
        self.init()
        
        //UIView
        if let bgColor = view.backgroundColor {
            self.bg(bgColor)
        }
        
        if view.cpkAutoRoundingRadius {
            self.radius(-1)
        } else {
            self.radius(view.layer.cornerRadius)
        }
        
        if let tint = view.tintColor {
            self.tint(tint)
        }
        self.border(view.layer.borderWidth, view.layer.borderColor)
        
        self.shadow(CGFloat(view.layer.shadowOpacity),
                    view.layer.shadowRadius,
                    view.layer.shadowOffset.width,
                    view.layer.shadowOffset.height)
        
        if let touchInsets = view.cpkTouchInsets {
            addStyle(key: "touchInsets", value: touchInsets)
        }

        
        //UILabel
        if let label = view as? UILabel {
            if let attStr = label.attributedText {
                self.str(attStr)
            } else if let str = label.text {
                self.str(str).font(label.font!).color(label.textColor!)
            }
            
            self.lines(CGFloat(label.numberOfLines)).align(label.textAlignment)
            
            if let lineGap = label.cpkLineGap {
                self.lineGap(lineGap)
            }
        }
        
        
        //UIImageView
        if let imageView = view as? UIImageView {
            if let image = imageView.image {
                self.img(image)
            }
            self.mode(imageView.contentMode)
        }
        
        
        //UIButton
        if let button = view as? UIButton {
            if let attStr = button.attributedTitle(for: .normal) {
                self.str(attStr)
            } else if let str = button.title(for: .normal) {
                self.str(str)
                
                if let font = button.titleLabel?.font {
                    self.font(font)
                }
                
                if let color = button.titleColor(for: .normal) {
                    self.color(color)
                }
            }
            
            if let highColor = button.titleColor(for: .highlighted) {
                self.highColor(highColor)
            }
            
            if let img = button.image(for: .normal) {
                self.img(img)
            }
            
            if let highImg = button.image(for: .highlighted) {
                self.highImg(highImg)
            }
            
            if let bg = button.backgroundImage(for: .normal) {
                self.bg(bg)
            }
            
            if let highBg = button.backgroundImage(for: .highlighted) {
                self.highBg(highBg)
            }
            
            self.padding(button.contentEdgeInsets.top,
                         button.contentEdgeInsets.left,
                         button.contentEdgeInsets.bottom,
                         button.contentEdgeInsets.right)
            
            if let gap = button.cpkGap {
                self.gap(gap)
            }
            
            if CATransform3DEqualToTransform(button.layer.sublayerTransform, CATransform3DMakeScale(-1, 1, 1)) {
                self.reversed(true)
            }
            
            if let lines = button.titleLabel?.numberOfLines {
                if (lines != 1) {
                    self.lines(CGFloat(lines))
                }
            }
        }
        
        
        //UITextFiled
        if let textField = view as? UITextField {
            if let attStr = textField.attributedText {
                self.str(attStr)
            } else if let str = textField.text {
                self.str(str)
                
                if let font = textField.font {
                    self.font(font)
                }
                
                if let color = textField.textColor {
                    self.color(color)
                }
            }
            
            if let attHint = textField.attributedPlaceholder {
                self.hint(attHint)
            } else if let hint = textField.placeholder {
                self.hint(hint)
            }
            
            self.maxLength(CGFloat(textField.cpkMaxLength))
            
            let padding = textField.cpkPadding
            self.padding(padding.top, padding.left, padding.bottom, padding.right)
            
            self.secure(textField.isSecureTextEntry).align(textField.textAlignment)
            self.keyboard(textField.keyboardType).returnKey(textField.returnKeyType)
            self.clearMode(textField.clearButtonMode)
        }
        
        
        //UITextView
        if let textView = view as? UITextView {
            if let attStr = textView.attributedText {
                self.str(attStr)
            } else if let str = textView.text {
                self.str(str)
                
                if let font = textView.font {
                    self.font(font)
                }
                
                if let color = textView.textColor {
                    self.color(color)
                }
            }
            
            if let hintLabel = textView.cpkPlaceholderLabel {
                if let attHint = hintLabel.attributedText {
                    self.hint(attHint)
                } else if let hint = hintLabel.text {
                    self.hint(hint)
                }
            }
            
            self.maxLength(CGFloat(textView.cpkMaxLength)).align(textView.textAlignment)
            
            if textView.textContainer.lineFragmentPadding == 0 {
                let inset = textView.textContainerInset
                self.padding(inset.top, inset.left, inset.bottom, inset.right)
            }
        }
    }
    
    
    @discardableResult func addStyle(key: String, value: Any) -> Self {
        styles[key] = value
        return self
    }
    
    func applyTo(view: UIView) {
        for (k, value) in styles {
            var key = k.subTo("(")
            key = key.count > 0 ? key : k
            
            if key == "radius" {
                view.radius(value as! CGFloat)
                
            } else if key == "lines" {
                if let label = view as? UILabel {
                    label.lines(value as! CGFloat)
                } else if let button = view as? UIButton {
                    button.lines(value as! CGFloat)
                }
                
            } else if key == "lineGap" {
                if let label = view as? UILabel {
                    label.lineGap(value as! CGFloat)
                }
                
            } else if key == "gap" {
                if let button = view as? UIButton {
                    button.gap(value as! CGFloat)
                }
                
            } else if key == "reversed" {
                if let button = view as? UIButton {
                    button.reversed(value as! Bool)
                }
                
            } else if key == "touchInsets" {
                if let insets = value as? UIEdgeInsets {
                    view.touchInsets(insets.top, insets.left, insets.bottom, insets.right)
                }
                
            } else if key == "border" {
                if let dict = value as? Dictionary<String, Any> {
                    view.border(CPKFloat(dict["borderWidth"]), dict["borderColor"])
                }
                
            } else if key == "shadow" {
                if let dict = value as? Dictionary<String, CGFloat> {
                    view.shadow(dict["opacity"]!, dict["radius"]!, dict["offsetX"]!, dict["offsetY"]!)
                }
                
            } else if key == "pin" {
                cpk_pinOptions(value as! [CPKViewPinOptions], forView: view)
                
            } else if key == "align" {
                if let stack = view as? CPKStackView {
                    stack.align(value as! CPKStackAlignment)
                } else if let label = view as? UILabel {
                    label.align(value as! NSTextAlignment)
                } else if let textField = view as? UITextField {
                    textField.align(value as! NSTextAlignment)
                } else if let textView = view as? UITextView {
                    textView.align(value as! NSTextAlignment)
                }
                
            } else if key == "mode" {
                if let imageView = view as? UIImageView {
                    imageView.mode(value as! UIViewContentMode_)
                }
                
            } else if key == "reversed" {
                if let button = view as? UIButton {
                    button.reversed(value as! Bool)
                }
                
            } else if key == "maxLength" {
                if let textField = view as? UITextField {
                    textField.maxLength(value as! CGFloat)
                } else if let textView = view as? UITextView {
                    textView.maxLength(value as! CGFloat)
                }
                
            } else if key == "padding" {
                cpk_updatePadding(value as! [CGFloat], forView: view)
            }
                
            else if key == "secure" {
                if let textField = view as? UITextField {
                    textField.secure(value as! Bool)
                }
            }
                
            else if key == "keyboard" {
                if let textField = view as? UITextField {
                    textField.keyboard(value as! UIKeyboardType)
                }
            }
                
            else if key == "returnKey" {
                if let textField = view as? UITextField {
                    textField.returnKey(value as! UIReturnKeyType)
                }
            }
                
            else if key == "clearMode" {
                if let textField = view as? UITextField {
                    textField.clearMode(value as! UITextFieldViewMode_)
                }
            }
                
            else {
                let sel = NSSelectorFromString(key + ":")
                if view.responds(to: sel) {
                    view.perform(sel, with: value)
                }
            }
        }
    }
}














































//MARK: StaticTableView

public enum CPKTableViewCellAccessoryType {
    case none
    case disclosureIndicator
    case detailDisclosureButton
    case checkmark
    case detailButton
    case view(UIView)       //AccessoryView
}

public class StaticTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    public var checkedIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        
        for section in sections {
            for row in section.rows {
                if row.accessoryType != nil && row.accessoryType! == .checkmark {
                    indexPaths.append(row.indexPath)
                }
            }
        }
        
        return indexPaths
    }
    
    public func update(detail: String, at indexPath : IndexPath) {
        let row = rowAt(indexPath: indexPath)
        row.detail(detail)
    }
    
    
    fileprivate var sections = [StaticSection]()
    
    var autoEnableScroll = true
    
    var cellHeight: CGFloat?
    var separatorIndent: CGFloat?
    
    var accessoryType: CPKTableViewCellAccessoryType?
    var customHandler: ((StaticRow)->())?
    
    var onClickHandler: ((StaticRow)->())?
    
    var textFont: Any?
    var textColor: Any?
    var detailFont: Any?
    var detailColor: Any?
    
    public init(sectionsOrRows: [Any], style: UITableViewStyle_) {
        super.init(frame: CGRect.zero, style: style)
        self.estimatedRowHeight = 44
        self.estimatedSectionHeaderHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.delegate = self
        self.dataSource = self
        updateSections(sectionsOrRows: sectionsOrRows)
        
        addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            invalidateIntrinsicContentSize()
            
        }
        
        if self.autoEnableScroll {
            self.isScrollEnabled = !(abs(self.frame.size.height - visibleHeight()) < 0.1)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentSize")
        removeObserver(self, forKeyPath: "frame")
    }
    
    private func sectionsFrom(sectionsOrRows: [Any]) -> [StaticSection] {
        var sections = [StaticSection]()
        var rows: [StaticRow]? = nil
        
        for any in sectionsOrRows {
            
            if let array = any as? Array<Any> {
                let result = sectionsFrom(sectionsOrRows: array)
                sections.append(contentsOf: result)
                
            } else if let section = any as? StaticSection {
                if rows != nil {
                    sections.append(StaticSection(rowsOrStrings: rows!))
                    rows = nil
                }
                sections.append(section)
                
            } else if let row = any as? StaticRow {
                if rows == nil { rows = [StaticRow]() }
                rows?.append(row)
                
            } else if let text = any as? String {
                if rows == nil { rows = [StaticRow]() }
                rows?.append(Row.str(text))
            }
        }
        
        if rows != nil {
            sections.append(StaticSection(rowsOrStrings: rows!))
        }
        
        return sections
    }
    
    private func updateSections(sectionsOrRows: [Any]) {
        self.sections = sectionsFrom(sectionsOrRows: sectionsOrRows)
        
        for s in self.sections {
            s.table = self
        }
        
        //        if self.style == .grouped && sections.count == 1 {
        //            let section = sections.first
        //            if section?.headerValue == nil && section?.footerValue == nil {
        //                section?.header(0).footer(0)
        //            }
        //        }
    }
    
    private func visibleHeight() -> CGFloat {
        return contentSize.height + contentInset.top + contentInset.bottom
    }
    
    private func rowAt(indexPath: IndexPath) -> StaticRow {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = rowAt(indexPath: indexPath)
        return row.rowHeight()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowAt(indexPath: indexPath)
        let cell = row.getCell(indexPath: indexPath)
        
        if let callback = row.customHandler {
            callback(row)
        }
        
        if let callback = row.section.table.customHandler {
            callback(row)
        }
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return sections[sectionIndex].rows.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection sectionIndex: Int) -> CGFloat {
        let section = sections[sectionIndex]
        
        if let view = section.headerValue as? UIView {
            return view.bounds.height
            
        } else if let height = CPKFloatOptional(section.headerValue) {
            return height == 0 ? 0.001 : height
        }
        
        return UITableViewAutomaticDimension_
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection sectionIndex: Int) -> CGFloat {
        let section = sections[sectionIndex]
        
        if let view = section.footerValue as? UIView {
            return view.bounds.height
            
        } else if let height = CPKFloatOptional(section.footerValue) {
            return height == 0 ? 0.001 : height
        }
        
        return UITableViewAutomaticDimension_
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
        let section = sections[sectionIndex]
        
        if let title = section.headerValue as? String {
            return title
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection sectionIndex: Int) -> String? {
        let section = sections[sectionIndex]
        
        if let footer = section.footerValue as? String {
            return footer
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection sectionIndex: Int) -> UIView? {
        let section = sections[sectionIndex]
        
        if let view = section.headerValue as? UIView {
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection sectionIndex: Int) -> UIView? {
        let section = sections[sectionIndex]
        
        if let view = section.footerValue as? UIView {
            return view
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let row = rowAt(indexPath: indexPath)
        return row.allowSelection() ? indexPath : nil
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let row = rowAt(indexPath: indexPath)
        return row.allowSelection()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        let row = rowAt(indexPath: indexPath)
        
        if section.enableSingleCheck != nil {
            for r in section.rows { r.check(false) }
            row.check(true)
            
        } else if section.enableMultiCheck != nil {
            if row.accessoryType != nil && row.accessoryType! == .checkmark {
                row.check(false)
            } else {
                row.check(true)
            }
        }
        
        if let callback = row.onClickHandler {
            callback(row)
        }
        
        if let callback = section.table.onClickHandler {
            callback(row)
        }
    }
    
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let row = rowAt(indexPath: indexPath)
        if let callback = row.onButtonHandler {
            callback(row)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: -1, height: visibleHeight())
    }
}

public class StaticSection: NSObject {
    fileprivate var rows = [StaticRow]()
    fileprivate weak var table: StaticTableView!
    
    var enableSingleCheck: Bool?
    var enableMultiCheck: Bool?
    
    var checkedImage: UIImage?
    var uncheckedImage: UIImage?
    
    var headerValue: Any?
    var footerValue: Any?
    
    
    fileprivate func allowChecking() -> Bool {
        return enableSingleCheck != nil || enableMultiCheck != nil
    }
    
    private func rowsFrom(rowsOrStrings: [Any]) -> [StaticRow] {
        var rows = [StaticRow]()
        
        for any in rowsOrStrings {
            if let row = any as? StaticRow {
                rows.append(row)
            }
            
            if let text = any as? String {
                rows.append(Row.str(text))
            }
            
            if let array = any as? Array<Any> {
                let result = rowsFrom(rowsOrStrings: array)
                rows.append(contentsOf: result)
            }
        }
        
        return rows
    }
    
    
    init(rowsOrStrings: [Any]) {
        super.init()
        self.rows = rowsFrom(rowsOrStrings: rowsOrStrings)
        for row in self.rows {
            row.section = self
        }
    }
}


public class StaticRow: UIView {
    public fileprivate(set) var cell: UITableViewCell!
    public fileprivate(set) var indexPath: IndexPath!
    public internal(set) var switchView: UISwitch! {
        didSet {
            switchView?.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        }
    }
    
    fileprivate weak var section: StaticSection!
    
    var cellHeight: CGFloat?
    var separatorIndent: CGFloat?
    
    var cellStyle: UITableViewCellStyle_ = .default
    
    var onClickHandler: ((StaticRow)->())?
    var onButtonHandler: ((StaticRow)->())?
    var onChangeHandler: ((StaticRow)->())?
    var customHandler: ((StaticRow)->())?
    
    var accessoryType: CPKTableViewCellAccessoryType? {
        didSet {
            updateCell()
        }
    }
    
    var text: Any? {
        didSet { updateCell() }
    }
    
    var detailText: Any? {
        didSet { updateCell() }
    }
    
    var image: UIImage? {
        didSet { updateCell() }
    }
    
    public override class var layerClass: Swift.AnyClass {
        return CPKTransformLayer.self
    }
    
    @objc func switchDidChange() {
        if let callback = onChangeHandler {
            callback(self)
        }
    }
    
    private func updateCell() {
        
        if cell == nil {
            return
        }
        
        cell.imageView?.image = image
        cell.textLabel?.str(text)
        cell.detailTextLabel?.str(detailText)
            
        if text != nil && !(text is NSAttributedString) {
            if let font = self.section.table.textFont {
                cell.textLabel?.font(font)
            }
            
            if let color = self.section.table.textColor {
                cell.textLabel?.color(color)
            }
        }
        
        if detailText != nil && !(detailText is NSAttributedString) {
            if let font = self.section.table.detailFont {
                cell.detailTextLabel?.font(font)
            }
            if let color = self.section.table.detailColor {
                cell.detailTextLabel?.color(color)
            }
        }
        
        if let accType = self.accessoryType ?? self.section.table.accessoryType {
            let accs = accType.accessoryType()
            cell.accessoryType = accs.0
            
            if let view = accs.1 {
                cell.accessoryView = view
            }
        }
        
        if let section = self.section {
            if section.allowChecking() {
                let accType = self.accessoryType
                
                if accType != nil && accType! == .checkmark {
                    if let onImage = section.checkedImage {
                        self.cell.accessoryView = ImageView.img(onImage)
                    } else {
                        self.cell.accessoryType = .checkmark
                        self.cell.accessoryView = nil
                    }
                    
                } else {
                    if let offImage = section.uncheckedImage {
                        self.cell.accessoryView = ImageView.img(offImage)
                    } else {
                        self.cell.accessoryType = .none
                        self.cell.accessoryView = nil
                    }
                }
            }
        }
        
        if let indent = lineIndent() {
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsetsMake_(0, 0, 0, 0)
            cell.separatorInset = UIEdgeInsetsMake_(0, indent, 0, 0)
        }
    }
    
    fileprivate func rowHeight() -> CGFloat {
        var rowHeight: CGFloat = 44
        
        if let height = self.cellHeight {
            rowHeight = height
        } else if let height = self.section.table.cellHeight {
            rowHeight = height
        }
        
        return rowHeight >= 0 ? rowHeight : UITableViewAutomaticDimension_
    }
    
    fileprivate func lineIndent() -> CGFloat? {
        if self.separatorIndent != nil {
            return self.separatorIndent
        } else {
            return self.section.table.separatorIndent
        }
    }
    
    fileprivate func allowSelection() -> Bool {
        if section.allowChecking() {
            return true
        }
        
        if self.onClickHandler != nil {
            return true
        }
        
        if section.table.onClickHandler != nil {
            return true
        }
        
        return false
    }
    
    fileprivate func getCell(indexPath: IndexPath) -> UITableViewCell {
        if cell == nil {
            var style = self.cellStyle
            if style == .default && self.detailText != nil {
                style = .value1
            }
            
            cell = UITableViewCell(style: style, reuseIdentifier: "cell")
        }
        
        self.indexPath = indexPath
        updateCell()
        
        return cell
    }
}


extension CPKTableViewCellAccessoryType {
    public func accessoryType() -> (UITableViewCellAccessoryType_, UIView?) {
        switch self {
            case .none: return (.none, nil)
            case .disclosureIndicator: return (.disclosureIndicator, nil)
            case .detailDisclosureButton: return (.detailDisclosureButton, nil)
            case .checkmark: return (.checkmark, nil)
            case .detailButton: return (.detailButton, nil)
            case let .view(view): return (.none, view)
        }
    }
}

func == (lhs: CPKTableViewCellAccessoryType, rhs: CPKTableViewCellAccessoryType) -> Bool {
    switch (lhs, rhs) {
        case (.none, .none): return true
        case (.disclosureIndicator, .disclosureIndicator): return true
        case (.detailDisclosureButton, .detailDisclosureButton): return true
        case (.checkmark, .checkmark): return true
        case (.detailButton, .detailButton): return true
        case (.view(let l), .view(let r)): return l == r
        default: return false
    }
}















































//MARK: UITextView+Placeholder

fileprivate var cpkTextViewObservingKeys = ["bounds",
                                            "frame",
                                            "font",
                                            "textAlignment",
                                            "textContainerInset",
                                            "textContainer.lineFragmentpadding"]


fileprivate class UITextViewPlaceholder: UILabel {
    weak var textView: UITextView?
    static private var defaultColor: UIColor?
    
    func defaultPlaceholderColor() -> UIColor {
        if let color = UITextViewPlaceholder.defaultColor {
            return color
        } else {
            let textField = UITextField()
            textField.placeholder = " "
            
            var color = textField.value(forKeyPath: "_placeholderLabel.textColor") as? UIColor
            if color == nil {
                color = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
            }
            
            UITextViewPlaceholder.defaultColor = color
            return color!
        }
    }
    
    init(textView: UITextView) {
        self.textView = textView
        super.init(frame: textView.bounds)
        
        self.numberOfLines = 0
        self.tag = 31415
        self.textColor = defaultPlaceholderColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func update() {
        if let textView = self.textView {
            self.isHidden = !(textView.text.isEmpty && textView.attributedText.string.isEmpty)
            
            if !self.isHidden {
                var font = textView.font
                
                if font == nil && textView.text.isEmpty {
                    textView.text = " "
                    font = textView.font
                    textView.text = ""
                }
                
                self.font = font
                self.textAlignment = textView.textAlignment
                
                var rect = UIEdgeInsetsInsetRect_(textView.bounds, textView.textContainerInset)
                rect = rect.insetBy(dx: textView.textContainer.lineFragmentPadding, dy: 0)
                rect.size.height = min(rect.height, self.sizeThatFits(CGSize(width: rect.width, height: 0)).height)
                self.frame = rect
            }
        }
    }
    
    fileprivate override func observeValue(forKeyPath keyPath: String?,
                                           of object: Any?,
                                           change: [NSKeyValueChangeKey : Any]?,
                                           context: UnsafeMutableRawPointer?) {
        update()
    }
}


extension UITextView {
    var cpkMaxLength: Int {
        get { return cpk_associatedObjectFor(key: #function) as? Int ?? 0 }
        set { cpk_setAssociated(object: newValue, forKey: #function); cpk_watchTextChange() }
    }
    
    var cpkTextChangedClosure: Any? {
        get { return cpk_associatedObjectFor(key: #function) }
        set { cpk_setAssociated(object: newValue, forKey: #function); cpk_watchTextChange() }
    }
    
    fileprivate var cpkPlaceholderLabel: UITextViewPlaceholder? {
        return self.viewWithTag(31415) as? UITextViewPlaceholder
    }
    
    @objc public func cpk_deinit() {
        if let label = self.cpkPlaceholderLabel {
            for keyPath in cpkTextViewObservingKeys {
                self.removeObserver(label, forKeyPath: keyPath)
            }
        }
        
        NotificationCenter.default.removeObserver(self)
        self.cpk_deinit()
    }
    
    private func cpk_watchTextChange() {
        #if swift(>=4.2)
        let name = UITextView.textDidChangeNotification
        #else
        let name = NSNotification.Name.UITextViewTextDidChange
        #endif
        
        NotificationCenter.default.removeObserver(self, name: name, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(cpk_textDidChange), name: name, object: self)
    }
    
    @objc func cpk_textDidChange() {
        let hasMarked = cpk_limitTextInput(self, maxLength: self.cpkMaxLength)
        if !hasMarked {
            if let closure = self.cpkTextChangedClosure as? (UITextView)->() {
                closure(self)
            }
        }
        
        self.cpkPlaceholderLabel?.update()
    }
    
    func cpk_setPlaceholder(_ any: Any?) {
        var placeholderLabel = self.cpkPlaceholderLabel
        
        if placeholderLabel == nil {
            let label = UITextViewPlaceholder(textView: self)
            self.insertSubview(label, at: 0)
            
            for keyPath in cpkTextViewObservingKeys {
                self.addObserver(label, forKeyPath: keyPath, options: .new, context: nil)
            }
            
            placeholderLabel = label
            cpk_watchTextChange()
        }
        
        if let att = any as? NSAttributedString {
            placeholderLabel?.attributedText = att
        } else if let any = any {
            placeholderLabel?.text = String(describing: any)
        } else {
            placeholderLabel?.text = nil
        }
        
        placeholderLabel?.update()
    }
}

























































//MARK: UILabel + Link

class LinkInfo: NSObject {
    var text: String
    var range: NSRange
    var boundingRects: [CGRect]
    
    init(text: String, range: NSRange, boundingRects: [CGRect]) {
        self.text = text
        self.range = range
        self.boundingRects = boundingRects
    }
    
    func contains(point: CGPoint) -> Bool {
        for rect in boundingRects {
            if rect.contains(point) {
                return true
            }
        }
        return false
    }
    
    func shouldCancelTouchAt(point: CGPoint) -> Bool {
        for rect in boundingRects {
            let touchRect = rect.insetBy(dx: -50, dy: -50)
            if touchRect.contains(point) {
                return false
            }
        }
        return true
    }
}

class LinkGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .cancelled
    }
    
    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


public extension UILabel {
    
    var cpkLayoutManager: NSLayoutManager {
        var layoutManager: NSLayoutManager! = cpk_associatedObjectFor(key: #function) as? NSLayoutManager
        
        if layoutManager == nil {
            layoutManager = NSLayoutManager()
            
            let textStorage = NSTextStorage()
            textStorage.addLayoutManager(layoutManager)
            layoutManager?.textStorage = textStorage
            
            let textContainer = NSTextContainer(size: CGSize(width: 0, height: 0))
            textContainer.lineFragmentPadding = 0
            textContainer.layoutManager = layoutManager
            layoutManager.addTextContainer(textContainer)
            
            cpk_setAssociated(object: layoutManager, forKey: #function)
            cpk_setAssociated(object: textStorage, forKey: "cpkTextStorage")
        }
        
        if let attStr = self.attributedText {
            let att = NSMutableAttributedString(attributedString: attStr)
            att.select(.all).preventOverride().font(self.font!).align(self.textAlignment)
            
            if self.numberOfLines != 1 && self.lineBreakMode != .byCharWrapping && self.lineBreakMode != .byWordWrapping {
                let value = NSNumber(value: NSLineBreakMode.byWordWrapping.rawValue)
                att.cpk_addParagraphAttribute(key: "lineBreakMode", value: value)
            }
            
            layoutManager.textStorage?.setAttributedString(att)
            
            if let textContainer = layoutManager.textContainers.first {
                textContainer.maximumNumberOfLines = self.numberOfLines
                textContainer.lineBreakMode = self.lineBreakMode
                textContainer.size = self.bounds.size
            }
            
        } else {
            layoutManager.textStorage?.setAttributedString(NSAttributedString())
        }
        
        return layoutManager
    }
    
    var cpkLinkSelectionColor: UIColor? {
        get { return cpk_associatedObjectFor(key: #function) as? UIColor }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    var cpkLinkSelectionRadius: CGFloat? {
        get { return cpk_associatedObjectFor(key: #function) as? CGFloat }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
}


extension UILabel {
    
    var cpkLineGap: CGFloat? {
        get { return cpk_associatedObjectFor(key: #function) as? CGFloat }
        set { cpk_setAssociated(object: newValue, forKey: #function); cpk_updateAttributedString() }
    }
    
    var cpkLinkHandler: Any? {
        get { return cpk_associatedObjectFor(key: #function) }
        set {
            cpk_setAssociated(object: newValue, forKey: #function)
            
            guard let hasGesture = self.gestureRecognizers?.contains(where: {
                return $0 is LinkGestureRecognizer
            }), hasGesture == true else {
                let gesture = LinkGestureRecognizer(target: self, action: #selector(cpk_handleLinkGesture(_:)))
                addGestureRecognizer(gesture)
                return
            }
        }
    }
    
    fileprivate var cpkSelectedLinkInfo: LinkInfo? {
        get { return cpk_associatedObjectFor(key: #function) as? LinkInfo }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    fileprivate var cpkSelectionLayers: [CALayer] {
        get { return (cpk_associatedObjectFor(key: #function) as? [CALayer]) ?? [CALayer]() }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
    
    @objc public func ner_setText(_ text: String) {
        self.ner_setText(text)
        cpk_updateAttributedString()
    }
    
    private func cpk_updateAttributedString() {
        if let lineGap = self.cpkLineGap, let attStr = self.attributedText {
            if let mutableAtt = attStr.mutableCopy() as? NSMutableAttributedString {
                self.attributedText = mutableAtt.lineGap(lineGap)
            }
        }
    }
}


extension UILabel {
    
    @objc func cpk_handleLinkGesture(_ gesture: LinkGestureRecognizer) {
        
        func cpk_calculateTextYOffset() -> CGFloat {
            let layoutManager = self.cpkLayoutManager
            
            if let textContainer = layoutManager.textContainers.first {
                let textRange = layoutManager.glyphRange(for: textContainer)
                let textRect = layoutManager.boundingRect(forGlyphRange: textRange, in: textContainer)
                
                if self.bounds.height > textRect.height {
                    return (self.bounds.height - textRect.height) / 2
                }
            }
            
            return 0
        }
        
        func cpk_calculateBoundingRects(range: NSRange, yOffset: CGFloat) -> [CGRect] {
            let layoutManager = self.cpkLayoutManager
            var boundingRects = [CGRect]()
            
            if let textContainer = layoutManager.textContainers.first {
                let textRect = layoutManager.usedRect(for: textContainer)
                let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                
                let handler: (CGRect, UnsafeMutablePointer<ObjCBool>)->() = { (rect, stop) in
                    var boundingRect = rect
                    let subGlyphRange = layoutManager.glyphRange(forBoundingRect: rect, in: textContainer)
                    let subRect = layoutManager.boundingRect(forGlyphRange: subGlyphRange, in: textContainer)
                    
                    let lineRect = layoutManager.lineFragmentUsedRect(forGlyphAt: subGlyphRange.location, effectiveRange: nil)
                    
                    if subRect.origin.x > boundingRect.origin.x {
                        let emptyWidth = subRect.origin.x - boundingRect.origin.x
                        
                        boundingRect.origin.x = subRect.origin.x
                        if boundingRect.size.width > emptyWidth {
                            boundingRect.size.width -= emptyWidth
                        }
                    }
                    
                    if let ps = layoutManager.textStorage?.attribute("NSParagraphStyle",
                                                                     at: range.location,
                                                                     longestEffectiveRange: nil,
                                                                     in: range) as? NSParagraphStyle {
                        
                        if ps.lineSpacing > 0 && ceilf(Float(boundingRect.maxY)) != ceilf(Float(textRect.maxY)) {
                            let height = boundingRect.height - ps.lineSpacing
                            boundingRect.size.height = CGFloat(ceilf(Float(height)))
                        }
                    }
                    
                    if boundingRect.maxX > lineRect.maxX {
                        boundingRect.size.width = lineRect.maxX - boundingRect.minX
                    }
                    
                    boundingRect.origin.y += yOffset
                    boundingRects.append(boundingRect)
                }
                
                layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange,
                                                      withinSelectedGlyphRange: NSMakeRange(NSNotFound, 0),
                                                      in: textContainer,
                                                      using:handler)
            }
            
            return boundingRects
        }
        
        func cpk_handleTouchBegin() {
            
            if let attStr = self.attributedText {
                var linkInfos = [LinkInfo]()
                let touchPoint = gesture.location(in: self)
                let fullRange = NSMakeRange(0, attStr.length)
                let yOffset = cpk_calculateTextYOffset()
                
                let handler: (Any?, NSRange, UnsafeMutablePointer<ObjCBool>)->() = { (value, range, stop) in
                    if value != nil {
                        let text = attStr.string.subAt(range)
                        let boundingRects = cpk_calculateBoundingRects(range: range, yOffset: yOffset)
                        let linkInfo = LinkInfo(text: text, range: range, boundingRects: boundingRects)
                        linkInfos.append(linkInfo)
                    }
                }
                
                attStr.enumerateAttribute("CPKLabelLink",
                                          in: fullRange,
                                          options: NSAttributedString.EnumerationOptions.init(rawValue: 0),
                                          using: handler)
                
                for linkInfo in linkInfos {
                    if linkInfo.contains(point: touchPoint) {
                        self.cpkSelectedLinkInfo = linkInfo
                        self.perform(#selector(cpk_addHighlightedLayers(for:)), with: linkInfo, afterDelay: 0.06)
                        break
                    }
                }
            }
        }
        
        if gesture.state == .began {
            cpk_handleTouchBegin()
            
        } else if gesture.state == .changed {
            if let linkInfo = self.cpkSelectedLinkInfo {
                let point = gesture.location(in: self)
                if linkInfo.shouldCancelTouchAt(point: point) {
                    cpk_removeHighlightedLayers()
                }
            }
            
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if let linkInfo = self.cpkSelectedLinkInfo {
                let callback = self.cpkLinkHandler
                cpk_removeHighlightedLayers()
                
                if let closure = callback as? (String)->() {
                    closure(linkInfo.text)
                } else if let closure = callback as? (String, NSRange)->() {
                    closure(linkInfo.text, linkInfo.range)
                } else if let closure = callback as? (Any)->() {
                    closure(linkInfo.text)
                }
            }
        }
    }
    
    @objc func cpk_addHighlightedLayers(for linkInfo: LinkInfo) {
        for rect in linkInfo.boundingRects {
            if rect.size.width > 0 && rect.size.height > 0 {
                var color = self.cpkLinkSelectionColor ?? UIColor.darkGray
                let radius = self.cpkLinkSelectionRadius ?? 4
                
                if color.cgColor.alpha == 1 {
                    color = color.withAlphaComponent(0.4)
                }
                
                let layer = CALayer()
                layer.frame = rect
                layer.cornerRadius = radius
                layer.backgroundColor = color.cgColor
                
                self.layer.addSublayer(layer)
                self.cpkSelectionLayers.append(layer)
            }
        }
    }
    
    func cpk_removeHighlightedLayers() {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(cpk_addHighlightedLayers(for:)),
                                               object: self.cpkSelectedLinkInfo)
        
        for layer in self.cpkSelectionLayers {
            layer.removeFromSuperlayer()
        }
        
        self.cpkSelectionLayers.removeAll()
        self.cpkSelectedLinkInfo = nil
    }
}



extension UIBarButtonItem {
    func cpk_onClick(closure: @escaping (UIBarButtonItem)->Void) {
        target = self
        action = #selector(cpk_onClickHandler)
        cpk_setAssociated(object: closure, forKey: "cpk_OnClick")
    }
    
    func cpk_onTap(closure: @escaping ()->Void) {
        target = self
        action = #selector(cpk_onTapHandler)
        cpk_setAssociated(object: closure, forKey: "cpk_OnTap")
    }

    @objc func cpk_onClickHandler() {
        if let callback = cpk_associatedObjectFor(key: "cpk_OnClick") as? (UIBarButtonItem)->Void {
            callback(self)
        }
    }
    
    @objc func cpk_onTapHandler() {
        if let callback = cpk_associatedObjectFor(key: "cpk_OnTap") as? ()->Void {
            callback()
        }
    }
}






















































//MARK: Override

extension UILabel {
    
    @discardableResult
    override public func bg(_ any: Any) -> Self {
        super.bg(any)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func onClick(_ closure: @escaping (UILabel)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    @discardableResult
    override public func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        super.styles(s1, s2, s3, s4)
        return self
    }
    
    @discardableResult
    override public func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.touchInsets(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}



extension UIImageView {
    
    @discardableResult
    override public func bg(_ any: Any) -> Self {
        super.bg(any)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func onClick(_ closure: @escaping (UIImageView)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    @discardableResult
    override public func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        super.styles(s1, s2, s3, s4)
        return self
    }
    
    @discardableResult
    override public func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.touchInsets(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}



extension UIButton {
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func onClick(_ closure: @escaping (UIButton)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    @discardableResult
    override public func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        super.styles(s1, s2, s3, s4)
        return self
    }
    
    @discardableResult
    override public func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.touchInsets(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}



extension UITextField {
    
    @discardableResult
    override public func bg(_ any: Any) -> Self {
        super.bg(any)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func onClick(_ closure: @escaping (UITextField)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    @discardableResult
    override public func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        super.styles(s1, s2, s3, s4)
        return self
    }
    
    @discardableResult
    override public func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.touchInsets(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}



extension UITextView {
    
    @discardableResult
    override public func bg(_ any: Any) -> Self {
        super.bg(any)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func onClick(_ closure: @escaping (UITextView)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    @discardableResult
    override public func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        super.styles(s1, s2, s3, s4)
        return self
    }
    
    @discardableResult
    override public func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.touchInsets(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}



extension CPKStackView {
    
    @discardableResult
    override public func bg(_ any: Any) -> Self {
        super.bg(any)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func onClick(_ closure: @escaping (CPKStackView)->()) -> Self {
        cpk_onClick(closure, nil)
        return self
    }
    
    @discardableResult
    override public func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func styles(_ s1: Any, _ s2: Any? = nil, _ s3: Any? = nil, _ s4: Any? = nil) -> Self {
        super.styles(s1, s2, s3, s4)
        return self
    }
    
    @discardableResult
    override public func touchInsets(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.touchInsets(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}


extension StaticTableView {
    @discardableResult
    override public func bg(_ any: Any) -> Self {
        super.bg(any)
        return self
    }
    
    @discardableResult
    override public func tint(_ any: Any) -> Self {
        super.tint(any)
        return self
    }
    
    @discardableResult
    override public func radius(_ cornerRadius: CGFloat) -> Self {
        super.radius(cornerRadius)
        return self
    }
    
    @discardableResult
    override public func border(_ borderWidth: CGFloat, _ borderColor: Any? = nil) -> Self {
        super.border(borderWidth, borderColor)
        return self
    }
    
    @discardableResult
    override public func shadow(_ shadowOpacity: CGFloat,
                                _ shadowRadius: CGFloat = 3,
                                _ shadowOffsetX: CGFloat = 0,
                                _ shadowOffsetY: CGFloat = 3,
                                _ shadowColor: Any? = nil) -> Self {
        
        super.shadow(shadowOpacity, shadowRadius, shadowOffsetX, shadowOffsetY)
        return self
    }
    
    @discardableResult
    override public func addTo(_ superView: UIView) -> Self {
        super.addTo(superView)
        return self
    }
    
    @discardableResult
    override public func margin(_ p1: Any, _ p2: Any? = nil, _ p3: Any? = nil, _ p4: Any? = nil) -> Self {
        super.margin(p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func embedIn(_ superview: UIView,
                                 _ p1: Any? = "", _ p2: Any? = "",
                                 _ p3: Any? = "", _ p4: Any? = "") -> Self {
        super.embedIn(superview, p1, p2, p3, p4)
        return self
    }
    
    @discardableResult
    override public func makeCons(_ closure: (ConsMaker)->()) -> Self {
        super.makeCons(closure)
        return self
    }
    
    @discardableResult
    override public func remakeCons(_ closure: (ConsMaker)->()) -> Self {
        super.remakeCons(closure)
        return self
    }
}













