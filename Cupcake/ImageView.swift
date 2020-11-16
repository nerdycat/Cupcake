//
//  ImageView.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/23.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

public var ImageView: UIImageView {
    cpk_swizzleMethodsIfNeed()
    let imageView = UIImageView()
    cpk_higherHuggingAndResistance(forView: imageView)
    return imageView
}

public extension UIImageView {
    
    /**
     * Setting image
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
        self.image = CPKImageOptional(any)
        
        if self.image != nil {
            if self.frame.isEmpty {
                self.frame.size = self.image!.size
            }
        }
        
        cpk_masksToBoundsIfNeed()
        return self
    }
    
    /**
     * Setting contentMode
     * Usages:
        .mode(.scaleAspectFit)
        .mode(.center)
        ...
    */
    @objc @discardableResult func mode(_ contentMode: UIViewContentMode_) -> Self {
        self.contentMode = contentMode
        return self
    }
}
