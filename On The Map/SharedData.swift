import Foundation


class SharedData : NSObject{
    
    override init() {
        super.init()
    }
    
    var studentLocations = [StudentLocation]()
    
    

class func sharedInstance() -> SharedData {
    struct Singleton {
        static var sharedInstance = SharedData()
    }
    return Singleton.sharedInstance
}

}
