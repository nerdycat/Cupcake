//
//  Constraint.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/22.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * A SnapKit like syntax to setup constraints.
 
 * Usages:
    view1.makeCons({ make in
        make.left.top.equal(view2).offset(20, 20)
        make.width.height.equal(100, 100)
    })
 
    view1.remakeCons({
        $0.left.equal(20)
        $0.top.euqal(view2).bottom.offset(20)
        $0.size.equal(view2).multiply(0.5)
    })
 */

public extension ConsAtts {
    
    public var left: Cons {
        return addAttributes(.left)
    }
    
    public var leftMargin: Cons {
        return addAttributes(.leftMargin)
    }
    
    public var right: Cons {
        return addAttributes(.right)
    }
    
    public var rightMargin: Cons {
        return addAttributes(.rightMargin)
    }
    
    public var top: Cons {
        return addAttributes(.top)
    }
    
    public var topMargin: Cons {
        return addAttributes(.topMargin)
    }
    
    public var bottom: Cons {
        return addAttributes(.bottom)
    }
    
    public var bottomMargin: Cons {
        return addAttributes(.bottomMargin)
    }
    
    public var leading: Cons {
        return addAttributes(.leading)
    }
    
    public var leadingMargin: Cons {
        return addAttributes(.leadingMargin)
    }
    
    public var trailing: Cons {
        return addAttributes(.trailing)
    }
    
    public var trailingMagin: Cons {
        return addAttributes(.trailingMargin)
    }
    
    public var width: Cons {
        return addAttributes(.width)
    }
    
    public var height: Cons {
        return addAttributes(.height)
    }
    
    public var centerX: Cons {
        return addAttributes(.centerX)
    }
    
    public var centerY: Cons {
        return addAttributes(.centerY)
    }
    
    public var centerXInMargins: Cons {
        return addAttributes(.centerXWithinMargins)
    }
    
    public var centerYInMargins: Cons {
        return addAttributes(.centerYWithinMargins)
    }
    
    public var baseline: Cons {
        return addAttributes(.lastBaseline)
    }
    
    public var firstBaseline: Cons {
        return addAttributes(.firstBaseline)
    }
    
    public var center: Cons {
        return addAttributes(.centerX, .centerY)
    }
    
    public var origin: Cons {
        return addAttributes(.left, .top)
    }
    
    public var size: Cons {
        return addAttributes(.width, .height)
    }
    
    public var edge: Cons {
        return addAttributes(.top, .left, .bottom, .right)
    }
}


public extension Cons {
    
    /**
     * equal relationship, can be UIView or values. This is the default relationship.
     * If you don't specify item2 (by using equal, lessEqual or greaterEqual),
       and the item1's attribute is not width and height, 
       then the item2 is automatically refer to item1's superview.
     
     * Usages:
        make.left.equal(superview)
        make.left.offset(0)         //same as above
        make.width.equal(100)
        make.size.equal(100, 200)
     */
    @discardableResult public func equal(_ item2OrValues: Any...) -> Self {
        self.relation = .equal
        updateSecondItem(item2OrValues)
        return self
    }
    
    /**
     * lessThanOrEqual relationship, can be UIView or values.
     * Usages:
        make.left.lessEqual(superview)
        make.width.lessEqual(100)
        make.size.lessEqual(100, 200)
     */
    @discardableResult public func lessEqual(_ item2OrValues: Any...) -> Self {
        self.relation = .lessThanOrEqual
        updateSecondItem(item2OrValues)
        return self
    }
    
    /**
     * greaterThanOrEqual relationship, can be UIView or values.
     * Usages:
        make.left.greaterEqual(superview)
        make.width.greaterEqual(100)
        make.size.greaterEqual(100, 200)
     */
    @discardableResult public func greaterEqual(_ item2OrValues: Any...) -> Self {
        self.relation = .greaterThanOrEqual
        updateSecondItem(item2OrValues)
        return self
    }
    
    /**
     * offset can accept multiply values.
     * Usages:
        make.left.offset(20)
        make.left.top.offset(20, 40)
        make.edge.offset(10, 20, 30, 40)
        ...
     */
    @discardableResult public func offset(_ offsets: CGFloat...) -> Self {
        self.constantValues = offsets
        return self
    }
    
    /**
     * multiply can accept multiply values.
     * Usages:
        make.width.equal(view2).multiply(0.5)
        make.size.equal(view2).multiply(0.5, 0.8)
        ...
     */
    @discardableResult public func multiply(_ multipliers: CGFloat...) -> Self {
        self.multiplierValues = multipliers
        return self
    }
    
    /**
     * priority can accept multiply values.
     * Usages:
        make.width.equal(100).priority(800)
        make.edge.offset(10).priority(1000, 1000, 900, 900)
        ...
     */
    @discardableResult public func priority(_ priorities: UILayoutPriority...) -> Self {
        self.priorityValues = priorities
        return self
    }
    
    /**
     * Save constraints to variables, it can accept multiply values.
     * Very useful when you need to alter constraint later.
     * Usages:
        var topConstriant = NSLayoutConstraint()
     
        View.bg("red").addTo(self.view).makeCons({
            $0.size.equal(100, 100)
            $0.center.offset(0).priority(900)
            $0.top.offset(0).saveTo(&topConstriant)
        })
        ...
        topConstraint.isActivate = false
     */
    @discardableResult public func saveTo(_ constraints: UnsafeMutablePointer<NSLayoutConstraint>...) -> Self {
        self.storePointers = constraints
        return self
    }
}


