//
//  StackViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/4/28.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

class StackViewController: BaseViewController {
    
    var stack: CPKStackView!
    
    func randomView() -> UIView {
        let width = CGFloat(arc4random_uniform(30) + 20)
        let height = CGFloat(arc4random_uniform(30) + 20)
        let view = View.bg("random").pin(.wh(width, height)).onClick({
            $0.removeFromSuperview()
        })
        return view
    }
    
    func setupButtons() {
        let s = Styles.padding(3, 5).bg("red").font(15)
        
        let addView = Button.styles(s).str("add").onClick({[unowned self] _ in
            self.stack.addArrangedSubview(item: self.randomView())
        })
        
        let attachGap = Button.styles(s).str("attachGap").onClick({[unowned self] _ in
            self.stack.addArrangedSubview(item: arc4random_uniform(30))
        })
        
        let gap = Button.styles(s).str("gap").onClick({[unowned self] _ in
            self.stack.spacing = CGFloat(arc4random_uniform(30))
        })
        
        let align = Button.styles(s).str("align").onClick({[unowned self] _ in
            var next = self.stack.alignment.rawValue + 1
            if next > 2 { next = 0 }
            let alignment = CPKStackAlignment(rawValue: next)!
            self.stack.alignment = alignment
        })
        
        let axis = Button.styles(s).str("axis").onClick({[unowned self] _ in
            self.stack.axis = self.stack.axis == .vertical ? .horizontal : .vertical
        })
        
        HStack("<-->", addView, attachGap, gap, align, axis, "<-->").gap(8).embedIn(self.view, nil, 0, "0", 0)
    }
    
    override func setupUI() {
        super.setupUI()
        
        Label.str("click view to remove").font(15).color("lightGray").align(.center).embedIn(self.view, 10, 0, 0)
        stack = VStack(randomView()).border(1).pin(.center).addTo(self.view)
        
        setupButtons()
    }
}


