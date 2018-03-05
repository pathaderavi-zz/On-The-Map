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
    
    @IBAction func loginPressed(_ sender: Any) {
        let usernameText = userName.text
        let pass = password.text
        
        userName.resignFirstResponder()
        password.resignFirstResponder()
        DispatchQueue.main.async {
             loginFunction(username: usernameText!, password: pass!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate  = self
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
}

