//
//  CreateEventViewController.swift
//  iOS Lets Chill
//
//  Created by Jason Wong on 2016-02-07.
//  Copyright © 2016 Jason Wong. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBAction func submitAction(sender: AnyObject) {
    }
    @IBAction func typeAction(sender: AnyObject) {
    }
    @IBOutlet var selectDateButton: UIButton!
    @IBOutlet var selectTypeButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBAction func inviteAction(sender: AnyObject) {
    }
    @IBAction func dateAction(sender: AnyObject) {
        if selectDateButton.titleLabel!.text == "Select Date"{
            datePicker.hidden = false;
            datePicker.userInteractionEnabled = true;
            selectDateButton.setTitle("Confirm", forState: .Normal)
        } else {
            print(datePicker.date)
        }
        
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        pickerView.hidden = true;
        datePicker.hidden = true;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
