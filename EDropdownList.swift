//
//  EDropdownList.swift
//  EDropdownList
//
//  Created by Lucy Nguyen on 11/10/15.
//  Copyright © 2015 econ. All rights reserved.
//
//  This class is used for creating a custom dropdown list in iOS in Swift.

import UIKit

@objc protocol EdropdownListDelegate {
    func didSelectItem(selectedItem: String, index: Int)
}

class EDropdownList: UIView {
    var dropdownButton: UIButton!
    var listTable: UITableView!
    var arrowImage: UIImageView!
    var valueList: [String]!
    var delegate: EdropdownListDelegate!
    var isShown: Bool! = false
    var selectedValue: String!
    
    var maxHeight: CGFloat = 200.0
    var cellSelectedColor = UIColor(red: 209.0 / 255.0, green: 209.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    var textColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupArrowImage()
        setupListTable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupButton()
        setupArrowImage()
        setupListTable()
    }
    
    // MARK: - Create interface.
    
    func setupButton() {
        dropdownButton = UIButton(type: UIButtonType.Custom)
        dropdownButton.backgroundColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        dropdownButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))
        dropdownButton.setTitle("Select", forState: UIControlState.Normal)
        dropdownButton.addTarget(self, action: "showHideDropdownList:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.dropdownButton)
    }
    
    func setupArrowImage() {
        arrowImage = UIImageView(image: UIImage(named: "DownArrow"))
        arrowImage.frame = CGRectMake(CGRectGetWidth(self.frame) - 3 * CGRectGetHeight(self.frame) / 4, CGRectGetHeight(self.frame) / 4, CGRectGetHeight(self.frame) / 2, CGRectGetHeight(self.frame) / 2)
        
        // Add the arrow image at the end of the button.
        self.addSubview(arrowImage)
    }
    
    func setupListTable() {
        let yLocation = CGRectGetMinY(self.frame) + CGRectGetHeight(dropdownButton.frame)
        listTable = UITableView(frame: CGRectMake(CGRectGetMinX(self.frame), yLocation, CGRectGetWidth(self.frame), 0))
        listTable.dataSource = self
        listTable.delegate = self
        listTable.userInteractionEnabled = true
        
        // Disable scrolling the tableview after it reach the top or bottom.
        listTable.bounces = false
    }
    
    // MARK: - User setting
    
    func dropdownColor(backgroundColor: UIColor, selectedColor: UIColor, textColor: UIColor) {
        listTable.backgroundColor = backgroundColor
        cellSelectedColor = selectedColor
        self.textColor = textColor
    }
    
    func dropdownColor(backgroundColor: UIColor, buttonColor: UIColor, selectedColor: UIColor, textColor: UIColor) {
        dropdownColor(backgroundColor, selectedColor: selectedColor, textColor: textColor)
        dropdownButton.backgroundColor = buttonColor
    }
    
    func dropdownMaxHeight(height: CGFloat) {
        maxHeight = height
    }
    
    // MARK: - Action
    
    func showHideDropdownList(sender: AnyObject) {
        if selectedValue != nil {
            dropdownButton.setTitle(selectedValue, forState: UIControlState.Normal)
        }
        
        if !isShown {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.superview?.addSubview(self.listTable)
                
                var height = self.tableviewHeight()
                
                if height > self.maxHeight {
                    height = self.maxHeight
                }
                
                var frame = self.listTable.frame
                frame.size.height = CGFloat(height)
                
                self.listTable.frame = frame
                }, completion: { (animated) -> Void in
                    self.arrowImage.image = UIImage(named: "UpArrow")
            })
        }
        else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                    let height = 0
                    var frame = self.listTable.frame
                    frame.size.height = CGFloat(height)
                
                    self.listTable.frame = frame
                }, completion: { (animated) -> Void in
                    self.listTable.removeFromSuperview()
                    self.arrowImage.image = UIImage(named: "DownArrow")
            })
        }
        
        isShown = !isShown
    }
}

// MARK: - UITableViewDataSource
extension EDropdownList: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = valueList?.count
        
        if count > 0 {
            return count!
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        // Set selected background color.
        let colorView = UIView()
        colorView.backgroundColor = cellSelectedColor
        cell.selectedBackgroundView = colorView
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = textColor
        cell.textLabel?.text = valueList?[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.respondsToSelector("setSeparatorInset:") {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        
        if tableView.respondsToSelector("setLayoutMargins:") {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableviewHeight() -> CGFloat {
        listTable.layoutIfNeeded()
        return listTable.contentSize.height
    }
}

// MARK: - UITableViewDelegate
extension EDropdownList: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get selected value.
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        selectedValue = selectedCell?.textLabel?.text
        
        // Hide the dropdown table and pass the selected value.
        showHideDropdownList(dropdownButton)
        delegate?.didSelectItem((selectedCell?.textLabel?.text)!, index: indexPath.row)
    }
}

