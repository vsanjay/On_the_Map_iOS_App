import Foundation

// Student Location struct
struct StudentLocation{
    
    let objectID : String!
    let uniqueKey : String!
    let firstName : String!
    let lastName : String!
    let mapString : String!
    let mediaURL : String!
    let latitude : Double!
    let longitude : Double!
    
    
    init(studentDict : [String : AnyObject]){
        
        self.objectID = studentDict["objectID"] as! String
        self.uniqueKey = studentDict["uniqueKey"] as! String
        self.firstName = studentDict["firstName"] as! String
        self.lastName = studentDict["lastName"] as! String
        self.mapString = studentDict["mapString"] as! String
        self.mediaURL = studentDict["mediaURL"] as! String
        self.latitude = studentDict["latitude"] as! Double
        self.longitude = studentDict["longitude"] as! Double
        
    }
    
}
