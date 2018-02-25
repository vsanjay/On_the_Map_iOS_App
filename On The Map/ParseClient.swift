import Foundation


class ParseClient : NSObject{
    
    // Array of student locations
    
    var studentLocationCommonURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    // init from parent class
    override init() {
        super.init()
    }
    
    func getRequest(completionHandler : @escaping (_ success : Bool,_ error : String) -> Void){
        
        let url = URL(string : studentLocationCommonURL + "?limit=100" + "&order=-updatedAt")
        
        print(url)
        
        var request = URLRequest(url: url!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let task = URLSession.shared.dataTask(with: request ) { (data, response, error) in
            
            if error != nil {
                
                completionHandler(false, "Data not downloaded")
                
            }else{
                
                if let data = data {
                    
                    do{
                        
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
                        
                        let results = jsonData["results"] as! [[String : AnyObject]]
                        
                        print(results.count)
                        
                        
                        
                        // Cleaning any previous elements present as we want only recent locations
                        SharedData.sharedInstance().studentLocations.removeAll()
                        
                        for student in results{
                            
                            // Student location object
                            
                            let studentLocationObject = self.createStudentLocationObject(student: student)
                            
                            // append to studentlocations array
                            
                            SharedData.sharedInstance().studentLocations.append(studentLocationObject)
                            
                        }
                        
                        
                        completionHandler(true, "")
                        
                    }catch{}
                    
                }
                
            }
            
        }
        task.resume()
    }
    
    func getStudentDataAndPostLocation(uniqueKey : String,mapString : String,mediaURL : String,latitude : Double,longitude : Double,completionHandler : @escaping (_ sucess : Bool,_ error : String) -> Void){
        
        let url = URL(string : "https://www.udacity.com/api/users/\(uniqueKey)")
        
        var request = URLRequest(url: url!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                
                completionHandler(false, "Unknown Error")
                
            }else{
                
                do{
                    
                    let range = Range(5..<data!.count)
                    let newData = data?.subdata(in: range)
                
                    let jsonData = try JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
                    
                    let userData = jsonData["user"]
                    let firstName = userData!["first_name"]
                    let lastName = userData!["last_name"]
                    UdacityClient.sharedInstance().firstName = firstName as! String
                    UdacityClient.sharedInstance().lastName = lastName as! String
                    
                    self.postLocation(uniqueKey: uniqueKey, firstName: firstName as! String, lastName: lastName as! String, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, postcompletionHandler: { (success, error) in
                        
                        if error != "" {
                            
                            completionHandler(false,error)
                            
                        }else{
                            
                            
                            
                            completionHandler(true,error)
                            
                            
                        }
                        
                        
                    })
                    
                }catch{}
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    func postLocation(uniqueKey : String , firstName : String , lastName : String , mapString : String,mediaURL : String,latitude : Double,longitude : Double,postcompletionHandler : @escaping (_ sucess : Bool,_ error : String) -> Void){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
                postcompletionHandler(false, "Unknown error")
            }
            else{
                
                do{
                
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
                    
                        print("posted")
                        postcompletionHandler(true,"")
                    
                }catch{}
                
                
            }
        }
        task.resume()
        
    }
 
 
    
    //Some elements of API have missing values which are important,so for that case i just passed my info there.In general API always has correct format for all elements,So i did this.
    func createStudentLocationObject(student : [String : AnyObject]) -> StudentLocation{
        
        let objectID : String!
        let uniqueKey : String!
        let firstName : String!
        let lastName : String!
        let mapString : String!
        let mediaURL : String!
        let latitude : Double!
        let longitude : Double!
        
        if student["objectID"] != nil {
            
            objectID = student["objectID"] as! String
        }else {
            objectID = ""
        }
        if let key = student["uniqueKey"] as? String {
            
            uniqueKey = key
            
        }else {
            uniqueKey = ""
        }
        if student["firstName"] != nil {
            
            print(student["firstName"])
            
            firstName = student["firstName"] as! String
        }else {
            firstName = "sanjay"
        }
        if student["lastName"] != nil {
            
            lastName = student["lastName"] as! String
        }else {
            lastName = "verdu"
        }
        if student["mapString"] != nil {
            
            mapString = student["mapString"] as! String
        }else {
            mapString = "india"
        }
        if student["mediaURL"] != nil {
            
            mediaURL = student["mediaURL"] as! String
        }else {
            mediaURL = "https://www.linkedin.com/in/verdusanjay"
        }
        if student["latitude"] != nil {
            
            latitude = student["latitude"] as! Double
        }else {
            latitude = 23.5457653
        }
        if student["longitude"] != nil {
            
            longitude = student["longitude"] as! Double
        }else {
            longitude = 87.28771400000005
        }
        
        let studentDict : [String : AnyObject ] = ["objectID" : objectID as AnyObject,"uniqueKey" : uniqueKey as AnyObject,"firstName" : firstName as AnyObject,"lastName" : lastName as AnyObject,"mapString" : mapString as AnyObject , "mediaURL" : mediaURL as AnyObject,"latitude" : latitude as AnyObject , "longitude" : longitude as AnyObject]
        
        let studentLocationObject = StudentLocation(studentDict: studentDict)
        
        return studentLocationObject
        
    }
    
    
    // Making a singleton
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
}
