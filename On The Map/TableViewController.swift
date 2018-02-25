//
//  TableViewController.swift
//  On The Map
//
//  Created by VERDU SANJAY on 23/02/18.
//  Copyright © 2018 VERDU SANJAY. All rights reserved.
//

import UIKit

class TableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    var studentLocations = [StudentLocation]()
    var alertController : UIAlertController!
    
    @IBOutlet weak var studentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDataAndDelegateForTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        studentLocations = SharedData.sharedInstance().studentLocations
        studentTableView.reloadData()
    }

   // Hide Status bar
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    func setDataAndDelegateForTableView(){
        
        studentTableView.dataSource = self
        studentTableView.delegate = self
        
    }
    
    // Table view delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentLocations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = studentTableView.dequeueReusableCell(withIdentifier: "tablecell") as! CustomTableCell
        
        cell.studentName.text = studentLocations[indexPath.row].firstName + " " + studentLocations[indexPath.row].lastName
        
        cell.studentInfo.text = studentLocations[indexPath.row].mediaURL
        
        return cell
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(studentLocations[indexPath.row].mediaURL)
        
        if let url = URL(string: studentLocations[indexPath.row].mediaURL) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
   
    
}
