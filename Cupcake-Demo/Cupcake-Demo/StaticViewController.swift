//
//  StaticViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/4/28.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

class StaticViewController: BaseViewController {

    override func setupUI() {
        weak var weakSelf = self
        
        GroupTable(
            Section(
                Row.img("airplane").str("Airplane Mode").switchOn(false).onChange({ row in
                    print(row.switchView.isOn)
                }),
                Row.img("wlan").str("WLAN").detail("Not connected").arrow().onClick({ _ in
                    weakSelf?.push(WLANViewController())
                }),
                Row.img("disturb").str("Do Not Disturb").arrow().onClick({ _ in
                    weakSelf?.push(DisturbViewController())
                })
            ),
            
            Section(
                Row.img("general").str("General").arrow().custom({ row in
                    let badge = Button.pin(22, 22, .maxX(-5), .centerY(0)).radius(-1).str(1).font(14).bg("red")
                    badge.isUserInteractionEnabled = false
                    row.cell.contentView.addSubview(badge)
                }).onClick({ _ in
                    weakSelf?.push(GeneralViewController())
                }),
                Row.img("display").str("Display & Brightness").arrow().onClick({ _ in
                    weakSelf?.push(DisplayViewController())
                })
            )
            
        ).embedIn(self.view)
    }
}


class WLANViewController: BaseViewController {
    override func setupUI() {
        let footer = "Known networks will be joined automatically. If no known networks are available, you will have to manually select a network."
        
        GroupTable(
            Row.str("WLAN").switchOn().onChange({ row in
                print(row.switchView.isOn)
            }),
            
            Section(
                Row.str("Wireless 1").detail("\u{0001F512} \u{268C}").accessory(.detailButton).onButton({ _ in
                    Alert.title("Wireless 1").message("detail button tapped").action("OK", {
                        print("OK")
                    }).cancel("Cancel").show()
                }).onClick({ _ in
                    print("Wireless 1")
                }),
                
                Row.str("Wireless 2").detail("\u{0001F513} \u{2630}").accessory(.detailButton).onButton({ _ in
                    ActionSheet.title("Wireless 2").message("detail button tapped").action("OK", {
                        print("OK")
                    }).cancel("Cancel").show()
                }).onClick({ _ in
                    print("Wireless 2")
                })
            ).header("CHOOSE A NETWORK..."),
            
            Section(
                Row.str("Ask to Join Networks").switchOn(false).onChange({ row in
                    print(row.switchView.isOn)
                })
            ).footer(footer)
        ).embedIn(self.view)
    }
}


class DisturbViewController: BaseViewController {
    override func setupUI() {
        
        let footer1 = "When Do Not Disturb is enabled calls and alerts that arrive while locked will be silenced, and a moon icon will appear in the status bar."
        let footer2 = "Incoming calls and notifications will be silenced while iPhone is either locked or unlocked."
        
        GroupTable(
            Section(
                Row.str("Manual").switchOn(false).onChange({ row in
                    print(row.switchView.isOn)
                })
            ).footer(footer1),
            
            Section(
                Row.str("Always").check().onClick({ _ in
                    print("always")
                }),
                Row.str("Only while iPhone is locked").onClick({ _ in
                    print("only locked")
                })
            ).singleCheck().header("SILENCE:").footer(footer2)
            
        ).embedIn(self.view)
    }
}


class GeneralViewController: BaseViewController {
    var table: StaticTableView!
    
    override func setupUI() {
        weak var weakSelf = self
        
        table = GroupTable(
            Section(
                Row.str("Name").arrow().onClick({ _ in
                    weakSelf?.push(NameViewController())
                })
            ),
            Section(
                Row.str("Software Update").arrow().onClick({ _ in
                    weakSelf?.push(UpdateViewController())
                })
            )
        ).embedIn(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        table.update(detail: NameViewController.name, at: IndexPath(row: 0, section: 0))
    }
}


class NameViewController: BaseViewController {
    static var name = "My-iPhone"
    var textField: UITextField!
    
    override func setupUI() {
        let name = NameViewController.name
        
        GroupTable(
            Row.custom({ row in
                self.textField = TextField.str(name).hint(name).clearMode(.whileEditing).onFinish({ [unowned self] textField in
                    NameViewController.name = textField.text ?? ""
                    self.navigationController!.popViewController(animated: true)
                }).embedIn(row.cell.contentView, 0, 15)
            })
        ).embedIn(self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
}


class UpdateViewController: BaseViewController {
    override func setupUI() {
        let desc = "iOS 10.3.1 introduces new features including the ability to locate AirPods using Find my iPhone and more ways to use Siri with payment, ride booking and automaker apps.\n\nFor information on the security content of Apple software update, please visit this website: https://support.apple.com/kb/HT201222"
        
        
        GroupTable(
            Section(
                Row.custom({ row in
                    let icon = ImageView.pin(60, 60).img("general")
                    let title = Label.str("iOS 10.3.1").font("15")
                    let cops = Label.str("Apple Inc.").font(13)
                    let status = Label.str("Downloaded").font(13)
                    
                    let attDesc = AttStr(desc).font(15).select(.url).link()
                    let desc = Label.str(attDesc).lines().onLink({ text in
                        print(text)
                    })
                    
                    let head = HStack( icon, VStack(title, cops, status).gap(2) ).gap(10)
                    VStack(head, 12, desc).embedIn(row.cell.contentView, 10, 15)
                }).height(-1),
                
                Row.str("Learn More").arrow().onClick({ _ in
                    print("learn more")
                })
            ),
            
            Section(
                Row.str(AttStr("Install Now").color("#157EFB")).onClick({ _ in
                    print("install")
                })
            )
        ).embedIn(self.view)
    }
}


class DisplayViewController: BaseViewController {
    var autoLockRow: StaticRow!
    
    override func setupUI() {
        autoLockRow = Row.str("Auto-Lock").detail("").arrow().onClick({ [unowned self] _ in
            self.push(AutoLockViewController())
        })
        
        GroupTable(
            Section(
                Row.custom({ row in
                    let slider = UISlider().embedIn(row.cell.contentView, 0, 15)
                    slider.minimumValueImage = Img("$candle").resize(0.5)
                    slider.maximumValueImage = Img("$candle").resize(0.7)
                })
            ).header("BRIGHTNESS"),
            
            Section(autoLockRow!)
        ).embedIn(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoLockRow.detail(AutoLockViewController.selectedOption())
    }
}


class AutoLockViewController: BaseViewController {
    static let options = ["30 Seconds", "1 Minute", "2 Minutes", "3 Minutes", "4 Minutes", "Never"]
    static var optionIndex = 1
    
    var tableView: StaticTableView!
    
    class func selectedOption() -> String {
        return options[optionIndex]
    }
    
    override func setupUI() {
        tableView = GroupTable(
            Section(AutoLockViewController.options).singleCheck()
        ).custom({ row in
            if row.indexPath.row == AutoLockViewController.optionIndex {
                row.check()
            }
        }).embedIn(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AutoLockViewController.optionIndex = tableView.checkedIndexPaths.first!.row
    }
}


class BaseViewController: UIViewController {
    
    func push(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
    }
}








