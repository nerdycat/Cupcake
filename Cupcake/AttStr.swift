//
//  AttStr.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * Create NSMutableAttributedString with String or UIImage.
 * Usages:
    AttStr("hello world").select("world").color("red")
    AttStr("A big smile ", Img("smile"), " !!")         //insert image attachment
 */
public func AttStr(_ objects: Any?...) -> NSMutableAttributedString {
    let result = NSMutableAttributedString()
    
    for object in objects {
        var subAtt: NSAttributedString? = nil
        
        if object is NSAttributedString {
            subAtt = object as? NSAttributedString
            
        } else if object is String {
            subAtt = NSAttributedString(string: object as! String)
            
        } else if object is UIImage {
            let attachment = NSTextAttachment()
            attachment.image = object as? UIImage
            subAtt = NSAttributedString(attachment: attachment)
        }
        
        if subAtt != nil {
            result.append(subAtt!)
        }
    }
    
    result.cpk_select(range: NSMakeRange(0, result.length), setFlag: false)
    return result
}


public extension NSMutableAttributedString {
    
    /**
     * NSFontAttributeName
     * font use Font() internally, so it can take any kind of values that Font() supported.
     * See Font.siwft for more information.
     * Usages: 
        .font(15)
        .font("20")
        .font("body")
        .font(someLabel.font)
        ...
     */
    @discardableResult func font(_ style: Any) -> Self {
        cpk_addAttribute(name: "NSFont", value: Font(style))
        return self
    }
    
    /**
     * NSForegroundColorAttributeName
     * color use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages: 
        .color(@"red")
        .color(@"#F00")
        .color(@"255,0,0")
        .color(someView.backgroundColor)
        ...
     */
    @discardableResult func color(_ any: Any) -> Self {
        cpk_addAttribute(name: "NSColor", value: Color(any)!)
        return self
    }
    
    /**
     * NSBackgroundColorAttributeName
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
    @discardableResult func bg(_ any: Any) -> Self {
        cpk_addAttribute(name: "NSBackgroundColor", value: Color(any) ?? Color(Img(any))!)
        return self
    }
    
    /**
     * NSUnderlineStyleAttributeName, NSUnderlineColorAttributeName
     * underline's second argument use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages: 
        .underline()                        //single underline with the same color of text
        .underline(.patternDash)            //dash underline with the same color of text
        .underline("red")                   //single underline with red color
        .underline(.styleDouble, "red")     //double underline with red color
        ...
     */
    #if swift(>=4.2)
    @discardableResult func underline(_ style: NSUnderlineStyle = .single, _ color: Any? = nil) -> Self {
        var styles = NSNumber(value: style.rawValue)
        let lineStyle: NSUnderlineStyle = [.single, .thick, .double]
        if style.rawValue != 0 && (style.rawValue & lineStyle.rawValue == 0) {
            styles = NSNumber(value: style.rawValue | NSUnderlineStyle.single.rawValue)
        }
        
        cpk_addAttribute(name: "NSUnderline", value: styles)
        if let underlineColor = Color(color) { cpk_addAttribute(name: "NSUnderlineColor", value: underlineColor) }
        return self
    }
    #else
    @discardableResult public func underline(_ style: NSUnderlineStyle = .styleSingle, _ color: Any? = nil) -> Self {
        var styles = NSNumber(value: style.rawValue)
        if style != .styleNone && style != .styleSingle && style != .styleThick && style != .styleDouble {
        styles = NSNumber(value: style.rawValue | NSUnderlineStyle.styleSingle.rawValue)
    }
    
    cpk_addAttribute(name: "NSUnderline", value: styles)
        if let underlineColor = Color(color) { cpk_addAttribute(name: "NSUnderlineColor", value: underlineColor) }
        return self
    }
    #endif
    
    @discardableResult func underline(_ color: Any) -> Self {
        #if swift(>=4.2)
        return underline(.single, color)
        #else
        return underline(.styleSingle, color)
        #endif
    }
    
    /**
     * NSStrikethroughStyleAttributeName, NSStrikethroughColorAttributeName
     * strikethrough's second argument use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .strikethrough()                       //single strikethrough with the same color of text
        .strikethrough(.patternDash)           //dash strikethrough with the same color of text
        .strikethrough("red")                  //single strikethrough with red color
        .strikethrough(.styleDouble, "red")    //double strikethrough with red color
        ...
     */
    #if swift(>=4.2)
    @discardableResult func strikethrough(_ style: NSUnderlineStyle = .single, _ color: Any? = nil) -> Self {
        var styles = NSNumber(value: style.rawValue)
        let lineStyle: NSUnderlineStyle = [.single, .thick, .double]
        if style.rawValue != 0 && (style.rawValue & lineStyle.rawValue == 0) {
            styles = NSNumber(value: style.rawValue | NSUnderlineStyle.single.rawValue)
        }
        
        cpk_addAttribute(name: "NSStrikethrough", value: styles)
        if let strikethroughColor = Color(color) {
            cpk_addAttribute(name: "NSStrikethroughColor", value: strikethroughColor)
        }
        return self
    }
    #else
    @discardableResult public func strikethrough(_ style: NSUnderlineStyle = .styleSingle, _ color: Any? = nil) -> Self {
        var styles = NSNumber(value: style.rawValue)
        if style != .styleNone && style != .styleSingle && style != .styleThick && style != .styleDouble {
        styles = NSNumber(value: style.rawValue | NSUnderlineStyle.styleSingle.rawValue)
        }
    
        cpk_addAttribute(name: "NSStrikethrough", value: styles)
        if let strikethroughColor = Color(color) {
        cpk_addAttribute(name: "NSStrikethroughColor", value: strikethroughColor)
        }
        return self
    }
    #endif
    
    @discardableResult func strikethrough(_ color: Any) -> Self {
        #if swift(>=4.2)
        return strikethrough(.single, color)
        #else
        return strikethrough(.styleSingle, color)
        #endif
    }
    
    /**
     * NSStrokeWidthAttributeName, NSStrokeColorAttributeName
     * stroke's second argument use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .stroke(1)
        .stroke(-4, "red")
     */
    @discardableResult func stroke(_ width: CGFloat, _ color: Any? = nil) -> Self {
        cpk_addAttribute(name: "NSStrokeWidth", value: width)
        if let strokeColor = Color(color) {
            cpk_addAttribute(name: "NSStrokeColor", value: strokeColor)
        }
        return self
    }
    
    /**
     * NSObliquenessAttributeName
     * Usages:
        .oblique(0.3)
        .oblique(-0.3)
     */
    @discardableResult func oblique(_ value: CGFloat) -> Self {
        cpk_addAttribute(name: "NSObliqueness", value: value)
        return self
    }
    
    /**
     * NSBaselineOffsetAttributeName
     * Usages:
        .offset(20)
        .offset(-20)
     */
    @discardableResult func offset(_ offset: CGFloat) -> Self {
        cpk_addAttribute(name: "NSBaselineOffset", value: offset)
        return self
    }
    
    /**
     * NSLinkAttributeName
     * Also can be used to add clickable link for UILabel.
     * Usages:
        .link("http://www.google.com")
        .link()     //mark as link for UILabel
     */
    @discardableResult func link(_ url: String? = nil) -> Self {
        if let urlString = url {
            cpk_addAttribute(name: "NSLink", value: urlString)
        } else {
            cpk_addAttribute(name: CPKLabelLinkAttributeName, value: CPKLabelLinkAttributeValue)
        }
        return self
    }
    
    /**
     * Line spacing
     * Usages:
        .lineGap(10)
     */
    @discardableResult func lineGap(_ spacing: CGFloat) -> Self {
        cpk_addParagraphAttribute(key: "lineSpacing", value: spacing)
        return self
    }
    
    /**
     * First line head indent
     * Usages:
        .indent(20)
     */
    @discardableResult func indent(_ headIntent: CGFloat) -> Self {
        cpk_addParagraphAttribute(key: "firstLineHeadIndent", value: headIntent)
        return self
    }
    
    /**
     * TextAlignment
     * Usages:
        .align(.center)
        .align(.justified)
        ...
     */
    @discardableResult func align(_ alignment: NSTextAlignment) -> Self {
        cpk_addParagraphAttribute(key: "alignment", value: NSNumber(value: alignment.rawValue))
        return self
    }
    
    /**
     * Select substrings
     * By default Attributes are applied to the whole string. 
       You can make them only affect some parts of them by selecting substrings with regular expression or range.
     
     * You can pass multiply options at the same time.
     * See AttStrSelectionOptions for more information.
     
     * Usages:
        AttStr("hello world").select("world").color("red")                  //only "world" are red
        AttStr("abc123").select("[a-z]+").color("red")                      //only "abc" are red
        AttStr("abc123").select(.number).color("red")                       //only "123" are red
        AttStr("@Tim at #Apple").select(.nameTag, .hashTag).color("red")    //@Tim" and "#Apple" are red
        AttStr("@Tim at #apple").select(.range(5, 2)).color("red")          //only "@at" are red
        ...
     
     * .select("pattern") is just the shorthand of .select(.match("pattern"))
     */
    @discardableResult func select(_ optionOrStringLiterals: AttStrSelectionOptions...) -> Self {
        
        for option in optionOrStringLiterals {
            var regExp: NSRegularExpression?
            var patternString: String?
            var selectedRange = false
            
            switch option {
                case .all:
                    cpk_select(range: NSMakeRange(0, self.length))
                
                case .url:
                    regExp = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                
                case .date:
                    regExp = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
                
                case .phoneNumber:
                    regExp = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                
                case .hashTag:
                    patternString = "(?<!\\w)#([\\w\\_]+)?"
                
                case .nameTag:
                    patternString = "(?<!\\w)@([\\w\\_]+)?"
                
                case .number:
                    patternString = "\\d+(\\.\\d+)?"
                
                case let .match(value):
                    if let regExpObject = value as? NSRegularExpression {
                        regExp = regExpObject
                    } else {
                        patternString = String(describing: value)
                    }
                
                case let .range(location, length):
                    cpk_select(range: NSMakeRange(location >= 0 ? location : self.length + location, length))
                    return self
            }
            
            if patternString != nil {
                regExp = try? NSRegularExpression(pattern: patternString!,
                                                  options: NSRegularExpression.Options(rawValue: 0))
            }
            
            if regExp != nil {
                let matches = regExp!.matches(in: self.string,
                                              options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                              range: NSMakeRange(0, self.length))
                
                for result in matches {
                    cpk_select(range: result.range)
                    selectedRange = true
                }
            }
            
            if !selectedRange {
                cpk_select(range: nil)
            }
        }
        
        return self
    }
    
    /**
     * Prevent overriding attribute.
     * By default, the attribute value applied later will override the previous one if they are the same attributes.
     * Usages:
        AttStr(@"hello").color(@"red").color(@"green")                  //green color
        AttStr(@"hello").color(@"red").preventOverride.color(@"green")  //red color
     */
    @discardableResult func preventOverride(_ flag: Bool = true) -> Self {
        self.cpkPreventOverrideAttribute = flag
        return self
    }
}


public enum AttStrSelectionOptions {
    case all                //select whole string
    case url                //select all urls
    case date               //select all dates
    case number             //select all numbers
    case phoneNumber        //select all phone numbers
    case hashTag            //select all hash tags
    case nameTag            //select all name tags
    
    case match(Any)         //select substrings with regExp pattern or regExp Object
    case range(Int, Int)    //select substring with range
}



