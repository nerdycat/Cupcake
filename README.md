<p align="center">
<img src="./res/cupcake.png" alt="cupcake" width="30%" />
</p>

<p align="center">
<img src="https://camo.githubusercontent.com/987c5cc551bc4988195dffc73b6822e11eb451cc/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f7377696674342d636f6d70617469626c652d3442433531442e7376673f7374796c653d666c6174" alt="Swift4" />
<img src="https://camo.githubusercontent.com/440edeeeb3b2c1b118c6184fd929167587dea9a2/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f73776966742d352e302d6f72616e67652e737667" alt="Swift5" />
<img src="https://camo.githubusercontent.com/1d276aa371242346c77c3a5b8db34beaa2014722/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f694f532d382e302532422d626c75652e737667" alt="Platform" />
<img src="http://cocoapod-badges.herokuapp.com/v/Cupcake/badge.png" alt="Version" />
<img src="http://cocoapod-badges.herokuapp.com/l/Cupcake/badge.png" alt="License" />
</p>

## Introduction
Cupcake is a framework that allow you to easily create and layout UI components for iOS 8.0+. It use chaining syntax and provides some frequent used functionalities that are missing in UIKit. 

---
## Easy way to create UIFont, UIImage and UIColor objects
	
You can create UIFont object with `Font()` function.

	Font(15)                    //UIFont.systemFontOfSize(15)
	Font("15")                  //UIFont.boldSystemFontOfSize(15)
	Font("body")                //UIFontTextStyle.body
	Font("Helvetica,15")        //helvetica with size of 15
	
You can create UIImage object with `Img()` function.

	Img("imageName")            //image with name
	Img("#imageName")           //prefixed with # will return a stretchable image
	Img("$imageName")           //prefixed with $ will return a template image
	Img("red")                  //1x1 size image with red color

You can create UIColor object with `Color()` function.

	Color("red")                //UIColor.red
	Color("0,0,255")            //RGB color
	Color("#0000FF")            //Hex color
	Color("random")             //random color
    
    Color("red,0.5")            //even with alpha
    Color("0,0,255,0.8")
    Color("#0000FF,0.5")
    Color("random,0.2")
	
    Color(Img("pattern"))       //or image


## Easy way to create NSAttributedString objects and String manipulations

You can create NSAttributedString object with `AttStr()` function.

	AttStr("hello").color("red")                        //red color string
	AttStr("hello, 101").select("[0-9]+").underline     //101 with underline
	AttStr("A smile ", Img("smile"), " !!")             //insert image attachment
	
String manipulations:

	Str(1024)                                           //convert anything to string
	Str("1 + 1 = %d", 2)                                //formatted string
	
	"hello world".subFrom(2).subTo("ld")                //"llo wor"
	"hello world".subAt(1..<4)                          //"ell"
	"hello 12345".subMatch("\\d+")                      //"12345"


## 4 basic UI components

You can create UIView, UILabel, UIImageView and UIButton objects simply by using `View`, `Label`, `ImageView` and `Button` variables.

	View.bg("red").border(1).radius(4).shadow(0.7, 2)
	
	Label.str("hello\ncupcake").font(30).color("#FB3A9F").lines(2).align(.center)
	
	ImageView.img("cat").mode(.scaleAspectFit)
	
	Button.str("kitty").font("20").color("#CFC8AC").highColor("darkGray").onClick({ _ in
        print("click")
	}).img("cat").padding(10).border(1, "#CFC8AC")
	
As you can see, `.font()`, `.img()` and `.color()` can take the same parameters as `Font()`, `Img()` and `Color()`. Also you can pass String, NSAttributedString or any other values to `.str()`.


## Enhancements

You can add click handler and adjust click area to any view.   
To round a view with half height no matter what size it is, simply use `.radius(-1)`. 

	ImageView.img("mario").radius(-1).touchInsets(-40).onClick({ _ in
	    print("extending touch area")
	})

You can add line spacing and link handling to UILabel.

	let str = "Lorem ipsum 20 dolor sit er elit lamet, consectetaur cillium #adipisicing pecu, sed do #eiusmod tempor incididunt ut labore et 3.14 dolore magna aliqua."
	let attStr = AttStr(str).select("elit", .number, .hashTag, .range(-7, 6)).link()
	
	Label.str(attStr).lineGap(10).lines().onLink({ text in
	    print(text)
	})
	
`.bg()` allow you to set background for any view with color or image.    
`.highBg()` allow you to set highlighted background for UIButton (which is very useful).    
Also you can add spacing to title and image within button or even exchange their position. 

	Button.str("More").img("arrow").color("black").bg("lightGray,0.3").highBg("lightGray").gap(5).reversed()
	
You can add placeholder and limit text input to UITextField and UITextView.

	TextField.hint("placeholder").maxLength(10).padding(0, 10).keyboard(.numberPad)
	
	TextView.hint("placeholder").maxLength(140).padding(10).onChange({ textView in
	    print(textView.text)
	})
    

## Easy way to Setup Constraints

You use `.pin()` to setup simple constraints relative to self or superview. 

	.pin(200)                       //height constriant
	.pin(100, 200)                  //width and height constraints			
	.pin(.xy(50, 50))               //left and top constraints relative to superview
	.pin(.maxXY(50, 50))            //right and bottom constraints relative to superview
	.pin(.center)                   //center equals to superview
	 ...
	.pin(.lowHugging)               //low content hugging priority, useful when embed in StackView
	.pin(.lowRegistance)            //low content compression resistance priority, useful when embed in StackView


You use `.makeCons()` and `.remakeCons()` to setup any constraints just like SnapKit.

	.makeCons({
   	    $0.left.top.equal(50, 50)
	    $0.size.equal(view2).multiply(0.5, 0.7)
	})
	
	.remakeCons({ make in
	    make.origin.equal(view2).offset(10, 20)
	    make.width.equal(100)
	    make.height.equal(view2).multiply(2)
	})
	
You use `.embedIn()` to embed inside superview with edge constriants.

	.embedIn(superview)                     //top: 0,  left: 0,  bottom: 0,  right: 0
    .embedIn(superview, 10)                 //top: 10, left: 10, bottom: 10, right: 10
    .embedIn(superview, 10, 20)             //top: 10, left: 20, bottom: 10, right: 20
    .embedIn(superview, 10, 20, 30)         //top: 10, left: 20, right: 30
    .embedIn(superview, 10, 20, 30, 40)     //top: 10, left: 20, bottom: 30, right: 40
    .embedIn(superview, 10, 20, nil)        //top: 10, left: 20


## Easy way to Layout

Setup constraints for every views manually could be tedious. Luckily, you can build most of the layouts by simply using `HStack()` and `VStack()` (which are similar to UIStackView) and hopefully without creating any explicit constirants. 

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
 	
 <img src="./res/appstore.png" alt="appStore" width="50%" />


## Lightweight Style

Some of the chainable properties can be set as style.

	//local style
	let style1 = Styles.color("darkGray").font(15)
	Label.styles(style1).str("hello world")
	
	//global style
	Styles("style2").bg("red").padding(10).border(3, "#FC6560").radius(-1)
	Button.styles(style1, "style2").str("hello world")
	
	//copy style from view
	let style3 = Styles(someButton)
	Button.styles(someButton).str("hello world")
	

## Others

You can create static tableView with `PlainTable()` or `GroupTable()` functions.
	
	let titles = ["Basic", "Enhancement", "Stack", "StaticTable", "Examples"]
	PlainTable(titles).onClick({ row in
	    print(row.indexPath)
	})

You can present `Alert` And `ActionSheet` using the chaining syntax as well.

	Alert.title("Alert").message("message go here").action("OK").show()
	
	ActionSheet.title("ActionSheet").message("message go here").action("Action1", {
 	    print("Action1")
 	}).action("Action2", {
 	    print("Action2")
 	}).cancel("Cancel").show()


## Installation

### Cocoapods
Cupcake can be added to your project using CocoaPods by adding the following line to your Podfile:

	pod "Cupcake"

### Carthage
If you're using Carthage you can add a dependency on Cupcake by adding it to your Cartfile:

	github "nerdycat/Cupcake"
