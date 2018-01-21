//
//  AcceptOrderRootClass.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 1/20/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper

class AcceptOrderRootClass: NSObject, NSCoding, Mappable {
    var code : Int?
    var data : Orderdata?
    var message : String?
    var status : String?
    
    class func newInstance(map: Map) -> Mappable?{
        return AcceptOrderRootClass()
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        code <- map["code"]
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        data = aDecoder.decodeObject(forKey: "data") as? Orderdata
        message = aDecoder.decodeObject(forKey: "message") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        
    }

}
