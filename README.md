# EDropdownList
A custom dropdown list written in Swift 2.

# How to use:
Simply import EDropdownList.swift file into your project.

Drap and drop a UIView to your storyboard, set it class to EDropdownList.
The size of this view is also dropdown button size. You can set the max size for dropdown list later.

Populate data for the dropdown list:

    let listValue = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    dropdownList.valueList = listValue

Set the max height for dropdown list (not include the button):

    dropdownList.dropdownMaxHeight(150)

The default color can be changed by calling one of these methods:

    dropdownColor(backgroundColor:, selectedColor:, textColor:)
    dropdownColor(backgroundColor:, buttonColor:, selectedColor:, textColor:)
    
You also need to provide the up and down arrow images, please check the sample project for more details.

To get the selected value in the list, set delegate and implement this method:

    dropdownList.delegate = self
    
    func didSelectItem(selectedItem: String, index: Int) {
        print("select: \(selectedItem), index: \(index)")
    }

Now your dropdown list is ready to use.

# Screenshots:
![Alt text](https://github.com/LucyNguyen/EDropdownList/blob/master/Screenshots/screenshot.png?raw=true "")

# License:
This component is under MIT License.
