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
    @IBOutlet var tableList: UITableView!
    
    @IBAction func logout(_ sender: Any) {
        logOutFunction()
        self.dismiss(animated:true, completion: nil)
    }
  
    override func viewDidAppear(_ animated: Bool) {
      let defaults = UserDefaults.standard
      print(defaults.string(forKey: "key"))
    }
    override func viewDidLoad() {
     listAllStudents { (students) in
         self.allStudents = students
         DispatchQueue.main.async {
                self.tableList.delegate = self
                self.tableList.reloadData()
            }
        }

        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStudents.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsCell")!
        let student = allStudents[(indexPath as NSIndexPath).row]
        
        let tLabel = student.firstName + " " + student.lastName
        let detailLabel = student.mediaUrl
        
        cell.textLabel?.text = tLabel
        cell.detailTextLabel?.text = detailLabel
      
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = allStudents[(indexPath as NSIndexPath).row]
        print(student.lattitude)
        print(student.longitude)
        if let url = URL(string:student.mediaUrl){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            }else{
                print(url)
            }
        }else{
            print(student.mediaUrl)
        }
    }
    
}
