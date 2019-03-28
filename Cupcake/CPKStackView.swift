//
//  StackView.swift
//  Cupcake
//
//  Created by nerdycat on 2017/3/29.
//  Copyright © 2017 nerdycat. All rights reserved.
//

import UIKit


/**
 * Usually you don't use CPKStackView directly. 
 * Use HStack and VStack instread. See Stack.swift for more information.
 */

fileprivate let kDefaultEnclosurePriority: UILayoutPriority = 200
fileprivate let kAlignmentPriority: UILayoutPriority = 1000
fileprivate let kSpacingPriority: UILayoutPriority = 1000
fileprivate let kSpringPriority: UILayoutPriority = 1000

let kFixSizePriority: UILayoutPriority = 900
let kLowPriority: UILayoutPriority = 100
let kDefaultHuggingPriority: UILayoutPriority = 250


public class CPKStackView: UIView {
    
    private var alignmentConstraints = [NSLayoutConstraint]()
    private var spacingConstraints = [NSLayoutConstraint]()
    private var enslosureConstraints = [NSLayoutConstraint]()
    private var springConstraints = [NSLayoutConstraint]()
    
    private var _alignment: CPKStackAlignment = .left
    private var _spacing: CGFloat = 0
    private var _axis: UILayoutConstraintAxis_ = .horizontal
    private var _headAttachSpace: CGFloat?
    
    public private(set) var arrangedSubviews = [UIView]()
    
    
    public var alignment: CPKStackAlignment {
        get { return _alignment }
        set { if _alignment != newValue { _alignment = newValue; alignmentDidChange() } }
    }
    
    public var spacing: CGFloat {
        get { return _spacing }
        set { if _spacing != newValue { _spacing = newValue; spacingDidChange() } }
    }
    
    public var axis: UILayoutConstraintAxis_ {
        get { return _axis }
        set { if _axis != newValue { _axis = newValue; axisDidChange() } }
    }
    
    
    public func addArrangedSubview(item: Any) {
        insertArrangedSubview(item: item, at: self.arrangedSubviews.count)
    }
    
    public func addArrangedSubviews(items: [Any]) {
        for item in items {
            if let array = item as? Array<Any> {
                for item in array {
                    self.addArrangedSubview(item: item)
                }
            } else {
                self.addArrangedSubview(item: item)
            }
        }
    }
    
    public func insertArrangedSubview(item: Any, at index: Int) {
        let sub = item is String ? StackSpring() : item
        
        if let view = sub as? UIView {
            
            self.insertSubview(view, at: index)
            self.arrangedSubviews.insert(view, at: index)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addObserver(self, forKeyPath: "hidden", options: [.new, .old], context: nil)
            
            #if swift(>=4.2)
            if view.layoutMargins == UIEdgeInsetsMake_(8, 8, 8, 8) {
                view.layoutMargins = UIEdgeInsets.zero
            }
            #else
            if UIEdgeInsetsEqualToEdgeInsets(view.layoutMargins, UIEdgeInsetsMake(8, 8, 8, 8)) {
                view.layoutMargins = UIEdgeInsets.zero
            }
            #endif
            
            
            if !view.isHidden {
                addAndActivateConstraintsForView(at: index)
            }
            
            self.disableLayoutMarginsAdjustment(for: view)
            
        } else if let array = sub as? [Any] {
            for i in 0..<array.count {
                insertArrangedSubview(item: array[i], at: min(index + i, self.arrangedSubviews.count))
            }
        }
        else {
            let spacing = CPKFloat(sub)
            
            if index == 0 {
                _headAttachSpace = spacing
                attachSpaceDidChangeForView(at: -1)
            } else {
                let previousView = self.arrangedSubviews[index - 1]
                previousView.cpkAttachSpacing = spacing
                attachSpaceDidChangeForView(at: index - 1)
            }
        }
    }
    
    public func removeArrangedSubview(view: UIView) {
        view.removeFromSuperview()
    }
    
    public func removeArrangedSubview(at index: Int) {
        let item = itemAt(index: index)
        if item != self { item.removeFromSuperview() }
    }
    
    //MARK: Override
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutMargins = UIEdgeInsets.zero
        self.disableLayoutMarginsAdjustment(for: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    public override class var layerClass: Swift.AnyClass {
//        return CPKTransformLayer.self
//    }
    
    public override func willRemoveSubview(_ subview: UIView) {
        #if swift(>=5)
        let index = self.arrangedSubviews.firstIndex(of: subview)
        #else
        let index = self.arrangedSubviews.index(of: subview)
        #endif
        
        if let index = index {
            removeAndDeactivateConstraintsForView(at: index)
            self.arrangedSubviews.remove(at: index)
            
            subview.removeObserver(self, forKeyPath: "hidden", context: nil)
            subview.cpkAttachSpacing = nil
        }
        
        super.willRemoveSubview(subview)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return systemLayoutSizeFitting(UILayoutFittingCompressedSize_)
    }
    

    
    //MARK: KVO
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        
        if keyPath == "hidden" {
            let oldValue = change?[.oldKey] as? Bool
            let newValue = change?[.newKey] as? Bool
            
            if newValue != oldValue {
                if let item = object as? UIView {
                    #if swift(>=5)
                    let index = self.arrangedSubviews.firstIndex(of: item)
                    #else
                    let index = self.arrangedSubviews.index(of: item)
                    #endif
                    
                    if let index = index {
                        
                        if item.isHidden {
                            removeAndDeactivateConstraintsForView(at: index)
                        } else {
                            addAndActivateConstraintsForView(at: index)
                        }
                    }
                }
            }
        }
    }
    
    
    
    //MARK: Constraints
    private func addAndActivateConstraintsForView(at index: Int) {
        if itemAt(index: index).isHidden {
            return;
        }
        
        var oldConstraints = [NSLayoutConstraint]()
        var newConstraints = [NSLayoutConstraint]()
        
        let previousIndex = previousVisibleViewIndexForView(at: index)
        let nextIndex = nextVisibleViewIndexForView(at: index)
        
        newConstraints.append(contentsOf: addAlignmentConstraint(at: index))
        newConstraints.append(contentsOf: addEnclosureConstraints(at: index))
        
        if let c = removeSpacingConstraintBetween(index1: previousIndex, index2: nextIndex) {
            oldConstraints.append(c)
        }
        
        if let c = addSpacingConstraintBetween(index1: previousIndex, index2: index) {
            newConstraints.append(c)
        }
        
        if let c = addSpacingConstraintBetween(index1: index, index2: nextIndex) {
            newConstraints.append(c)
        }
        
        NSLayoutConstraint.deactivate(oldConstraints)
        NSLayoutConstraint.activate(newConstraints)
        
        if let spring = itemAt(index: index) as? StackSpring {
            spring.axis = self.axis
            addAndActivateSpringConstraintsForSpring(at: index)
        }
    }
    
    private func addAndActivateConstraintsForAll() {
        addAndActivateAlignmentConstraintsForAll()
        addAndActivateSpacingConstraintsForAll()
        addAndActivateEnclosureConstraintsForAll()
        
        for (i, item) in self.arrangedSubviews.enumerated() {
            if let spring = item as? StackSpring {
                spring.axis = self.axis
                addAndActivateSpringConstraintsForSpring(at: i)
            }
        }
    }
    
    private func removeAndDeactivateConstraintsForView(at index: Int) {
        var oldConstraints = [NSLayoutConstraint]()
        
        if let c = removeAlignmentConstraint(at: index) {
            oldConstraints.append(c)
        }
        
        oldConstraints.append(contentsOf: removeEnclosureConstraints(at: index))
        NSLayoutConstraint.deactivate(oldConstraints)
        
        removeAndRebuildSpacingConstraints(at: index)
        removeAndDeactivateSpringConstraintsForSpring(at: index)
    }
    
     private func removeAndDeactivateAllConstriants() {
        removeAndDeactivateAllAlignmentConstriants()
        removeAndDeactivateAllEnclosureConstraints()
        removeAndDeactivateAllSpacingConstraints()
        removeAndDeactivateAllSpringsConstraints()
    }
    
    
    
    //MARK: Alignment
    @discardableResult
    private func addAlignmentConstraint(at index: Int) -> [NSLayoutConstraint] {
        var newConstraints = [NSLayoutConstraint]()
        var att = NSLayoutAttribute_.notAnAttribute
        
        if self.alignment == .fill {
            
            if self.axis == .vertical {
                newConstraints.append( makeConstraint(index, .leftMargin, .equal, -1, .leftMargin, 1, 0, 1000) )
                newConstraints.append( makeConstraint(index, .rightMargin, .equal, -1, .rightMargin, 1, 0, 1000) )
            } else {
                newConstraints.append( makeConstraint(index, .topMargin, .equal, -1, .topMargin, 1, 0, 1000) )
                newConstraints.append( makeConstraint(index, .bottomMargin, .equal, -1, .bottomMargin, 1, 0, 1000) )
            }
            
        } else {
            if self.axis == .vertical {
                if self.alignment == .left { att = .leftMargin }
                if self.alignment == .right { att = .rightMargin }
                if self.alignment == .center { att = .centerXWithinMargins }
                
            } else {
                if self.alignment == .top { att = .topMargin }
                if self.alignment == .bottom { att = .bottomMargin }
                if self.alignment == .center { att = .centerYWithinMargins }
                if self.alignment == .baseline { att = .lastBaseline }
            }
            
            newConstraints.append( makeConstraint(index, att, .equal, -1, att, 1, 0, kAlignmentPriority) )
        }
        
        
        self.alignmentConstraints.append(contentsOf: newConstraints)
        return newConstraints
    }
    
    private func addAndActivateAlignmentConstraintsForAll() {
        for i in 0..<self.arrangedSubviews.count {
            if !self.arrangedSubviews[i].isHidden {
                addAlignmentConstraint(at: i)
            }
        }
        NSLayoutConstraint.activate(self.alignmentConstraints)
    }
    
    private func removeAlignmentConstraint(at index :Int) -> NSLayoutConstraint? {
        let item = itemAt(index: index)
        
        if item != self {
            for (i, c) in self.alignmentConstraints.enumerated() {
                if c.firstItem === item || c.secondItem === item {
                    self.alignmentConstraints.remove(at: i)
                    return c
                }
            }
        }
        
        return nil
    }
    
    private func removeAndDeactivateAllAlignmentConstriants() {
        NSLayoutConstraint.deactivate(self.alignmentConstraints)
        self.alignmentConstraints.removeAll()
    }
    
    
    
    //MARK: Enclosure
    @discardableResult
    private func addEnclosureConstraints(at index: Int) -> [NSLayoutConstraint] {
        var newConstraints = [NSLayoutConstraint]()
        
        let enclosurePriority = kDefaultEnclosurePriority

        if self.axis == .vertical {
            newConstraints.append(makeConstraint(index, .leftMargin, .equal, -1, .leftMargin, enclosurePriority))
            newConstraints.append(makeConstraint(index, .leftMargin, .greaterThanOrEqual, -1, .leftMargin, 1000))
            newConstraints.append(makeConstraint(index, .rightMargin, .equal, -1, .rightMargin, enclosurePriority))
            newConstraints.append(makeConstraint(index, .rightMargin, .lessThanOrEqual, -1, .rightMargin, 1000))
            
        } else {
            newConstraints.append(makeConstraint(index, .topMargin, .equal, -1, .topMargin, enclosurePriority))
            newConstraints.append(makeConstraint(index, .topMargin, .greaterThanOrEqual, -1, .topMargin, 1000))
            
            var att: NSLayoutAttribute_ = .bottomMargin
            if self.alignment == .baseline {
                att = .lastBaseline
            }
            
            newConstraints.append(makeConstraint(index, att, .equal, -1, att, enclosurePriority))
            newConstraints.append(makeConstraint(index, att, .lessThanOrEqual, -1, att, 1000))
        }
        
        self.enslosureConstraints.append(contentsOf: newConstraints)
        return newConstraints
    }
    
    private func addAndActivateEnclosureConstraintsForAll() {
        for i in 0..<self.arrangedSubviews.count {
            if !self.arrangedSubviews[i].isHidden {
                addEnclosureConstraints(at: i)
            }
        }
        NSLayoutConstraint.activate(self.enslosureConstraints)
    }
    
    private func removeEnclosureConstraints(at index: Int) -> [NSLayoutConstraint] {
        var oldConstriants = [NSLayoutConstraint]()
        let item = itemAt(index: index)
        
        for i in stride(from: self.enslosureConstraints.count - 1, through: 0, by: -1) {
            let c = self.enslosureConstraints[i]
            if c.firstItem === item || c.secondItem === item {
                oldConstriants.append(c)
                self.enslosureConstraints.remove(at: i)
            }
        }
        
        return oldConstriants
    }
    
    private func removeAndDeactivateAllEnclosureConstraints() {
        NSLayoutConstraint.deactivate(self.enslosureConstraints)
        self.enslosureConstraints.removeAll()
    }
    
    
    
    //MARK: Spacing
    @discardableResult
    private func addSpacingConstraintBetween(index1: Int, index2: Int) -> NSLayoutConstraint? {
        let item1 = itemAt(index: index1)
        let item2 = itemAt(index: index2)
       
        if item1 === item2 {
            return nil
        }
        
        var att1 = NSLayoutAttribute_.notAnAttribute
        var att2 = NSLayoutAttribute_.notAnAttribute
        
        if self.axis == .vertical {
            att1 = (item1 == self ? .topMargin : .bottomMargin)
            att2 = (item2 != self ? .topMargin : .bottomMargin)
        } else {
            att1 = (item1 == self ? .leftMargin : .rightMargin)
            att2 = (item2 != self ? .leftMargin : .rightMargin)
        }
        
        var spacing: CGFloat = 0
        
        if item1 == self && _headAttachSpace != nil {
            spacing = -_headAttachSpace!
        }
        if let attachSpacing = item1.cpkAttachSpacing {
            spacing = -attachSpacing
        } else if item1 != self && item2 != self {
            spacing = -self.spacing
        }
        
        let c = makeConstraint(index1, att1, .equal, index2, att2, 1, spacing, kSpacingPriority)
        self.spacingConstraints.append(c)
        return c
    }
    
    private func addAndActivateSpacingConstraintsForAll() {
        if self.arrangedSubviews.count > 0 {
            var index1 = -1
            
            while index1 < self.arrangedSubviews.count {
                let index2 = nextVisibleViewIndexForView(at: index1)
                addSpacingConstraintBetween(index1: index1, index2: index2)
                index1 = index2
            }
            
            NSLayoutConstraint.activate(self.spacingConstraints)
        }
    }
    
    private func removeSpacingConstraintBetween(index1: Int, index2: Int) -> NSLayoutConstraint? {
        let item1 = itemAt(index: index1)
        let item2 = itemAt(index: index2)
        
        for (i, c) in self.spacingConstraints.enumerated() {
            if c.firstItem === item1 && c.secondItem === item2 {
                self.spacingConstraints.remove(at: i)
                return c
            }
        }
        
        return nil
    }
    
    private func removeAndDeactivateAllSpacingConstraints() {
        NSLayoutConstraint.deactivate(self.spacingConstraints)
        self.spacingConstraints.removeAll()
    }
    
    private func removeAndRebuildSpacingConstraints(at index: Int) {
        var oldConstraints = [NSLayoutConstraint]()
        var newConstarints = [NSLayoutConstraint]()
        
        let previousIndex = previousVisibleViewIndexForView(at: index)
        let nextIndex = nextVisibleViewIndexForView(at: index)
        
        if let c = removeSpacingConstraintBetween(index1: previousIndex, index2: index) {
            oldConstraints.append(c)
        }
        
        if let c = removeSpacingConstraintBetween(index1: index, index2: nextIndex) {
            oldConstraints.append(c)
        }
        
        if oldConstraints.count > 0 {
            if let c = addSpacingConstraintBetween(index1: previousIndex, index2: nextIndex) {
                newConstarints.append(c)
            }
        }
        
        NSLayoutConstraint.deactivate(oldConstraints)
        NSLayoutConstraint.activate(newConstarints)
    }
    
    
    private func attachSpaceDidChangeForView(at index: Int) {
        let item1 = itemAt(index: index)
        let item2 = itemAt(index: index + 1)
        
        if item1 == self && _headAttachSpace != nil {
            for c in self.spacingConstraints {
                if c.firstItem === item1 && c.secondItem === item2 {
                    c.constant = -_headAttachSpace!
                    break
                }
            }
        }
        
        if let spacing = item1.cpkAttachSpacing {
            for c in self.spacingConstraints {
                if c.firstItem === item1 && c.secondItem === item2 {
                    c.constant = -spacing
                    break
                }
            }
        }
    }
    
    
    
    //MARK: Spring
    private func addAndActivateSpringConstraintsForSpring(at index: Int) {
        var newConstraints = [NSLayoutConstraint]()
        
        for i in 0..<self.arrangedSubviews.count {
            let item = self.arrangedSubviews[i]
            
            if item is StackSpring && i != index {
                
                var hasConstraint = false
                let item1 = itemAt(index: i)
                let item2 = itemAt(index: index)
                
                for c in self.springConstraints {
                    if (c.firstItem === item1 && c.secondItem === item2) ||
                        (c.firstItem === item2 && c.secondItem === item1) {
                        hasConstraint = true
                        break
                    }
                }
                
                if !hasConstraint {
                    let att: NSLayoutAttribute_ = (self.axis == .vertical ? .height : .width)
                    let c = makeConstraint(i, att, .equal, index, att, 1, 0, kSpringPriority)
                    self.springConstraints.append(c)
                    newConstraints.append(c)
                }
            }
        }
        
        NSLayoutConstraint.activate(newConstraints)
    }
    
    private func removeAndDeactivateSpringConstraintsForSpring(at index: Int) {
        let item = itemAt(index: index)
        var oldConstraints = [NSLayoutConstraint]()
        
        for i in stride(from: self.springConstraints.count - 1, through: 0, by: -1) {
            let c = self.springConstraints[i]
            if c.firstItem === item || c.secondItem === item {
                self.springConstraints.remove(at: i)
                oldConstraints.append(c)
            }
        }
        
        NSLayoutConstraint.deactivate(oldConstraints)
    }
    
    private func removeAndDeactivateAllSpringsConstraints() {
        NSLayoutConstraint.deactivate(self.springConstraints)
        self.springConstraints.removeAll()
    }
    
    
    
    //MARK: Utils
    private func makeConstraint(_ index1: Int,
                                _ att1: NSLayoutAttribute_,
                                _ relation: NSLayoutRelation_,
                                _ index2: Int,
                                _ att2: NSLayoutAttribute_,
                                _ multiplier: CGFloat,
                                _ constant: CGFloat,
                                _ priority: UILayoutPriority) -> NSLayoutConstraint {
        
        let item1 = itemAt(index: index1)
        let item2 = itemAt(index: index2)
        
        let c = NSLayoutConstraint(item: item1,
                                   attribute: att1,
                                   relatedBy: relation,
                                   toItem: item2,
                                   attribute: att2,
                                   multiplier: multiplier,
                                   constant: constant)
        
        c.priority = priority
        return c
    }
    
    private func makeConstraint(_ index1: Int,
                                _ att1: NSLayoutAttribute_,
                                _ relation: NSLayoutRelation_,
                                _ index2: Int,
                                _ att2: NSLayoutAttribute_,
                                _ priority: UILayoutPriority) -> NSLayoutConstraint {
        
        return makeConstraint(index1, att1, relation, index2, att2, 1, 0, priority)
    }
    
    private func previousVisibleViewIndexForView(at index: Int) -> Int {
        for i in stride(from: index - 1, through: 0, by: -1) {
            let item = itemAt(index: i)
            if !item.isHidden { return i }
        }
        return -1
    }
    
    private func nextVisibleViewIndexForView(at index: Int) -> Int {
        for i in stride(from: index + 1, to: self.arrangedSubviews.count, by: 1) {
            let item = itemAt(index: i)
            if !item.isHidden { return i }
        }
        return self.arrangedSubviews.count
    }
    
    private func itemAt(index: Int) -> UIView {
        if index >= 0 && index < self.arrangedSubviews.count {
            return self.arrangedSubviews[index]
        } else {
            return self
        }
    }
    
    private func alignmentDidChange() {
        removeAndDeactivateAllAlignmentConstriants()
        removeAndDeactivateAllEnclosureConstraints()
        
        addAndActivateAlignmentConstraintsForAll()
        addAndActivateEnclosureConstraintsForAll()
    }
    
    private func spacingDidChange() {
        for c in self.spacingConstraints {
            let item1 = c.firstItem as! UIView
            let item2 = c.secondItem as! UIView
            
            if item1 != self && item2 != self {
                if let attachSpacing = item1.cpkAttachSpacing {
                    c.constant = -attachSpacing
                } else {
                    c.constant = -self.spacing
                }
            }
        }
    }
    
    private func axisDidChange() {
        removeAndDeactivateAllConstriants()
        addAndActivateConstraintsForAll()
    }
    
    private func disableLayoutMarginsAdjustment(for view: UIView) {
//        if #available(iOS 11, *) {
//            view.insetsLayoutMarginsFromSafeArea = false
//        }
        
        let sel = NSSelectorFromString("setInsetsLayoutMarginsFromSafeArea:")
        if view.responds(to: sel) {
            view.perform(sel, with: nil)
        }
    }
}



extension UIView {
    var cpkAttachSpacing: CGFloat? {
        get { return cpk_associatedObjectFor(key: #function) as? CGFloat }
        set { cpk_setAssociated(object: newValue, forKey: #function) }
    }
}


class CPKTransformLayer: CATransformLayer {
    override var isOpaque: Bool {
        set {}
        get { return true }
    }
}


public class StackSpring: UIView {
    private var _axis: UILayoutConstraintAxis_ = .horizontal
    
    fileprivate var axis: UILayoutConstraintAxis_ {
        get { return _axis }
        set {
            if _axis != newValue {
                _axis = newValue
                updateContentPriorities()
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        updateContentPriorities()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
    
    public override var backgroundColor: UIColor? {
        set {}
        get { return nil }
    }
    
    public override var isOpaque: Bool {
        set {}
        get { return true }
    }
    
    public override var clipsToBounds: Bool {
        set {}
        get { return false }
    }
    
    public override class var layerClass: Swift.AnyClass {
        return CPKTransformLayer.self
    }
    
    private func updateContentPriorities() {
        let horPriority = UILayoutPriority(self.axis == .horizontal ? 1 : 1000)
        let verPriority = UILayoutPriority(self.axis == .horizontal ? 1000 : 1)
        
        setContentHuggingPriority(horPriority, for: .horizontal)
        setContentHuggingPriority(verPriority, for: .vertical)
        setContentCompressionResistancePriority(horPriority, for: .horizontal)
        setContentCompressionResistancePriority(verPriority, for: .vertical)
    }
}


