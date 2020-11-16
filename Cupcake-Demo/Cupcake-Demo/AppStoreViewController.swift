//
//  AppStoreViewController.swift
//  Cupcake-Demo
//
//  Created by nerdycat on 2017/5/15.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

class AppStoreCell: UITableViewCell {
    var iconView: UIImageView!
    var actionButton: UIButton!
    var indexLabel, titleLabel, categoryLabel: UILabel!
    var ratingLabel, countLabel, iapLabel: UILabel!
    
    func update(app: Dictionary<String, Any>, index: Int) {
        indexLabel.str(index + 1)
        iconView.img(app["iconName"] as! String)
        titleLabel.text = app["title"] as? String
        categoryLabel.text = app["category"] as? String
        countLabel.text = Str("(%@)", app["commentCount"] as! NSNumber)
        iapLabel.isHidden = !(app["iap"] as! Bool)
        
        let rating = (app["rating"] as! NSNumber).intValue
        var result = ""
        for i in 0..<5 { result = result + (i < rating ? "★" : "☆") }
        ratingLabel.text = result
        
        let price = app["price"] as! String
        actionButton.str( price.count > 0 ? "$" + price : "GET")
    }
    
    func setupUI() {
        indexLabel = Label.font(17).color("darkGray").align(.center).pin(.w(44))
        iconView = ImageView.pin(64, 64).radius(10).border(1.0 / UIScreen.main.scale, "#CCC")
        
        titleLabel = Label.font(15).lines(2)
        categoryLabel = Label.font(13).color("darkGray")
        
        ratingLabel = Label.font(11).color("orange")
        countLabel = Label.font(11).color("darkGray")
        
        actionButton = Button.font("15").color("#0065F7").border(1, "#0065F7").radius(3)
        actionButton.highColor("white").highBg("#0065F7").padding(5, 10)
        
        iapLabel = Label.font(9).color("darkGray").lines(2).str("In-App\nPurchases").align(.center)
        
        let ratingStack = HStack(ratingLabel, countLabel).gap(5)
        let midStack = VStack(titleLabel, categoryLabel, ratingStack).gap(4)
        let actionStack = VStack(actionButton, iapLabel).gap(4).align(.center)
        
        HStack(indexLabel, iconView, 10, midStack, "<-->", 10, actionStack).embedIn(self.contentView, 10, 0, 10, 15)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AppStoreViewController: UITableViewController {
    
    var appList: Array<Dictionary<String, Any>>!
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AppStoreCell
        let app = self.appList[indexPath.row]
        cell.update(app: app, index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 84
        self.tableView.register(AppStoreCell.self, forCellReuseIdentifier: "cell")
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 34, right: 0)
        
        let path = Bundle.main.path(forResource: "appList", ofType: "plist")
        appList = NSArray(contentsOfFile: path!) as? Array<Dictionary<String, Any>>
        for _ in 1..<5 { appList.append(contentsOf: appList) }
    }
}
