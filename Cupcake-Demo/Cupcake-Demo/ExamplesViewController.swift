//
//  ExamplesViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/5/3.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit


class ExamplesViewController: BaseViewController {

    override func setupUI() {
        let titles = ["Signup", "Shubox", "Dashboard", "AppStore"]
        
        PlainTable(titles).embedIn(self.view).onClick({ [unowned self] row in
            var target: UIViewController!
            
            switch row.indexPath.row {
                case 0: target = SignupViewController()
                case 1: target = ShuboxViewController()
                case 2: target = DashboardViewController()
                case 3: target = AppStoreViewController()
                default: break
            }
            
            target.title = row.cell.textLabel?.text
            self.push(target)
        })
    }
}



class SignupViewController: BaseViewController {
    
    override func setupUI() {
        //https://dribbble.com/shots/3346069-001-Log-in-Sing-up
        
        self.view.bg("#184367")
        
        let iphone5 = UIScreen.main.bounds.width == 320
        let card = View.bg("white").radius(4).embedIn(self.view, iphone5 ? 40 : "60", 30)
        
        let inputStyle = Styles.pin(40, .lowHugging).font(14)
        Styles("separator").bg("#C7C7CD").pin(1)
        
        let name = Label.str("FULL NAME").font(17)
        let nameField = TextField.hint("Enter your full name").maxLength(15).styles(inputStyle)
        let line1 = View.styles("separator")
        
        let email = Label.str("E-MAIL").font(17)
        let emailField = TextField.hint("Your E-mail goes here").keyboard(.emailAddress).styles(inputStyle)
        let line2 = View.styles("separator")
        
        let pw = Label.str("Password").font(17)
        let pwField = TextField.hint("Enter your password").maxLength(10).secure().styles(inputStyle)
        let line3 = View.styles("separator")
        
        let statement = Label.str("☑️  I agree all statements in").color("lightGray").font(12)
        let term = Button.str( AttStr("Terms of service").color("#8DD6E5").font("12").underline() ).margin(0, -22)
        
        let login = Button.str("LOG IN").font(15).bg("#4A96E3").pin(44, .lowHugging).radius(4)
        
        VStack(name, nameField, line1, 30, email, emailField, line2, 30,
               pw, pwField, line3, 30, statement , term, "<-->", login).embedIn(card, iphone5 ? 30: 50, 30, 30, 30)
        
        
        Button.str("X").font(13).color("#D2E0E8").bg("#EDF2F5").radius(-1).pin(16, 16, .maxX(-10), .y(10)).addTo(card)
        Button.str("HELP").font(13).padding(10).pin(.centerX(0), .maxY("-5")).addTo(self.view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



class ShuboxViewController: BaseViewController {
    
    override func setupUI() {
        //https://dribbble.com/shots/3462307-Responsive-Shubox
        
        let logo = Label.str("Shubox").color("#FC6560").font("30")
        
        let navStyle = Styles.color("darkGray").highColor("red").font(15)
        Styles("btn").color("#FC6560").highColor("white").highBg("#FC6560").font("15").padding(12, 30).border(3, "#FC6560").radius(-1)
        
        let pricing = Button.str("Pricing").styles(navStyle)
        let docs = Button.str("Docs").styles(navStyle)
        let demos = Button.str("Demos").styles(navStyle)
        let blog = Button.str("Blog").styles(navStyle)
        let signIn = Button.str("Sign In").styles(navStyle).color("#FC6560")
        
        let nav = HStack(pricing, docs, demos, blog, signIn).gap(15)
        
        let simpleFast = Label.str("Simple. Fast. \nCustomizable.").color("#7C60CE").font("30").lines().align(.center)
        let upload = Label.str("Upload images from your web app directly to Amazon S3.").color("#BE9FDE").font(15).lines().align(.center)
        
        let startTrial = Button.str("Start Your Free Trial").styles("btn")
        let image = ImageView.img("shubox").pin(.ratio)
        
        let items: [Any] = [logo, 15, nav, 45, simpleFast, 15, upload, 30, startTrial, "<-->", image]
        VStack(items).align(.center).embedIn(self.view, 10, 15, 0, 15)
    }
}



class DashboardViewController: BaseViewController {
    
    class DashButton: UIButton {
        let subtitle: String!
        
        override func setTitle(_ title: String?, for state: UIControl.State) {
            if state == .normal {
                let att = AttStr(
                    AttStr(title).font("18").color("#181D42"), "\n",
                    AttStr(subtitle).font(11).color("darkGray")
                ).lineGap(3).align(.center)
                self.str(att)
            } else {
                super.setTitle(title, for: state)
            }
        }
        
        init(_ subtitle: String) {
            self.subtitle = subtitle
            super.init(frame: CGRect.zero)
            self.pin(.lowHugging, 80).lines().gap(15).highBg("lightGray,0.2")
            self.adjustsImageWhenHighlighted = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func setupUI() {
        //https://dribbble.com/shots/3441336-Mobile-dashboard-items-list-light-design
        
        let logo = ImageView.img("dashboard")
        let profile = Button.img("customers")
        let header = HStack(logo, "<-->", profile)
        
        let welcome = Label.str("Welcome back,\nAndrew").font(18).color("darkGray").lines(2)
        
        let number = Label.str(83).font("AvenirNext-Bold,90").color("#181D42")
        let dash = View.pin(12, 3).bg("#DE2F43").radius(-1)
        let jobsites = Label.str("Jobsites\nrequests").font(13).color("darkGray").lines(2)
        let requests = HStack(number, 20, VStack(dash, 3, jobsites)).align(.baseline)
        
        let jobBtn = DashButton("Jobsites").img("jobsites").str(346)
        let requestsBtn = DashButton("Requests").img("requests").str(83)
        let customersBtn = DashButton("Customers").img("customers").str(12)
        
        let entitiesBtn = DashButton("Entities").img("entities").str(22).makeCons({
            $0.width.equal(jobBtn)
            $0.width.equal(requestsBtn)
            $0.width.equal(customersBtn)
        })
        
        let tiles = View.margin(0, 10)
        VStack(HStack(jobBtn, requestsBtn), HStack(customersBtn, entitiesBtn)).embedIn(tiles)
        
        VStack(header, 30, welcome, 15, requests, 40, tiles).embedIn(self.view, 30, 30, 30)
        
        let horLine = View.bg("lightGray,0.4").pin(1).makeCons({
            $0.left.bottom.equal(jobBtn)
            $0.width.equal(jobBtn).multiply(2)
        })
        
        let verLine = View.bg("lightGray,0.4").pin(.w(1)).makeCons({
            $0.top.right.equal(jobBtn)
            $0.height.equal(jobBtn).multiply(2)
        })
        
        self.view.addSubviews(horLine, verLine)
    }
}

