//
//  AddPinViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/9/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController:UIViewController,UITextFieldDelegate,MKMapViewDelegate{
    var latt:Double?
    var long:Double?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textFieldMap: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    //MARK - Do Internet operations on separate thread
    @IBAction func submitActionButton(_ sender: Any) {
        
        let mapHidden = mapView.isHidden
        let searchRequest = MKLocalSearchRequest()
        let mapStringQuery = textFieldMap.text
        searchRequest.naturalLanguageQuery = mapStringQuery
        let activeSearch = MKLocalSearch(request:searchRequest)
        
        if mapHidden{
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { () -> Void in
                activeSearch.start { (response, error) in
                    if response == nil{
                        DispatchQueue.main.async {
                            self.loadingIndicator.isHidden = true
                            self.loadingIndicator.stopAnimating()
                            if(self.textFieldMap.text?.count == 0){
                                self.textFieldMap.resignFirstResponder()
                                self.showAlert(title: "Location Field Blank", message: "Please enter Location")
                                
                            }else{
                                self.textFieldMap.resignFirstResponder()
                                self.showAlert(title: "Location Cannot be found", message: "Please enter Different Location")
                            }
                            return
                        }
                    }else{
                        DispatchQueue.main.async {
                            if(self.textFieldMap.text?.count == 0){
                                self.textFieldMap.resignFirstResponder()
                                self.showAlert(title: "Location Field Blank", message: "Please enter Location")
                                return
                            }
                            self.loadingIndicator.isHidden = true
                            self.loadingIndicator.stopAnimating()
                            self.textFieldMap.isHidden = true
                            self.mapView.isHidden = false
                            self.linkTextField.isHidden = false
                            self.questionLabel.isHidden = true
                            self.submitButton.setTitle("Submit", for: .normal)
                        }
                        let lattitude = response?.boundingRegion.center.latitude
                        let longitude = response?.boundingRegion.center.longitude
                        self.latt = lattitude
                        self.long = longitude
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = mapStringQuery
                        annotation.coordinate = CLLocationCoordinate2DMake(lattitude!, longitude!)
                        DispatchQueue.main.async {
                            self.mapView.addAnnotation(annotation)
                        }
                        let coOrdinate = CLLocationCoordinate2DMake(lattitude!, longitude!)
                        let span = MKCoordinateSpanMake(0.4, 0.4)
                        let region = MKCoordinateRegionMake(coOrdinate, span)
                        self.mapView.setRegion(region, animated: true)
                    }
                }
            }
            
        }else{
            
            if(self.linkTextField.text?.count == 0){
                self.textFieldMap.resignFirstResponder()
                self.showAlert(title: "Linkn Field Blank", message: "Please enter Some text")
                return
            }
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
            
            let defaults = UserDefaults.standard
            let key = defaults.string(forKey: "key")!
            let fname = defaults.string(forKey: "fname")!
            let lname = defaults.string(forKey: "lname")!
            let mediaUrl = self.linkTextField.text
            DispatchQueue.global(qos: .userInitiated).async { () -> Void in
                postStudentLocation(key: key,fname: fname,lname: lname, mapString: mapStringQuery!, mediaUrl: mediaUrl!, latt: self.latt!,long:self.long!, completionHandler: { (success) in
                    if(success){
                        self.dismiss(animated: true, completion: nil)
                        DispatchQueue.main.async {
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.isHidden = true
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.textFieldMap.resignFirstResponder()
                            self.showAlert(title: "Cannot be Posted", message: "Please try Again")
                        }}
                })
                
            }
        }
        
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        linkTextField.isHidden = true
        mapView.isHidden = true
        textFieldMap.tag = 1
        linkTextField.tag = 2
        textFieldMap.delegate = self
        linkTextField.delegate = self
        loadingIndicator.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.frame.origin.y = 0
        if( textField.text?.count == 0 ){
            if(textField.tag == 1){
                textField.resignFirstResponder()
                showAlert(title: "Location Field Blank", message: "Please enter Location")
            }
            else{
                textField.resignFirstResponder()
                showAlert(title: "Linkn Field Blank", message: "Please enter Some text")
                
            }
        }else{
            textField.resignFirstResponder()
            
        }
        return true
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        var orientation = UIDevice.current.orientation
        var orientationBoolean:Bool
        orientationBoolean = ((orientation == .landscapeRight) || (orientation == .landscapeLeft))
        if(orientationBoolean){
            var textFieldActive:Bool
            textFieldActive = textFieldMap.isHidden
            if textFieldActive == true {
                view.frame.origin.y -= getKeyboardHeight(notification) - linkTextField.frame.height
            }else{
                view.frame.origin.y -= getKeyboardHeight(notification) - textFieldMap.frame.height
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
    
}
