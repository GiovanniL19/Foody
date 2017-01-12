//
//  Global
//  Foody
//
//  Created by Giovanni Lenguito on 28/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

struct Global {
    //Tuple
    static let path = (ip: "10.4.161.60", port: "3002")
    
    //Computed property
   static var ip : String{
        return "http://\(path.ip):\(path.port)"
    }
}
