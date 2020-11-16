//
//  EnhancementViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/4/27.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

class EnhancementViewController: BaseViewController {

    override func setupUI() {
        
        //Label with lineSpacing and link
        let str = "With #Cupcake, @Label now support lineSpacing and Link handling. Additionally, @TextField and @TextView both have the abilities to set max length and placeholder. "
        
        let attStr = AttStr(str).select("Link handling", .hashTag, .nameTag).link()
        
        let label = Label.str(attStr).lineGap(10).lines().onLink({ text in
            print(text)
        }).embedIn(self.view, 15, 15, 15)
        
        
        //TextField with maxLength
        let nameField = TextField.pin(40).padding(0, 8).border(1).maxLength(5).hint("normal")
        let codeField = TextField.pin(40).padding(0, 8).border(1).maxLength(4).hint("secure").keyboard(.numberPad).secure()
        
        nameField.makeCons({ make in
            make.top.equal(label).bottom.offset(20)
            make.left.offset(15)
            
        }).onFinish({ _ in
            codeField.becomeFirstResponder()
        })
        
        codeField.makeCons({ make in
            make.top.equal(nameField)
            make.left.equal(nameField).right.offset(10)
            make.right.offset(-15)
            make.width.equal(nameField)
            
        }).onChange({ [unowned self] codeField in
            if codeField.text?.count == 4 {
                self.view.viewWithTag(101)?.becomeFirstResponder()
            }
        })
        
        
        //TextView with placeholder and maxLength
        let textView = TextView.padding(8).maxLength(40).border(1).makeCons({ make in
            make.left.right.offset(15, -15)
            make.top.equal(nameField).bottom.offset(10)
            make.height.equal(100)
        }).hint("comment")
        
        textView.tag = 101
        self.view.addSubviews(nameField, codeField, textView)
        
        self.view.onClick({ view in
            view.endEditing(true)
        })
    }
}



