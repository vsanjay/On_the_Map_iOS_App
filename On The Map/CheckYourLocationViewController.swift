//
//  CheckYourLocationViewController.swift
//  On The Map
//
//  Created by VERDU SANJAY on 23/02/18.
//  Copyright © 2018 VERDU SANJAY. All rights reserved.
//

import UIKit
import MapKit

class CheckYourLocationViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var mapString : String = ""
    var mediaURL : String = ""
    var coordinate = CLLocationCoordinate2D()
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLocationWithPin()
        mapView.delegate = self
        
        
        //
        
        let latitude:CLLocationDegrees = coordinate.latitude
        
        let longitude:CLLocationDegrees = coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func showLocationWithPin(){
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        annotation.title = "Your name goes here"
        annotation.subtitle = "Your Link goes here"
        
        mapView.addAnnotation(annotation)
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
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // hide status bar
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
        ParseClient.sharedInstance().getStudentDataAndPostLocation(uniqueKey: UdacityClient.sharedInstance().userID, mapString: mapString, mediaURL: mediaURL, latitude: coordinate.latitude, longitude: coordinate.longitude) { (success, error) in
            
            if success {
                
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
                
                
                UdacityClient.sharedInstance().threadOn = false
                
            }else{
                
                self.presentAlertController(error: "No Internet/Unknown error")
                
            }
        }
    }
    
    func presentAlertController(error : String){
        
        self.alertController = UIAlertController(title: "Post failed", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        self.alertController.addAction(action)
        
        performUIUpdatesOnMain {
            
            self.present(self.alertController, animated: true, completion: nil)
            
        }
    }
    
}
