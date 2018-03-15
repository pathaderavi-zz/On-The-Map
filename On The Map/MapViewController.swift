//
//  MapViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/7/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    var allStudents = [Student]()
    @IBOutlet weak var mapView: MKMapView!
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.allStudents = StudentDataSource.sharedInstance().allStudents
        viewDidLoad()   
    }
    @IBAction func addPinButton(_ sender: Any) {
        let controller: AddPinViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier:"addPin") as! AddPinViewController
        let navVC = UINavigationController(rootViewController:controller)
        self.present(navVC,animated: true,completion: nil)
    }
    @IBAction func logout(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            logOutFunction(){(success) in
                DispatchQueue.main.async {
                    if(success){
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.showAlert(title: "Failed!", message: "Unable to Logout, Try Again")
                    }
                }
              
            }
        }
       
    }
    override func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async { () -> Void in
            var annotations = [MKPointAnnotation]()
            getUserDetails()
            listAllStudents(completionHandler: {(students,success) in
                if(success){
                    for student in students{
                        let lat = student.lattitude
                        let long = student.longitude
                        
                        let coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(lat),longitude:CLLocationDegrees(long))
                        
                        let firstName = student.firstName
                        let lastName = student.lastName
                        let mediaUrl = student.mediaUrl
                        let title = "\(firstName) \(lastName)"
                        let annotation = MKPointAnnotation()
                        
                        annotation.coordinate = coordinate
                        annotation.title = title
                        annotation.subtitle = mediaUrl
                        annotations.append(annotation)
                        
                    }
                    DispatchQueue.main.async {
                        self.mapView.removeAnnotations(self.mapView.annotations)
                        self.mapView.addAnnotations(annotations)
                        self.mapView.delegate = self
                    }
                }else{
                    DispatchQueue.main.async {
                       self.showAlert(title: "Failed", message: "Unable to download Students data.")
                    }
                }
            })
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let openUrl = URL(string:toOpen){
                    if app.canOpenURL(openUrl){
                        app.open(openUrl, options:[:], completionHandler: nil)
                    }else{
                        showAlert(title: "Link Invalid", message: "Link Cannot be opened.")
                    }
                }else{
                    showAlert(title: "Link Invalid", message: "Link Cannot be opened.")
                }
            }
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
