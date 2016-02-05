//
//  PhoneVerficationViewController.swift
//  iOS Lets Chill
//
//  Created by Jason Wong on 2016-02-03.
//  Copyright © 2016 Jason Wong. All rights reserved.
//

import UIKit
import Firebase
import SwiftRequest

class PhoneVerficationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var enterLabel: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var confirmButton: UIButton!
    
    @IBOutlet var spinnerActivity: UIActivityIndicatorView!
    
    let code = arc4random_uniform(8999) + 1000
    
    var numberTo = ""
    
    @IBAction func confirmAction(sender: AnyObject) {
        if self.confirmButton.titleLabel!.text == "Confirm" {
            if self.phoneTextField.text?.characters.count == 0 {
                
                let alertController = UIAlertController(title: "Phone Verifcation Required", message:
                    "Missing Phone Number for verifcation!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else if self.phoneTextField.text?.characters.count == 14{
                self.phoneTextField.enabled = false
                self.confirmButton.hidden = true
                self.confirmButton.userInteractionEnabled = false
                spinnerActivity.startAnimating()
                numberTo = self.phoneFormatToString(self.phoneTextField.text!)
                
                print(code)
                let data = [
                    "To" : numberTo,
                    "From" : "+17786550640",
                    "Body" : String(code) as String
                ]
                print(numberTo)
                
                let swiftRequest = SwiftRequest()
                
                swiftRequest.post("https://api.twilio.com/2010-04-01/Accounts/ACd49f32975885a2d612c8e32598197df7/Messages",
                    auth: ["username" : "ACd49f32975885a2d612c8e32598197df7", "password" : "8100a9c8b51620a1e769013d91101401"],
                    data: data,
                    callback: {err, response, body in
                        if err == nil {
                            print("Success: (response)")
                            
                        } else {
                            print("Error: (err)")
                            
                            let alertController = UIAlertController(title: "Problem with SMS", message:
                                "Validation messsage was not successfully sent.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                            self.confirmButton.hidden = false
                            self.confirmButton.userInteractionEnabled = true
                            
                            self.phoneTextField.enabled = true
                        }
                })
                self.spinnerActivity.stopAnimating()
                self.confirmButton.hidden = false
                self.confirmButton.userInteractionEnabled = true
//                self.phoneTextField.enabled = true
                self.confirmButton.setTitle("Next", forState: .Normal)
            } else {
                let alertController = UIAlertController(title: "Phone Verifcation Error", message:
                    "Phone Number is invalid.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }

        } else if self.confirmButton.titleLabel!.text == "Next"{
            
            self.phoneTextField.placeholder = "XXXX"
            
            self.phoneTextField.text = ""
            
            self.phoneTextField.enabled = true
            
            self.enterLabel.text = "Enter Validation Code"
            
            self.confirmButton.setTitle("OK", forState: .Normal)
            
            
            
        } else {
            if self.phoneTextField.text == "" {
                let alertController = UIAlertController(title: "Phone Verifcation Required", message:
                    "Missing Verification Code!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else if self.phoneTextField.text == String(code){
                // create firebase user
                
                let ref = Firebase(url: "https://letschill.firebaseio.com")
                var index = numberTo.startIndex.advancedBy(2)
                var email: String = numberTo.substringFromIndex(index)
                print(email)
                email += "@jasonkcwong.com"
                print(email)
                ref.createUser(email, password: String(code),
                    withValueCompletionBlock: { error, result in
                        
                        if error != nil {
                            // There was an error creating the account
                        } else {
                            let uid = result["uid"] as? String
                            print("Successfully created user account with uid: \(uid)")
                        }
                })
                
            } else {
                let alertController = UIAlertController(title: "Invalid", message:
                    "You have entered an invalid code for verifcation", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    func phoneFormatToString(string: String) -> String{
        var str = "+1"
        for char in string.characters{
            if char != "(" && char != ")" && char != "-" && char != " " {
                str.append(char)
            }
        }
        return str
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // Prevent invalid character input, if keyboard is numberpad
        if textField.keyboardType == UIKeyboardType.PhonePad
        {

            if ((string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)) != nil)
            {
                return false;
            }
        }
        if (textField.placeholder == "(XXX) XXX-XXXX")
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
        } else if textField.placeholder == "XXXX"{
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joinWithSeparator("") as NSString
            
            let length = decimalString.length
            
            if (length > 4) {
                return false
            }
            return true
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
