//
//  Str.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * Create String from formatted string. 
 * Also can be use to convert any type to String.
 * Usages: 
    Str("1+1=%d", 2)        //"1+1=2"
    Str(1024)               //"1024"
    Str(3.14)               //"3.14"
    ...
 */
public func Str(_ any: Any, _ arguments: CVarArg...) -> String {
    let str = String(format: String(describing: any), arguments: Array(arguments))
    return str
}


public extension String {
    
    /**
     * Return substring from index or to some particular string.
     * Usages:
        "hello world".subFrom(6)        //"world"
        "hello world".subFrom(-5)       //"world"
        "hello world".subFrom("wo")     //"world"
     */
    @discardableResult func subFrom(_ indexOrSubstring: Any) -> String {
        if var index = indexOrSubstring as? Int {
            if index < 0 { index += self.cpk_length() }
            let from = self.index(self.startIndex, offsetBy: index)
            return self.cpk_substring(from: from)
            
        } else if let substr = indexOrSubstring as? String {
            if let range = self.range(of: substr) {
                return self.cpk_substring(from: range.lowerBound)
            }
        }
        
        return ""
    }
    
    
    /**
     * Return substring to index or to some particular string.
     * Usages:
        "hello world".subTo(5)          //"hello"
        "hello world".subTo(-6)         //"hello"
        "hello world".subTo(" ")        //"hello"
     */
    @discardableResult func subTo(_ indexOrSubstring: Any) -> String {
        if var index = indexOrSubstring as? Int {
            if index < 0 { index += self.cpk_length() }
            let to = self.index(self.startIndex, offsetBy: index)
            return self.cpk_substring(to: to)
            
        } else if let substr = indexOrSubstring as? String {
            if let range = self.range(of: substr) {
                return self.cpk_substring(to: range.lowerBound)
            }
        }
        
        return ""
    }
    
    
    /**
     * Return substring at index or in range.
     * Usages:
        "hello world".subAt(1)          //"e"
        "hello world".subAt(1..<4)      //"ell"
     */
    @discardableResult func subAt(_ indexOrRange: Any) -> String {
        if let index = indexOrRange as? Int {
            return String(self[self.index(self.startIndex, offsetBy: index)])
            
        } else if let range = indexOrRange as? Range<String.Index> {
            return self.cpk_substring(with: range)
            
        } else if let range = indexOrRange as? Range<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound)
            return self.cpk_substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? CountableRange<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound)
            return self.cpk_substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? ClosedRange<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound + 1)
            return self.cpk_substring(with: lower..<upper)
            
        } else if let range = indexOrRange as? CountableClosedRange<Int> {
            let lower = self.index(self.startIndex, offsetBy: range.lowerBound)
            let upper = self.index(self.startIndex, offsetBy: range.upperBound + 1)
            return self.cpk_substring(with: lower..<upper)
        
        } else if let range = indexOrRange as? NSRange {
            let lower = self.index(self.startIndex, offsetBy: range.location)
            let upper = self.index(self.startIndex, offsetBy: range.location + range.length)
            return self.cpk_substring(with: lower..<upper)
        }
        
        return ""
    }
    
    
    /**
     * Return substring that match the pattern.
     * Usages:
        "abc123".subMatch("\\d+")       //"123"
     */
    @discardableResult func subMatch(_ pattern: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            let matchRange = exp.rangeOfFirstMatch(in: self,
                                                   options:options,
                                                   range: NSMakeRange(0, self.cpk_length()))
            
            if matchRange.location != NSNotFound {
                return self.subAt(matchRange)
            }
        }
        
        return ""
    }
    
    
    /**
     * Replace substring with template.
     * Usages:
        "abc123".subReplace("abc", "ABC")               //ABC123
        "abc123".subReplace("([a-z]+)(\\d+)", "$2$1")   //"123abc"
     */
    @discardableResult func subReplace(_ pattern: String, _ template: String) -> String {
        let options = NSRegularExpression.Options(rawValue: 0)
        
        if let exp = try? NSRegularExpression(pattern: pattern, options: options) {
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            
            return exp.stringByReplacingMatches(in: self,
                                                options: options,
                                                range: NSMakeRange(0, self.cpk_length()),
                                                withTemplate: template)
        }
        
        return ""
    }
}

