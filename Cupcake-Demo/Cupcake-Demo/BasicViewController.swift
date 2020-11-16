//
//  BasicViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/4/27.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

class BasicViewController: BaseViewController {

    override func setupUI() {
        
        //View
        let box = View.bg("red").pin(20, 20, 50, 50).border(4).onTap {
            print("box")
        }
        
        let circle = View.bg("blue").makeCons({
            $0.left.top.equal(box).right.top.offset(20, 0)
            $0.size.equal(50, 50)
        }).radius(-1).shadow(0.7)
        
        
        //Label
        let label = Label.str("This is a normal Label.").font(17).color("66,66,66").pin(.xy(20, 100))
        
        var att = AttStr("This is an attributed Label.").font(17).color("#3A3A3A")
        att.select("attributed Label").underline().select(.range(8, 2)).color("red")
        
        let attLabel = Label.str(att).pin(.xy(20, 130))
        
        
        //ImageView
        let candle = ImageView.img("candle").pin(.xy(20, 180))
        let tintedCandle = ImageView.img("$candle").tint("#86BD5B").pin(.xy(70, 180))
        
        
        //Button
        let done = Button.str("Done").padding(5, 10).bg("red").highBg("blue").pin(.xy(20, 260)).radius(6)
        
        att = AttStr("Friends\n1024").font(13).select(.number).font("17")
        
        let friends = Button.str(att).border(1).highBg("darkGray,0.2").makeCons({
            $0.left.centerY.equal(done).right.centerY.offset(20, 0)
        }).padding(10).lines()
        
        let more = Button.str("More").img("arrow").color("black").gap(5).reversed().makeCons({ make in
            make.left.centerY.equal(friends).right.centerY.offset(20, 0)
        }).onTap({
            Alert.title("Alert").message("You just clicked the button.").action("OK").show()
        }).touchInsets(-20)
        
        self.view.addSubviews(box, circle, label, attLabel, candle, tintedCandle, done, friends, more)
    }
}



