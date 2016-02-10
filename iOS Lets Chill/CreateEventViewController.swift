//
//  CreateEventViewController.swift
//  iOS Lets Chill
//
//  Created by Jason Wong on 2016-02-07.
//  Copyright © 2016 Jason Wong. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var selectTypeButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        pickerView.hidden = true
        datePicker.hidden = true
        nameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func submitAction(sender: AnyObject) {
        
    }
    @IBAction func typeAction(sender: AnyObject) {
        if selectTypeButton.titleLabel!.text == "Select Type"{
            pickerView.hidden = false
            pickerView.userInteractionEnabled = true
            selectTypeButton.setTitle("Confirm", forState: .Normal)
        } else {
            
        }
    }
    @IBAction func inviteAction(sender: AnyObject) {
    }
    @IBAction func dateAction(sender: AnyObject) {
        if selectDateButton.titleLabel!.text == "Select Date"{
            datePicker.hidden = false
            datePicker.userInteractionEnabled = true
            selectDateButton.setTitle("Confirm", forState: .Normal)
        } else {
            datePicker.hidden = true
            selectDateButton.hidden = true
            selectDateButton.userInteractionEnabled = false
            
            let date = datePicker.date
            let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year]
            let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
            
            let timeString = String(components.day) + "/" + String(components.month) + "/" + String(components.year)
            
            dateLabel.text = timeString
            print(datePicker.date)
        }
        
    }

}
