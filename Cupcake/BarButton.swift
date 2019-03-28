//
//  BarButton.swift
//  Cupcake
//
//  Created by nerdycat on 2019/3/27.
//  Copyright © 2019 nerdycat. All rights reserved.
//

import UIKit

public var BarButton: UIBarButtonItem {
    cpk_swizzleMethodsIfNeed()
    let button = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    return button
}

public func BarButton(_ item: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
    return UIBarButtonItem.init(barButtonSystemItem: item, target: nil, action: nil)
}


public extension UIBarButtonItem {
    
    @discardableResult func str(_ any: Any) -> UIBarButtonItem {
        if let attStr = any as? NSAttributedString {
            title = attStr.string
            let attDict = attStr.attributes(at: 0, effectiveRange: nil)
            setTitleTextAttributes(attDict, for: .normal)
            setTitleTextAttributes(attDict, for: .highlighted)
        } else {
            title = String(describing: any)
        }
        return self
    }
    
    @discardableResult func img(_ any: Any) -> UIBarButtonItem {
        image = Img(any)
        return self
    }
    
    @discardableResult func tint(_ any: Any) -> Self {
        self.tintColor = Color(any)
        return self
    }
    
    //click handler
    @discardableResult func onClick(_ closure: @escaping (UIBarButtonItem)->Void) -> Self {
        cpk_onClick(closure: closure)
        return self
    }
    
    //click handler with zero parameter
    @discardableResult func onTap(_ closure: @escaping ()->Void) -> Self {
        cpk_onTap(closure: closure)
        return self
    }
}
