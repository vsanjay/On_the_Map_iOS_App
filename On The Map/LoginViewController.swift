//
//  ViewController.swift
//  On The Map
//
//  Created by VERDU SANJAY on 22/02/18.
//  Copyright © 2018 VERDU SANJAY. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var alertController : UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedCornerButton()
        setTextFieldDelegates()
        
    }
    
    // Function to make button with rounded corners
    func roundedCornerButton(){
        
        logInButton.layer.cornerRadius = 5
        
    }

    // When signup button is tapped,open safari and show login page
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        if let url = URL(string: UdacityConstants.UdacitySignUpUrl.signupUrl) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        
        UdacityClient.sharedInstance().authenticate(emailTextField.text!, passwordTextField.text!) { (success, error) in
            
            if success {
                
                    
                    self.completeLogin()
                    
                
                
                
            }else{
                
                if error != ""{
                
                self.presentAlertController(error: error)
                    
                }
                
            }
        }
    }
    
    // Pop Alert Controller
    func presentAlertController(error : String){
        
        self.alertController = UIAlertController(title: "Login failed", message: error, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        self.alertController.addAction(action)
        
        performUIUpdatesOnMain {
            
            self.present(self.alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func setTextFieldDelegates(){
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    func completeLogin(){
        
        performUIUpdatesOnMain {
        
        self.performSegue(withIdentifier: "goToTabControllerSegue", sender: self)
            
        }
        
    }
    

}

