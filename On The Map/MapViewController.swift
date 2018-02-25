//
//  MapViewController.swift
//  On The Map
//
//  Created by VERDU SANJAY on 23/02/18.
//  Copyright © 2018 VERDU SANJAY. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    
    var studentLocations = [StudentLocation]()
    
    // Alert Pop up when error occurs
    var alertController : UIAlertController!
    
    // map
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting map view delegate
        setMapDelegate()
        getStudentLocationData()
        UdacityClient.sharedInstance().threadOn = true
        print("loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(UdacityClient.sharedInstance().threadOn)
        
        if  UdacityClient.sharedInstance().threadOn == false {
            
            let annotations = self.mapView.annotations
                for _annotation in annotations {
                    if let annotation = _annotation as? MKAnnotation
                    {
                        self.mapView.removeAnnotation(annotation)
                    }
                }
            
            UdacityClient.sharedInstance().threadOn = true
            
            
            getStudentLocationData()
            
        }
        
    }
    
    // Function to set mapview delegate
    func setMapDelegate(){
        
        mapView.delegate = self
    }
    
    // Hide Status Bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    func getStudentLocationData(){
        
        ParseClient.sharedInstance().getRequest { (success, error) in
            
            if success {
                
                self.studentLocations = ParseClient.sharedInstance().studentLocations
                self.putPinsOnMap()
            }else{
                self.presentAlertController(error: error)
            }
        }
    }
    
    func putPinsOnMap(){
        
        var annotations = [MKPointAnnotation]()
        
        for student in studentLocations{
            
            let latitude = CLLocationDegrees(student.latitude)
            let longitude = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = student.firstName + " " + student.lastName
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
            
        }
        
        mapView.addAnnotations(annotations)
        
    }
    
    // Implement MKMapView Delegate Function so to enable tap operation on our annotation.
    
    // Delegate function 1
    
    
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
    
    // Delegate Function 2
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        UdacityClient.sharedInstance().logout { (success, error) in
            
            if success{
                
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else{
                self.presentAlertController(error: error)
            }
        }
    }
    
    func presentAlertController(error : String){
        
        self.alertController = UIAlertController(title: "Check your Internet connection", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        self.alertController.addAction(action)
        
        performUIUpdatesOnMain {
            
            self.present(self.alertController, animated: true, completion: nil)
            
        }
    }
}
