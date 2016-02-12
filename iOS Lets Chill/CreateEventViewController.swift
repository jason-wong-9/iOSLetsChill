//
//  CreateEventViewController.swift
//  iOS Lets Chill
//
//  Created by Jason Wong on 2016-02-07.
//  Copyright © 2016 Jason Wong. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var selectTypeButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var pickerDataSource = ["Restaurant", "Cafe", "Gym", "Movie Theater", "Shopping Mall", "Bank", "Bowling Alley"]
    
    override func viewDidLoad() {

        super.viewDidLoad()
        pickerView.hidden = true
        datePicker.hidden = true
        nameTextField.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func submitAction(sender: AnyObject) {
        if typeLabel.text != "" && dateLabel.text != "" {
            
        }
    }
    @IBAction func typeAction(sender: AnyObject) {
        if selectTypeButton.titleLabel!.text == "Select Type"{
            pickerView.hidden = false
            pickerView.userInteractionEnabled = true
            selectTypeButton.setTitle("Confirm", forState: .Normal)
        } else {
            pickerView.hidden = true
            pickerView.userInteractionEnabled = false
            selectTypeButton.hidden = true
            selectTypeButton.userInteractionEnabled = false
            typeLabel.text = pickerDataSource[pickerView.selectedRowInComponent(0)]
            
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
            datePicker.userInteractionEnabled = false
            selectDateButton.hidden = true
            selectDateButton.userInteractionEnabled = false
            
            let date = datePicker.date
            let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
            let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
            
            let timeString = String(components.day) + "/" + String(components.month) + "/" + String(components.year) + " " + String(components.hour) + ":" + String(components.minute)
            
            dateLabel.text = timeString
            print(datePicker.date)
        }
        
    }

}
