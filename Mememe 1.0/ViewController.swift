//
//  ViewController.swift
//  Mememe 1.0
//
//  Created by Sayali Joshi on 24/03/20.
//  Copyright © 2020 Sayali Joshi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    // MARK: Variables and arrtributes declaration
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var memedImage: UIImage!
    
    let memeTextAttributes:[NSAttributedString.Key:Any] = [
           NSAttributedString.Key.strokeColor : UIColor.black,
           NSAttributedString.Key.foregroundColor : UIColor.white,
           NSAttributedString.Key.font : UIFont.init(name: "impact", size: 30.0)!
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.black
        setTextFieldProperties(topTextField)
        setTextFieldProperties(bottomTextField)
        subscribeToKeyboardNotifications()
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        shareButton.isEnabled = false
    }
    
    // MARK: - Textfield functions
    
    func setTextFieldProperties(_ textField : UITextField) {
           textField.text =  textField == topTextField ? "TOP" :  "BOTTOM"
           textField.backgroundColor = UIColor.clear
           textField.adjustsFontSizeToFitWidth = true
           textField.defaultTextAttributes = memeTextAttributes
           textField.textAlignment = NSTextAlignment.center
           textField.delegate = self
       }
       
       func subscribeToKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       func getKeyboardHeight(_ notification:Notification) -> CGFloat {
           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
           return keyboardSize.cgRectValue.height
       }
       
       @objc func keyboardWillShow(_ notification : Notification) {
           if bottomTextField.isEditing && view.frame.origin.y == 0 {
               view.frame.origin.y -= getKeyboardHeight(notification)
           }
       }
       
       @objc func keyboardWillHide(_ notification:Notification){
           if bottomTextField.isEditing && view.frame.origin.y != 0 {
               view.frame.origin.y = 0
           }
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       

       func textFieldDidBeginEditing(_ textField: UITextField) {
           if textField == topTextField && textField.text == "TOP" {
               textField.text = ""
           }
           if textField == bottomTextField && textField.text == "BOTTOM" {
               textField.text = ""
           }
       }
    
    //MARK: Image functions
    
    @IBAction func cameraClicked(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
              imagePickerController.delegate = self
              imagePickerController.sourceType = .camera
              present(imagePickerController, animated: true, completion: nil)
    }
       
    @IBAction func pickImage(_ sender: Any) {
        let imagePickercontroller = UIImagePickerController()
               imagePickercontroller.delegate = self
               imagePickercontroller.sourceType = .photoLibrary
        present(imagePickercontroller, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        setVisibilityOfBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setVisibilityOfBars(false)
        return memedImage
    }
    
    func setVisibilityOfBars(_ val : Bool) {
        toolBar.isHidden = val
        navBar.isHidden = val
    }
    
    func save() {
        _ = MemeMe(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imageView.image!, memedImage: self.memedImage)
                   print("image saved")
    }
    
    // MARK: Share image or cancel functions
    
    @IBAction func shareMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage!]
            , applicationActivities: nil)
        self.present(controller,animated: true,completion: nil)
        controller.completionWithItemsHandler = {(activityType, completed,items,error) in
            if !completed {
                print("cancelled")
                return
            }
            self.save()
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        imageView.image = nil
        setTextFieldProperties(topTextField)
        setTextFieldProperties(bottomTextField)
        shareButton.isEnabled = false
    }
    
}

