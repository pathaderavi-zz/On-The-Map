//
//  ListViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/7/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{
    var allStudents = [Student]()
    @IBAction func logout(_ sender: Any) {
        logOutFunction()
        self.dismiss(animated:true, completion: nil)
    }
    override func viewDidLoad() {
        listAllStudents { (students) in
         
        }
    }
    
    
}
