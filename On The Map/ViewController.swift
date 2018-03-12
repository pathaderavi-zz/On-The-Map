//
//  ViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/5/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var passwordFieldActive:Bool = false
    @IBAction func loginPressed(_ sender: Any) {
        let usernameText = userName.text
        let pass = password.text
        if usernameText?.count == 0 || pass?.count == 0{
            showAlert(title: "Username / Password Blank", message: "Username / Password fields cannot be left blank.")
            return
        }
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            loginFunction(username: usernameText!, password: pass!) {(success,key,conError) in
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    if(success){
                        let controller: TabBarViewController
                        controller = self.storyboard?.instantiateViewController(withIdentifier:"loginSuccess") as! TabBarViewController
                        self.present(controller,animated: true,completion: nil)
                        let defaults = UserDefaults.standard
                        defaults.set(key, forKey: "key")
                        
                    }else{
                        if(conError){
                            self.showAlert(title: "Failed to Connect", message: "Please Check internet connection and try again.")
                        }else{
                            self.showAlert(title: "Login Failed", message: "Please Enter the correct details.")
                            //TODO -- SHOW ALERT
                        }
                    }
                }
            }
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.frame.origin.y = 0
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.tag = 1
        password.tag = 2
        userName.delegate = self
        password.delegate  = self
        loadingIndicator.isHidden = true
    }
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if passwordFieldActive{
            let orientation = UIDevice.current.orientation
            var orientationBoolean:Bool
            orientationBoolean = ((orientation == .landscapeRight) || (orientation == .landscapeLeft))
            if(orientationBoolean){
                view.frame.origin.y -= getKeyboardHeight(notification) - password.frame.minY
                
            }
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            passwordFieldActive = true
        }else{
            passwordFieldActive = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

