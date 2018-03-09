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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textFieldMap: UITextField!
    
    @IBAction func submitActionButton(_ sender: Any) {
        textFieldMap.isHidden = true
        mapView.isHidden = false
        linkTextField.isHidden = false
        questionLabel.isHidden = true
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = textFieldMap.text
        let activeSearch = MKLocalSearch(request:searchRequest)
        activeSearch.start { (response, error) in
            if response == nil{
                print("Error")
            }else{
                let lattitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = "Search" //TODO
                annotation.coordinate = CLLocationCoordinate2DMake(lattitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                let coOrdinate = CLLocationCoordinate2DMake(lattitude!, longitude!)
                let span = MKCoordinateSpanMake(0.4, 0.4)
                let region = MKCoordinateRegionMake(coOrdinate, span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        linkTextField.isHidden = true
        mapView.isHidden = true
        textFieldMap.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
