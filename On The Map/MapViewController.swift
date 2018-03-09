//
//  MapViewController.swift
//  On The Map
//
//  Created by Ravikiran Pathade on 3/7/18.
//  Copyright © 2018 Ravikiran Pathade. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    var allStudents = [Student]()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func addPinButton(_ sender: Any) {
        let controller: AddPinViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier:"addPin") as! AddPinViewController
        let navVC = UINavigationController(rootViewController:controller)
       // self.presentedViewController(controller,animated: true,completion: nil)
        self.present(navVC,animated: true,completion: nil)
    }
    @IBAction func logout(_ sender: Any) {
        logOutFunction()
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
      
        var annotations = [MKPointAnnotation]()
        listAllStudents(completionHandler: {(students) in
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
            self.mapView.addAnnotations(annotations)
            //self.mapView.reloadInputViews()
            self.mapView.delegate = self
        })
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
                    app.openURL(URL(string: toOpen)!)
                }
            }
        }
    }
 
}
