//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by VERDU SANJAY on 23/02/18.
//  Copyright © 2018 VERDU SANJAY. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {
    
    var alertController = UIAlertController()
    var coordinate = CLLocationCoordinate2D()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFieldDelegate()
        activityIndicator.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    func setTextFieldDelegate(){
        
        locationTextField.delegate = self
        infoTextField.delegate = self
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        
        if locationTextField.text == "" || infoTextField.text == "" {
            
            presentAlertController(error: "Fill all text fields")
            
        }else{
            
            activityIndicator.isHidden = false
            
            let geocoder = CLGeocoder()
            
            geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
                
                if error != nil {
                    
                    self.presentAlertController(error: "Location not found/No internet")
                    
                }else{
                    
                    self.coordinate = (placemarks?.first?.location?.coordinate)!
                    
                    self.performSegue(withIdentifier: "checkLocation", sender: self)
                    
                }
                
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! CheckYourLocationViewController
        
        destinationVC.coordinate = coordinate
        destinationVC.mapString = locationTextField.text!
        destinationVC.mediaURL = infoTextField.text!
        
    }
    
    func presentAlertController(error : String){
        
        alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(action)
        
        self.present(self.alertController, animated: true, completion: nil)
        
    }
    
}
