//
//  ViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/3/17.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    override func setupUI() {
        title = "Cupcake"
        
        navigationItem.rightBarButtonItem = BarButton(.add).onTap {
            print("add")
        }

        let titles = ["Basic", "Enhancement", "Stack", "StaticTable", "Examples"]

        PlainTable(titles).embedIn(self.view).onClick({ [unowned self] row in
            var target: UIViewController!
            
            switch row.indexPath.row {
                case 0: target = BasicViewController()
                case 1: target = EnhancementViewController()
                case 2: target = StackViewController()
                case 3: target = StaticViewController()
                case 4: target = ExamplesViewController()
                default: break
            }
            
            target.title = row.cell.textLabel?.text
            self.push(target)
        })
    }
}






