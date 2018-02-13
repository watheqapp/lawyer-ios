//
//  OrderViewModel.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/13/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderViewModel: ToastAlertProtocol {
    

    func getOrderDetails(orderId:String,completion: @escaping (Orderdata?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getOrderDetails(orderId), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                
                let Ordermodel = Mapper<AcceptOrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel?.data,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    
    func AcceptOrder(orderId:String,completion: @escaping (Orderdata?, String?) -> ()){
        NetworkHandler.requestTarget(target: .AcceptOrder(orderId), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<AcceptOrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel?.data,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    
    func CloseOrder(orderId:String,completion: @escaping (Orderdata?, String?) -> ()){
        NetworkHandler.requestTarget(target: .CloseOrder(orderId), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<AcceptOrderRootClass>().map(JSONString: result as! String)
                completion(Ordermodel?.data,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    

    

    
   
    
    func getPendingOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getPendingOrders(orderPageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    
    func getClosedOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getClosedOrders(orderPageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }
    
    func ContactUs(title:String,content:String, completion: @escaping (String, String?) -> ()){
        
        NetworkHandler.requestTarget(target: .ContactUs(title: title,content:content), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                completion("",nil)
            } else{
                completion("",errorMsg)
            }
        }
    }

}
