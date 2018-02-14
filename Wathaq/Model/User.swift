//
//	User.swift
//
//	Create by Ahmed Zaky on 1/12/2017
//	Copyright © 2017 Ibtikar Technolgoies. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper

class User : NSObject, NSCoding, Mappable{

	var createdAt : Int?
	var email : String?
    var userID : Int?
    var image : String?
	var isCompleteProfile : Bool?
	var language : String?
	var name : String?
	var phone : Int?
    var credit : Int?

	var token : String?
    
    var active : Bool?
    var lawyerType : String?
    var IDCardFile : String?
    var licenseFile : String?
    var latitude : Double?
    var longitude : Double?
    var isCompleteFiles : Bool?


    class func newInstance(map: Map) -> Mappable?{
        return User()
    }
    required convenience init?(map: Map) {
        self.init()
    }
    

	func mapping(map: Map)
	{
		createdAt <- map["created_at"]
		email <- map["email"]
		userID <- map["id"]
		image <- map["image"]
		isCompleteProfile <- map["isCompleteProfile"]
		language <- map["language"]
		name <- map["name"]
		phone <- map["phone"]
        credit <- map["credit"]
		token <- map["token"]
        active <- map["active"]
        lawyerType <- map["lawyerType"]
        IDCardFile <- map["IDCardFile"]
        licenseFile <- map["licenseFile"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        isCompleteFiles <- map["isCompleteFiles"]


		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    convenience required init(coder aDecoder: NSCoder)
	{
        self.init()
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         email = aDecoder.decodeObject(forKey: "email") as? String
         userID = aDecoder.decodeObject(forKey: "id") as? Int
         image = aDecoder.decodeObject(forKey: "image") as? String
         isCompleteProfile = aDecoder.decodeObject(forKey: "isCompleteProfile") as? Bool
         language = aDecoder.decodeObject(forKey: "language") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? Int
         credit = aDecoder.decodeObject(forKey: "credit") as? Int
         token = aDecoder.decodeObject(forKey: "token") as? String
        isCompleteFiles = aDecoder.decodeObject(forKey: "isCompleteFiles") as? Bool
        active = aDecoder.decodeObject(forKey: "active") as? Bool
        lawyerType = aDecoder.decodeObject(forKey: "lawyerType") as? String
        IDCardFile = aDecoder.decodeObject(forKey: "IDCardFile") as? String
        licenseFile = aDecoder.decodeObject(forKey: "licenseFile") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Double
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
        aCoder.encode(userID, forKey: "id")

		if image != nil{
			aCoder.encode(image, forKey: "image")
		}
		if isCompleteProfile != nil{
			aCoder.encode(isCompleteProfile, forKey: "isCompleteProfile")
		}
		if language != nil{
			aCoder.encode(language, forKey: "language")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
        if credit != nil{
            aCoder.encode(credit, forKey: "credit")
        }
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}
        
        if isCompleteFiles != nil{
            aCoder.encode(isCompleteFiles, forKey: "isCompleteFiles")
        }
        if active != nil{
            aCoder.encode(active, forKey: "active")
        }
        
        if lawyerType != nil{
            aCoder.encode(lawyerType, forKey: "lawyerType")
        }
        
        if IDCardFile != nil{
            aCoder.encode(IDCardFile, forKey: "IDCardFile")
        }
        
        if licenseFile != nil{
            aCoder.encode(licenseFile, forKey: "licenseFile")
        }
        
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
	}

}
