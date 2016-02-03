//
//  PhoneVerficationViewController.swift
//  iOS Lets Chill
//
//  Created by Jason Wong on 2016-02-03.
//  Copyright © 2016 Jason Wong. All rights reserved.
//

import UIKit
import Firebase

class PhoneVerficationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var confirmButton: UIButton!
    
    @IBOutlet var spinnerActivity: UIActivityIndicatorView!
    
    @IBAction func confirmAction(sender: AnyObject) {
        
        if (self.phoneTextField.text?.characters.count == 0){
            
            let alertController = UIAlertController(title: "Phone Verifcation Required", message:
                "Missing Phone Number for verifcation!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else if (self.phoneTextField.text?.characters.count == 14){
            self.phoneTextField.enabled = false
            self.confirmButton.hidden = true
            spinnerActivity.startAnimating()
        } else {
            let alertController = UIAlertController(title: "Phone Verifcation Error", message:
                "Phone Number is invalid.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        let bg_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(bg_queue, {
            // your network request here...
            
            dispatch_async(dispatch_get_main_queue(), {
                //self.phoneTextField.enabled = true
            })
        })
        
    }
    
    //let ref = Firebase(url: "https://letschill.firebaseio.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == phoneTextField)
        {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
