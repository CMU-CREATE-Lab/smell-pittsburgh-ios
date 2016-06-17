//
//  FirstViewController.swift
//  SmellPittsburgh Prototype
//
//  Created by Mike Tasota on 4/28/16.
//  Copyright © 2016 Mike Tasota. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var smellDescriptionTextField: UITextField!
    @IBOutlet weak var symptomsTextField: UITextField!
    @IBOutlet weak var smellValueSegmentedControl: UISegmentedControl!
    @IBOutlet weak var viewTextFields: UIView!
    
    
    private func sendPost(value: Int, description: String, feelingsSymptoms: String, latitude: Double, longitude: Double, horizontalAccuracy: Double, verticalAccuracy: Double, responseHandler: (url: NSURL?, response: NSURLResponse?, error: NSError?) -> Void ) {
        // create request
        let request = HttpHelper.generateRequest(Constants.API_URL + "/api/v1/smell_reports", httpMethod: "POST")
        let params:[String: String] = [
            "user_hash": GlobalHandler.sharedInstance.settingsHandler.userHash,
            "latitude" : latitude.description,
            "longitude" : longitude.description,
            "smell_value" : value.description,
            "smell_description" : description,
            "feelings_symptoms" : feelingsSymptoms,
            "horizontal_accuracy" : horizontalAccuracy.description,
            "vertical_accuracy" : verticalAccuracy.description
        ]
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
        
        // send request
        GlobalHandler.sharedInstance.httpRequestHandler.sendJsonRequest(request, completionHandler: responseHandler)
    }
    
    
    @objc private func segmentedControlDidChange() {
        let value = smellValueSegmentedControl.selectedSegmentIndex
        if value < 0 {
            smellValueSegmentedControl.tintColor = nil
        } else {
            smellValueSegmentedControl.tintColor = Constants.SMELL_COLORS[value]
        }
    }
    
    
    // MARK: UIViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set text field delegates (we want to control RETURN key)
        smellDescriptionTextField.delegate = self
        symptomsTextField.delegate = self
        GlobalHandler.sharedInstance.firstView = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    override func viewWillAppear(animated: Bool) {
        // clear values
        smellValueSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        smellDescriptionTextField.text = ""
        symptomsTextField.text = ""
        GlobalHandler.sharedInstance.locationHandler.start()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        GlobalHandler.sharedInstance.locationHandler.stop()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITextFieldDelegate
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Keyboarding nonsense
    
    
    var previousConstant: CGFloat?
    var keyboardIsDisplayed = false
    var movedTextFieldView = false
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstView: UIView!
    
    
    func keyboardWillShow(notification : NSNotification) {
        if keyboardIsDisplayed {
            return;
        }
        keyboardIsDisplayed = true
        
        let screenSize = UIScreen.mainScreen().bounds.height
        let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height
        if viewTextFields.frame.origin.y + viewTextFields.bounds.height + keyboardSize! > screenSize {
            firstView.hidden = true
            movedTextFieldView = true
            
            previousConstant = self.topConstraint.constant
            self.topConstraint.constant -= keyboardSize!
        }
    }
    
    
    func keyboardWillHide(notification : NSNotification) {
        keyboardIsDisplayed = false
        
        if movedTextFieldView {
            firstView.hidden = false
            movedTextFieldView = false
            if let previousConstant = previousConstant {
                self.topConstraint.constant = previousConstant
            }
        }
    }
    
    
    // MARK: UI Actions
    
    
    @IBAction func sendSmellReport(sender: AnyObject) {
        let location = GlobalHandler.sharedInstance.locationHandler.closestSampledLocation
        
        if smellValueSegmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            NSLog("ERROR - no value selected for smell.")
            let dialog = UIAlertView.init(title: "Missing Value", message: "Please select a value for your reported smell (1-5).", delegate: nil, cancelButtonTitle: "OK")
            dialog.show()
        } else if location?.latitude == nil || location?.longitude == nil {
            NSLog("ERROR - current location not available.")
            let dialog = UIAlertView.init(title: "Location Services", message: "Current location could not be discovered; please check settings.", delegate: nil, cancelButtonTitle: "OK")
            dialog.show()
        } else {
            let value = smellValueSegmentedControl.selectedSegmentIndex + 1
            let description = smellDescriptionTextField.text!
            let feelingsSymptoms = symptomsTextField.text!
            let latitude = location!.latitude
            let longitude = location!.longitude
            let horizontalAccuracy = location!.hacc
            let verticalAccuracy = location!.vacc
            
            NSLog("Form to submit: smell_value=\(value), smell_description='\(description)', feelings_symptoms='\(feelingsSymptoms)', latitude=\(latitude), longitude=\(longitude)")
            
            func responseHandler(url: NSURL?, response: NSURLResponse?, error: NSError?) -> Void {
                NSLog("Got HTTP response")
            }
            
            sendPost(value, description: description, feelingsSymptoms: feelingsSymptoms, latitude: latitude, longitude: longitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, responseHandler: responseHandler)
            
            self.tabBarController?.selectedIndex = 1
        }
    }

}

