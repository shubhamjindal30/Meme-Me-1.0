//
//  ViewController.swift
//  MemeMe
//
//  Created by Shubham Jindal on 16/01/17.
//  Copyright © 2017 sjc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //Setting the iboutlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //Creating a variable for text field delegate
    let textDelegate = textFieldDelegate()
    
    //Enabling camera button if camera is available and enabling of share button
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imageView.image != nil
        
    }
    //Hiding the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //Unsubscribing from notification
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the attributes for both the text fields
        attributes(textField: topField)
        attributes(textField: bottomField)
        
        //Setting the delegates for text fields
        self.bottomField.delegate = textDelegate
        self.topField.delegate=textDelegate
        
    }
    //MARK: -Function to set attributes of text fields
    func attributes(textField: UITextField)
    {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = UITextBorderStyle.none
    }

    

    //Picking image from album
    @IBAction func pickImage(_ sender: Any) {
        let newImage=UIImagePickerController()
        newImage.sourceType = .photoLibrary
        newImage.delegate=self
        present(newImage, animated: true, completion: nil)
        

    }

    //Taking image from camera
    @IBAction func pickImageCamera(_ sender: Any) {
        let newImage=UIImagePickerController()
        newImage.sourceType = .camera
        newImage.delegate=self
        present(newImage, animated: true, completion: nil)
    }
    
    @IBAction func bottom(_ sender: Any) {
        subscribeToKeyboardNotifications()
    }
    //Setting the image properties
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picker = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.contentMode = .scaleAspectFit
            imageView.image = picker
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -Method for sliding the view
    func keyboardWillShow(_ notification:Notification) {
        if bottomField.isFirstResponder {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    //MARK: -Methods for subscribing and unsubscribing notifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    //MARK: -Meme text attributes
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -6]
    
    
    //struct which contains the text fields, image selected and the memed image
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        
    }
    
    //MARK: -Method for generating the meme
    func generateMemedImage() -> UIImage {
        
        //hiding the toolbar and navigation bar
        toolBar.isHidden=true
        navBar.isHidden=true
        
        //Combining the image and the text fields
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Enabling the toolbar and navigation bar again
        toolBar.isHidden=false
        navBar.isHidden=false
        return memedImage
    }

    //Saving the meme
    func save() {
        let memedImage = generateMemedImage()
       _ = Meme(topText: topField.text!, bottomText: bottomField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    //MARK: -The activity view
    @IBAction func activityView(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, completed, items, error in
            if completed{
                
                //Saving the image
                self.save()
                
                
                //To dismiss view controller
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        //presenting the activity viewController
        self.present(controller, animated: true, completion: nil)
    }
    //Setting the cancel button to start making a new meme
    @IBAction func cancelButton(_ sender: Any) {
        imageView.image = nil
        topField.text="TOP"
        bottomField.text="BOTTOM"
        shareButton.isEnabled=false
    }
    
}

