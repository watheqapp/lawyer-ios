//
//  WatheqApi.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/1/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import Foundation
import Moya

// MARK: - Provider setup


private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let endpointClosure = { (target: WatheqApi) -> Endpoint<WatheqApi> in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    var lang = Language.getCurrentLanguage()
    if lang == "en-US" {
        lang = "en"
    }
    return defaultEndpoint.adding(newHTTPHeaderFields: ["X-Api-Language":lang])
}

let token = UserViewModel.shareManager.getToken()
let authPlugin = AccessTokenPlugin(tokenClosure: token!)


let WatheqProvider = MoyaProvider<WatheqApi>(
    
    endpointClosure: endpointClosure,
    manager: DefaultAlamofireManager.sharedManager,
    plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),authPlugin]
)

// MARK: - Provider support

private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}



public enum WatheqApi {
    //User Login 
    case login(phone:String)
    case completeProfile(name:String, email:String, image:String, latitude:Double, longitude:Double)
    case completeFiles(IDCardFile:String, licenseFile:String, lawyerType:String)
    case UpdateProfile(name:String, email:String, image:String, phone:String)
    case registerDeviceToken(identifier:String, firebaseToken:String)
    case logout(identifier:String)
    case getNewOrders(Int,Int)
    case getPendingOrders(Int,Int)
    case getClosedOrders(Int,Int)
    case getOrderDetails (String)
    case AcceptOrder (String)
    case CloseOrder (String)
    case getNotification




}

extension WatheqApi: TargetType,AccessTokenAuthorizable {
    public var headers : [String : String]? {
        return ["Content-type": "application/json" , Constants.WebService.ApiKeyName: Constants.WebService.ApiKeyValue]
    }
    
    public var baseURL: URL { return URL(string: Constants.ApiConstants.BaseUrl)! }
    public var path: String {
        switch self {
        case .login:
            return "api/lawyer/login"
        case .completeProfile:
            return "api/auth/lawyer/completeProfile"
        case .completeFiles:
            return "api/auth/lawyer/completeFiles"
        case .UpdateProfile:
            return "api/auth/lawyer/updateProfile"
        case .registerDeviceToken:
            return "api/auth/lawyer/registerDeviceToken"
        case .logout:
            return "api/auth/lawyer/logout"
        case .getNewOrders:
            return "api/auth/client/lawyer/listNewOrders"
        case .getPendingOrders:
            return "api/auth/lawyer/order/listPendingOrders"
        case .getClosedOrders:
            return "api/auth/lawyer/order/listClosedOrders"
        case .getOrderDetails:
            return "api/auth/orderDetails"
        case .AcceptOrder :
            return "api/auth/lawyer/order/accept"
        case .CloseOrder :
            return "api/auth/lawyer/order/close"
        case .getNotification :
            return "api/auth/notification/list"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .login,.completeProfile,.completeFiles,.UpdateProfile,.registerDeviceToken,.logout:
            return .post
        case .getNewOrders,.getPendingOrders,.getClosedOrders,.getOrderDetails,.AcceptOrder,.CloseOrder,.getNotification:
            return .get
        }
    }
    
    public var task : Task {
        switch self {
        case .login(let phone):
            return .requestParameters(parameters: ["phone":phone], encoding: JSONEncoding.default)
        case .completeProfile(let name,let email,let image, let latitude, let longitude):
            return .requestParameters(parameters: ["name":name , "email":email , "image":image, "latitude":latitude,"longitude":longitude], encoding: JSONEncoding.default)
        case .completeFiles(let IDCardFile,let licenseFile,let lawyerType):
            return .requestParameters(parameters: ["IDCardFile":IDCardFile , "licenseFile":licenseFile , "lawyerType":lawyerType], encoding: JSONEncoding.default)
        case .UpdateProfile(let name,let email,let image,let phone):
            return .requestParameters(parameters: ["name":name , "email":email , "image":image, "phone":phone], encoding: JSONEncoding.default)
        case .registerDeviceToken(let identifier, let firebaseToken):
            return .requestParameters(parameters: ["identifier":identifier , "firebaseToken" :firebaseToken], encoding: JSONEncoding.default)
        case .logout(let identifier):
            return .requestParameters(parameters: ["identifier":identifier], encoding: JSONEncoding.default)
        case .getNewOrders(let page, let limit):
            return .requestParameters(parameters: ["page":page , "limit" : limit], encoding: URLEncoding.default)
        case .getPendingOrders(let page, let limit):
            return .requestParameters(parameters: ["page":page , "limit" : limit], encoding: URLEncoding.default)
        case .getClosedOrders(let page, let limit):
            return .requestParameters(parameters: ["page":page , "limit" : limit], encoding: URLEncoding.default)
        case .getOrderDetails(let orderId):
            return .requestParameters(parameters: ["orderId":orderId], encoding: URLEncoding.default)
        case .AcceptOrder(let orderId):
            return .requestParameters(parameters: ["orderId":orderId], encoding: URLEncoding.default)
        case .CloseOrder(let orderId):
            return .requestParameters(parameters: ["orderId":orderId], encoding: URLEncoding.default)
        case .getNotification:
            return .requestPlain
        }
    }
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .login:
            return .none
        case .completeProfile,.completeFiles,.UpdateProfile,.registerDeviceToken,.logout,.getNewOrders,.getClosedOrders,.getPendingOrders,.getOrderDetails,.AcceptOrder,.CloseOrder,.getNotification:
            return .bearer
        }
    }
    
    public var validate: Bool {
        
        return false
    }
    public var sampleData: Data { return Data() }  // We just need to return something here to fully implement the protocol
}
public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}



