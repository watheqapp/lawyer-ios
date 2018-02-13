//
//  PricesViewModel.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 2/6/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import ObjectMapper


class PricesViewModel: ToastAlertProtocol {
    static let shareManager = PricesViewModel()
    
    func GetCategories(completion: @escaping (WkalatType?, String?) -> ()){
        NetworkHandler.requestTarget(target: .getPrices, isDictionary: true) { (result, errorMsg) in
            if errorMsg == nil {
                let model = Mapper<PricesRootClass>().map(JSONString: result as! String)
                let wkalatModel = model?.data
                completion(wkalatModel,nil)
            } else{
                completion(nil,errorMsg)
            }
        }
    }

}
