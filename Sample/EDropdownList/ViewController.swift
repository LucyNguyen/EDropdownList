//
//  ViewController.swift
//  EDropdownList
//
//  Created by Lucy Nguyen on 11/10/15.
//  Copyright © 2015 econ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dropdownList: EDropdownList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initListValue()
        dropdownList.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initListValue() {
        let listValue = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        self.dropdownList.valueList = listValue
        
        // Uncomment this line to set your own dropdown color.
        //self.dropdownList.dropdownColor(UIColor.blackColor(), selectedColor: UIColor.lightGrayColor(), textColor: UIColor.whiteColor())
        self.dropdownList.dropdownMaxHeight(200)
    }
}

extension ViewController: EdropdownListDelegate {
    func didSelectItem(selectedItem: String, index: Int) {
        print("select: \(selectedItem), index: \(index)")
    }
}

