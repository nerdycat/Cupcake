//
//  Stack.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/29.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public enum CPKStackAlignment : Int {
    case left           //left alignment for VStack
    case right          //right alignment for VStack
    
    case center         //center alignment for HStack and VStack
    case fill           //make subviews fill the the Stack
    
    case baseline       //lastBaseline alignment for HStack
    
    //top alignment for HStack
    public static var top: CPKStackAlignment { return CPKStackAlignment.left }
    //bottom alignment for HStack
    public static var bottom: CPKStackAlignment { return CPKStackAlignment.right }
}


/**
 * Create horizontal/vertical StackView with items.
 
 * There are two special items:
    1. Number: represent individual gap between two items.
    2. String: represent a Spring that will take as much space as possible.
 
 * There are three way to specified spacing between items:
    1. Using Number as StackView item, which will add spacing between two items.
    2. Using .gap() method, which will add spacing to all items.
    3. Using .margin() method on UIView. A negative value of margin will add spacing around view.
 
 * If you use Number and .gap() at the same time, the individual spacing will take precedence.
 
 * By default, all items are enclosured inside StackView.
   You can make a view exceeding the bounds of StackView by using a positive value of margin.
 
 * Usages:
    HStack(
        View.bg("random").pin(30, 30),
        20,
        View.bg("random").pin(60, 60),
        20,
        View.bg("random").pin(90, 90)
    ).pin(.xy(20, 20)).addTo(self.view).border(1)
     
    VStack(
        View.bg("random").pin(30, 30),
        View.bg("random").pin(60, 60),
        View.bg("random").pin(90, 90)
    ).gap(20).pin(.xy(20, 140)).addTo(self.view).border(1)
 
    VStack(
        HStack(
            View.bg("random").pin(30, 30),
            "<-->",
            View.bg("random").pin(30, 30)
        ),
        View.bg("random").pin(30).margin(-10),
        View.bg("random").pin(30).margin(0, 10)
    ).embedIn(self.view, 390, 20, 20).border(1)
 */

public func HStack(_ items: Any?...) -> CPKStackView {
    cpk_swizzleMethodsIfNeed()
    let stack = CPKStackView()
    stack.axis = .horizontal
    stack.alignment = .center
    
    let newItems = items.filter { $0 != nil } as [Any]
    stack.addArrangedSubviews(items: newItems)
    return stack
}

public func VStack(_ items: Any?...) -> CPKStackView {
    cpk_swizzleMethodsIfNeed()
    let stack = CPKStackView()
    stack.axis = .vertical
    stack.alignment = .left
    
    let newItems = items.filter { $0 != nil } as [Any]
    stack.addArrangedSubviews(items: newItems)
    return stack
}


public extension CPKStackView {
    
    /**
     * Universal gap between items.
     * For individual gap between items, use Number as StackView item.
     * Usages:
        .gap(10)
     */
    @discardableResult func gap(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    /**
     * StackView alignment
     * For HStack, the default alignment is .center.
     * For VStack, the default alignment is .left.
     * Usages:
        .align(.top)
        .align(.fill)
        ...
     */
    @discardableResult func align(_ alignment: CPKStackAlignment) -> Self {
        self.alignment = alignment
        return self
    }
}





