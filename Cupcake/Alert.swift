//
//  Alert.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/28.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * An easy way to Create Alert and ActionSheet.
 * Usages:
 
    Alert.title("Title").message("Message go here").cancel("Cancel").action("OK", {
        print("OK")
    }).show()
 
    ActionSheet.title("Title").message("Message go here").action("Action1", {
        print("Action1")
    }).action("Action2", {
        print("Action2")
    }).destructive("Delete", {
        print("Delete")
    }).cancel("Cancel").show()
 */

public var Alert: AlertMaker {
    cpk_swizzleMethodsIfNeed()
    return AlertMaker(style: .alert)
}

public var ActionSheet: AlertMaker {
    cpk_swizzleMethodsIfNeed()
    return AlertMaker(style: .actionSheet)
}


public extension AlertMaker {
    
    /**
     * Setting Alert/ActionSheet title
     * Usages:
        .title("Title")
     */
    @discardableResult func title(_ title: Any) -> Self {
        self.cpkTitle = title
        return self
    }
    
    /**
     * Setting Alert/ActionSheet message
     * Usages:
        .message("Message go here")
     */
    @discardableResult func message(_ message: Any) -> Self {
        self.cpkMessage = message
        return self
    }
    
    /**
     * Setting tintColor
     * tint use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .tint("red")
        .tint("#00F")
        ...
     */
    @discardableResult func tint(_ tint: Any) -> Self {
        self.cpkTint = tint
        return self
    }
    
    /**
     * Adding action button with title and a optional callback handler.
     * You can have multiply action button at the same time.
     * Usages:
        .action("Option1")
        .action("Option2", { /* do something */ })
     */
    @discardableResult func action(_ title: Any, _ callback: (()->())? = nil) -> Self {
        self.cpk_addAction(style: .default, title: title, handler: callback)
        return self
    }
    
    /**
     * Adding cancel button with title and a optional callback handler.
     * You can only have one cancel button.
     * Usages:
        .cancel("Cancel")
        .cancel("Cancel", { /* do something */ }
     */
    @discardableResult func cancel(_ title: Any, _ callback: (()->())? = nil) -> Self {
        self.cpk_addAction(style: .cancel, title: title, handler: callback)
        return self
    }
    
    /**
     * Adding destructive button with title and a optional callback handler.
     * You can have multiply action button at the same time.
     * Usages:
        .destructive("Delete")
        .destructive("Delete", { /* do someting */ }
     */
    @discardableResult func destructive(_ title: Any, _ callback: (()->())? = nil) -> Self {
        self.cpk_addAction(style: .destructive, title: title, handler: callback)
        return self
    }
    
    /**
     * Present Alert/ActionSheet
     * You must call this method in the end to make Alert/ActionSheet visible.
     * Usages:
        .show()                 //present in the top visible controller
        .show(someController)   //present in someController
     */
    func show(_ inside: UIViewController? = nil) {
        self.cpk_present(inside)
    }
}

