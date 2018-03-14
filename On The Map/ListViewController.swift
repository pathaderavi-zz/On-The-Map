//
//  ListViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/7/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController{
    var allStudents = [Student]()
    @IBOutlet var tableList: UITableView!
    
    @IBAction func addPin(_ sender: Any) {
        let controller: AddPinViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier:"addPin") as! AddPinViewController
        let navVC = UINavigationController(rootViewController:controller)
        self.present(navVC,animated: true,completion: nil)
    }
    @IBAction func logout(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            logOutFunction(){(success) in
                if(success){
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.showAlert(title: "Failed!", message: "Unable to Logout, Try Again")
                }
            }
        }
        self.dismiss(animated:true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.allStudents = StudentDataSource.sharedInstance().allStudents
    }
    override func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            listAllStudents { (students,success) in
                if(success){
                    self.allStudents = students
                    DispatchQueue.main.async {
                        self.tableList.delegate = self
                        self.tableList.reloadData()
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        self.showAlert(title: "Failed", message: "Unable to download Students data.")
                    }
                }
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
        cell.imageView?.image = #imageLiteral(resourceName: "pin-icon")
        tableView.deselectRow(at: indexPath, animated: true)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = allStudents[(indexPath as NSIndexPath).row]
        print(student.lattitude)
        print(student.longitude)
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = URL(string:student.mediaUrl){
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            }else{
                showAlert(title: "Link Invalid", message: "Link Cannot be opened.")
            }
        }else{
            showAlert(title: "Link Invalid", message: "Link Cannot be opened.")
        }
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
