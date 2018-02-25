import Foundation

class UdacityClient : NSObject {
    
    var userID = ""
    var sessionID = ""
    let sessionURL = "https://www.udacity.com/api/session"
    var threadOn : Bool = false
    var firstName = ""
    var lastName = ""
    
    //Initializers
    override init() {
        super.init()
    }
    
    func authenticate(_ username : String ,_ password : String,completionHandler : @escaping (_ success : Bool , _ errorString : String ) -> Void){
        
        let url = URL(string : sessionURL)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                
                completionHandler(false, "Check your Internet Connection")
                
            }else{
                
                if let data = data{
                    
                    let range = Range(5..<data.count)
                    let newData = data.subdata(in: range)
                    
                    var userInfoInJSON = self.convertToJSON(data: newData)
                    
                    if userInfoInJSON["status"] != nil {
                        
                        completionHandler(false, userInfoInJSON["error"] as! String)
                        
                    }else{
                        
                        let accountDictionary = userInfoInJSON["account"] as! [String:AnyObject]
                        let sessionInfo = userInfoInJSON["session"] as! [String : AnyObject]
                        
                        self.sessionID = sessionInfo["id"] as! String
                        self.userID = accountDictionary["key"] as! String
                        
                        print(self.userID)
                        
                        completionHandler(true,"")
                    }
                }else{
                    completionHandler(false, "Unknown error.Try again")
                }
            }
        }
        task.resume()
    }
    
    func logout(completionHandler : @escaping (_ success : Bool,_ error : String) -> Void){
        
        let url = URL(string : sessionURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                
                completionHandler(false, "Check your Internet Connection")
                
            }else{
                
                if let data = data{
                    
                    let range = Range(5..<data.count)
                    let newData = data.subdata(in: range)
                    var logoutJSON = self.convertToJSON(data: newData)
                    
                    if let session = logoutJSON["session"] {
                        
                        completionHandler(true, "")
                        
                    }else{
                        
                        completionHandler(false,"Unknown error.Try again")
                        
                    }
                }else{
                    
                    completionHandler(false, "Unknown error.Try again")
                    
                }
            }
        }
        task.resume()
    }
    
    
    // Convert data to json data
    func convertToJSON(data : Data) -> [String : AnyObject]{
        
            // Forcely converting to JSON data because i know that the recieving format is a JSON and there will ne no error in converting.
            let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : AnyObject]
            
            return jsonData

    }
    
    // Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
