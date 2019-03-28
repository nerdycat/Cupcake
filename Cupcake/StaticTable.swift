//
//  StaticTable.swift
//  Cupcake
//
//  Created by nerdycat on 2017/4/21.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit

/**
 * PlainTable and GroupTable allow you to create static tableView with ease.
 * Usages:
 
    PlainTable("Option1", "Option2", "Option3").singleCheck().embedIn(self.view)
    PlainTable(["Option1", "Option2", "Option3"]).multiCheck().embedIn(self.view)
 
    GroupTable(
        Section(
            Row.str("Row1").detail("detail1"),
            Row.str("Row2").arrow().onClick({_ in print("row2") })
        ),
         
        Section(
            Row.str("Row3").detail("detail3").style(.subtitle),
            Row.str(AttStr("Row4").color("red")).switchOn().onChange({ row in
                print(row.switchView.isOn)
            })
        ).header(20),
         
        Row.custom({ row in
            Label.str("Delete").color("red").align(.center).embedIn(row.cell.contentView)
        })
     
     ).embedIn(self.view)
 */

public func PlainTable(_ sectionsOrRows: Any...) -> StaticTableView {
    cpk_swizzleMethodsIfNeed()
    let tableView = StaticTableView(sectionsOrRows: sectionsOrRows, style: .plain)
    tableView.tableFooterView = UIView()
    return tableView
}

public func GroupTable(_ sectionsOrRows: Any...) -> StaticTableView {
    cpk_swizzleMethodsIfNeed()
    return StaticTableView(sectionsOrRows: sectionsOrRows, style: .grouped)
}

public func Section(_ rowsOrStrings: Any...) -> StaticSection {
    cpk_swizzleMethodsIfNeed()
    return StaticSection(rowsOrStrings: rowsOrStrings)
}

public var Row: StaticRow {
    cpk_swizzleMethodsIfNeed()
    return StaticRow()
}


public extension StaticTableView {
    
    /**
     * Setting font for all titleLabels.
     * If you only want to change one particular titleLabel's font, use AttStr instead.
     * font use Font() internally, so it can take any kind of values that Font() supported.
     * See Font.swift for more information.
     * Usages:
        .font(15)
        .font("20")
        .font("body")
        .font(someLabel.font)
        ...
     */
    @discardableResult func font(_ any: Any) -> Self {
        self.textFont = any
        return self
    }
    
    /**
     * Setting textColor for all titleLabels.
     * If you only want to change one particular titleLabel's textColor, use AttStr instead.
     * color use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .color(@"red")
        .color(@"#F00")
        .color(@"255,0,0")
        .color(someLabel.textColor)
        ...
     */
    @discardableResult func color(_ any: Any) -> Self {
        self.textColor = any
        return self
    }
    
    /**
     * Setting font for all detailTextLabels.
     * If you only want to change one particular detailTextLabel's font, use AttStr instead.
     * font use Font() internally, so it can take any kind of values that Font() supported.
     * See Font.swift for more information.
     * Usages:
        .font(15)
        .font("20")
        .font("body")
        .font(someLabel.font)
        ...
     */
    @discardableResult func detailFont(_ any: Any) -> Self {
        self.detailFont = any
        return self
    }
    
    /**
     * Setting textColor for all detailTextLabels.
     * If you only want to change one particular detailTextLabel's textColor, use AttStr instead.
     * color use Color() internally, so it can take any kind of values that Color() supported.
     * See Color.swift for more information.
     * Usages:
        .color(@"red")
        .color(@"#F00")
        .color(@"255,0,0")
        .color(someLabel.textColor)
        ...
     */
    @discardableResult func detailColor(_ any: Any) -> Self {
        self.detailColor = any
        return self
    }
    
    /** 
     * Setting height for all cells.
     * Usages:
        .rowHeight(50)
        .rowHeight(-1)  //negative value means use UITableViewAutomaticDimension
     */
    @discardableResult func rowHeight(_ height: CGFloat) -> Self {
        self.cellHeight = height
        return self
    }
    
    /**
     * Setting separator line indent for all cells.
     * Usages:
        .lineIndent(0)
        .lineIndent(10)
     */
    @discardableResult func lineIndent(_ indent: CGFloat) -> Self {
        self.separatorIndent = indent
        return self
    }
    
    /**
     * Shorthand for setting disclosureIndicator for all cells.
     * Usages:
        .arrow()
        .arrow(false)
     */
    @discardableResult func arrow(_ showArrow: Bool = true) -> Self {
        self.accessoryType = (showArrow ? .disclosureIndicator : nil)
        return self
    }

    /**
     * Call when cell is about to appear.
     * You can use this method to further customize cell.
     * Be aware of retain cycle when using this method.
     * Usages:
        .custom({ [weak self] row in
            let cell = row.cell
            let indexPath = row.indexPath
            ...
        })
     */
    @discardableResult func custom(_ handler: @escaping (StaticRow)->()) -> Self {
        self.customHandler = handler
        return self
    }
    
    /**
     * Call when cell is being selected.
     * By passing a callback handler, all the cells will become selectable.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onClick({ [weak self] row in
            let cell = row.cell
            let indexPath = row.indexPath
            ...
        })
     */
    @discardableResult override func onClick(_ callback: @escaping (StaticRow)->()) -> Self {
        self.onClickHandler = callback
        return self
    }
}


public extension StaticSection {
    
    /**
     * Setting section header.
     * By default, grouped style tableView' sections have default header and footer height.
     * Header can be Number, String, View.
     * Usages:
        .header(10)         //10 point header height, useful for changing GroupTableView's section gap.
        .header("Header1")  //header with string
        .header(headerView) //header with view
     */
    @discardableResult func header(_ any: Any) -> Self {
        self.headerValue = any
        return self
    }
    
    /**
     * Setting section footer.
     * By default, grouped style tableView' sections have default header and footer height.
     * Footer can be Number, String, View.
     * Usages:
        .footer(10)         //10 point footer height, useful for changing GroupTableView's section gap.
        .footer("Footer1")  //footer with string
        .footer(footerView) //footer with view
     */
    @discardableResult func footer(_ any: Any) -> Self {
        self.footerValue = any
        return self
    }
    
    /**
     * Turning on single-check behavior for section.
     * To find out which cells are being checked, use checkedIndexPaths property on StaticTableView.
     * Usages:
        .singleCheck()                          //use system checkmark
        .singleCheck("checked")                 //use custom image
        .singleCheck("checked", "unchecked")    //use custom images
     */
    @discardableResult func singleCheck(_ checkedImage: Any? = nil, _ uncheckedImage: Any? = nil) -> Self {
        self.enableSingleCheck = true
        self.checkedImage = checkedImage != nil ? Img(checkedImage!) : nil
        self.uncheckedImage = uncheckedImage != nil ? Img(uncheckedImage!) : nil
        return self
    }
    
    /**
     * Turning on multi-mheck behavior for section.
     * To find out which cells are being checked, use checkedIndexPaths property on StaticTableView.
     * Usages:
        .multiCheck()                           //use system checkmark
        .multiCheck("checked")                  //use custom image
        .multiCheck("checked", "unchecked")     //use custom images
     */
    @discardableResult func multiCheck(_ checkedImage: Any? = nil, _ uncheckedImage: Any? = nil) -> Self {
        self.enableMultiCheck = true
        self.checkedImage = checkedImage != nil ? Img(checkedImage!) : nil
        self.uncheckedImage = uncheckedImage != nil ? Img(uncheckedImage!) : nil
        return self
    }
}


public extension StaticRow {
    
    
    /**
     * Setting image for cell.
     * img use Img() internally, so it can take any kind of values that Img() supported.
     * See Img.swift for more information.
     * Usages:
        .img("cat")
        .img("#button-background")
        .img("$home-icon")
        .img(someImage)
        ...
     */
    @discardableResult func img(_ any: Any?) -> Self {
        self.image = CPKImageOptional(any)
        return self
    }
    
    /**
     * Setting text or attributedText for cell's textLabel.
     * str can take any kind of value, even primitive type like Int.
     * Usages:
        .str(1024)
        .str("hello world")
        .str( AttStr("hello world").strikethrough() )
        ...
     */
    @discardableResult func str(_ any: Any?) -> Self {
        self.text = any
        return self
    }
    
    /**
     * Setting text or attributedText for cell's detailTextLabel.
     * detail can take any kind of value, even primitive type like Int.
     * Usages:
        .detail(1024)
        .detail("hello world")
        .detail( AttStr("hello world").strikethrough() )
        ...
     */
    @discardableResult func detail(_ any: Any?) -> Self {
        self.detailText = any
        return self
    }
    
    /** 
     * Setting cell style.
     * Usages:
        .style(.subtitle)
        .style(.value2)
        ...
     */
    @discardableResult func style(_ style: UITableViewCellStyle_) -> Self {
        self.cellStyle = style
        return self
    }
    
    /**
     * Setting accessoryType or accessoryView.
     * Usages:
        .accessory(.disclosureIndicator)
        .accessory(.detailButton)
        .accessory(.view(someView))         //setting accessoryView
        ...
     */
    @discardableResult func accessory(_ type: CPKTableViewCellAccessoryType) -> Self {
        self.accessoryType = type
        return self
    }
    
    /**
     * Shorthand for setting accessoryType with .disclosureIndicator.
     * Usages:
        .arrow()
        .arrow(false)
     */
    @discardableResult func arrow(_ showArrow: Bool = true) -> Self {
        self.accessoryType = showArrow ? .disclosureIndicator : CPKTableViewCellAccessoryType.none
        return self
    }
    
    /**
     * Shorthand for setting accessoryType with .checkmark.
     * Usages:
        .check()
        .check(false)
     */
    @discardableResult func check(_ checked: Bool = true) -> Self {
        self.accessoryType = checked ? .checkmark : CPKTableViewCellAccessoryType.none
        return self
    }
    
    /**
     * Shorthand for setting accessoryView with UISwitch.
     * Usages:
        .switchOn()
        .switchOn(false)
     */
    @discardableResult func switchOn(_ isOn: Bool = true) -> Self {
        let sw: UISwitch! = self.switchView ?? {self.switchView = UISwitch(); return self.switchView}()
        sw.isOn = isOn
        self.accessory(.view(sw))
        return self
    }
    
    /**
     * Settting cell height.
     * Usages:
        .height(50)
        .height(-1)     //negative value means use UITableViewAutomaticDimension
     */
    @discardableResult func height(_ height: CGFloat) -> Self {
        self.cellHeight = height
        return self
    }
    
    /**
     * Setting separator line indent.
     * Usages:
        .lineIndent(10)
     */
    @discardableResult func lineIndent(_ indent: CGFloat) -> Self {
        self.separatorIndent = indent
        return self
    }
    
    /**
     * Call when cell is being selected.
     * By passing a callback handler, the cell become selectable.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onClick({ [weak self] row in
            let cell = row.cell
            let indexPath = row.indexPath
            ...
        })
     */
    @discardableResult override func onClick(_ callback: @escaping (StaticRow)->()) -> Self {
        self.onClickHandler = callback
        return self
    }
    
    /**
     * Call when cell's detailButton is being clicked.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onButton({ [weak self] row in
            let cell = row.cell
            let indexPath = row.indexPath
            ...
        })
     */
    @discardableResult func onButton(_ callback: @escaping (StaticRow)->()) -> Self {
        self.onButtonHandler = callback
        return self
    }
    
    /**
     * Call when switch's value is changed.
     * Be aware of retain cycle when using this method.
     * Usages:
        .onChange({ [weak self] row in
            let sw = row.switchView
            let indexPath = row.indexPath
            ...
        })
     */
    @discardableResult func onChange(_ callback: @escaping (StaticRow)->()) -> Self {
        self.onChangeHandler = callback
        return self
    }
    
    /**
     * Call when cell is about to appear.
     * You can use this method to further customize cell.
     * Usages:
        .custom({ row in
            let cell = row.cell
            let indexPath = row.indexPath
            ...
        })
     */
    @discardableResult func custom(_ handler: @escaping (StaticRow)->()) -> Self {
        self.customHandler = handler
        return self
    }
}



