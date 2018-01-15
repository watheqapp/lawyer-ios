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
    

    func getNewOrders(orderPageNum:Int,completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getNewOrders(orderPageNum, 10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)!
                let Ordermodel = model.data
                completion(model,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    

    
   
    
    func getPendingOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getPendingOrders(orderPageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)!
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

    
    func getClosedOrders(orderPageNum:Int, completion: @escaping (NewOrderRequestRootClass?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getClosedOrders(orderPageNum,10), isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let Ordermodel = Mapper<NewOrderRequestRootClass>().map(JSONString: result as! String)!
                completion(Ordermodel,nil)
                
            } else{
                completion(nil,errorMsg)
            }
        }
    }

}
