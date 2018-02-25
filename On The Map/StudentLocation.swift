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
    
    
    init(objectID : String, uniqueKey : String,firstName : String,lastName : String,mapString : String,mediaURL : String,latitude : Double,longitude : Double){
        
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        
    }
    
}
