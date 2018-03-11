//
//  AddPinViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/9/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddPinViewController:UIViewController,UITextFieldDelegate,MKMapViewDelegate{
    var latt:Double?
    var long:Double?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textFieldMap: UITextField!
    
    @IBAction func submitActionButton(_ sender: Any) {
        
        let mapHidden = mapView.isHidden
        let searchRequest = MKLocalSearchRequest()
        let mapStringQuery = textFieldMap.text
        searchRequest.naturalLanguageQuery = mapStringQuery
        let activeSearch = MKLocalSearch(request:searchRequest)
        if mapHidden{
        activeSearch.start { (response, error) in
            if response == nil{
                if(self.textFieldMap.text?.count == 0){
                    self.textFieldMap.resignFirstResponder()
                    self.showAlert(title: "Location Field Blank", message: "Please enter Location")
                    return
                }
                print("Error") // Show Alert
            }else{
                if(self.textFieldMap.text?.count == 0){
                    self.textFieldMap.resignFirstResponder()
                    self.showAlert(title: "Location Field Blank", message: "Please enter Location")
                    return
                }
                self.textFieldMap.isHidden = true
                self.mapView.isHidden = false
                self.linkTextField.isHidden = false
                self.questionLabel.isHidden = true
                
                let lattitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                self.latt = lattitude
                self.long = longitude
               
                let annotation = MKPointAnnotation()
                annotation.title = mapStringQuery
                annotation.coordinate = CLLocationCoordinate2DMake(lattitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                let coOrdinate = CLLocationCoordinate2DMake(lattitude!, longitude!)
                let span = MKCoordinateSpanMake(0.4, 0.4)
                let region = MKCoordinateRegionMake(coOrdinate, span)
                self.mapView.setRegion(region, animated: true)
            }
            }
            
        }else{
            if(self.linkTextField.text?.count == 0){
                self.textFieldMap.resignFirstResponder()
                self.showAlert(title: "Linkn Field Blank", message: "Please enter Some text")
                return
            }
            let defaults = UserDefaults.standard
            let key = defaults.string(forKey: "key")!
            let fname = defaults.string(forKey: "fname")!
            let lname = defaults.string(forKey: "lname")!
            let mediaUrl = linkTextField.text
    
            postStudentLocation(key: key,fname: fname,lname: lname, mapString: mapStringQuery!, mediaUrl: mediaUrl!, latt: self.latt!,long:self.long!, completionHandler: { (success) in
                print("Location Post Successfull")
                self.dismiss(animated: true, completion: nil)
            })
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
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
}
