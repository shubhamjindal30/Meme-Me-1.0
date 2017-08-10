//
//  textFieldDelegate.swift
//  MemeMe
//
//  Created by Shubham Jindal on 07/02/17.
//  Copyright © 2017 sjc. All rights reserved.
//


import Foundation
import UIKit

// MARK: - textFieldDelegate : NSObject, UITextFieldDelegate

class textFieldDelegate : NSObject, UITextFieldDelegate {
    
    //Making the text field blank when user clicks on it
    func textFieldDidBeginEditing(_ topField: UITextField) {
        if topField.text=="TOP" || topField.text=="BOTTOM" {
        topField.text = ""
    }
    }
    
    //Setting the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
}
}
