//
//  AcceptsOrderViewController.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 1/19/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import TransitionButton
import Kingfisher

class AcceptsOrderViewController: UIViewController,ToastAlertProtocol {
    
    @IBOutlet weak var tbl_orderDetails: UITableView!
    @IBOutlet weak var btnAccepts: TransitionButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var img_Map: UIImageView!

    @IBOutlet weak var lbl_PriceTitle: UILabel!
    
    var RequestedOrder : Orderdata!
    var ArrToDraw :NSMutableArray!
    var Orderid : String!
    var Clientid : String!
    var viewModel: OrderViewModel!
    var ErrorStr : String!


    var IsFirstLoading : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        IsFirstLoading = true
        self.ErrorStr = ""
        viewModel = OrderViewModel()
        self.tbl_orderDetails.rowHeight = UITableViewAutomaticDimension

        self.getOrdersDetailsWithOrderId(Orderid)


        // Do any additional setup after loading the view.
    }
    
    func adjustOrderDataToDrawWithOrderObj (_ OrderObj : Orderdata)
    {
        lbl_Price.text = "\(OrderObj.cost as! Int)"
        btnAccepts.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        btnCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        lbl_PriceTitle.text = NSLocalizedString("Price Coast", comment: "")
        ArrToDraw = NSMutableArray()
        
        let DicOrderType = NSMutableDictionary()
        DicOrderType.setValue(OrderObj.category?.name, forKey: "value")
        DicOrderType.setValue("OrderCategory", forKey:"title" )
        ArrToDraw.add(DicOrderType)

 
        
        let DicmoawklName = NSMutableDictionary()
        DicmoawklName.setValue(OrderObj.client?.name, forKey: "value")
        DicmoawklName.setValue("Name", forKey: "title")

        ArrToDraw.add(DicmoawklName)
        
        let deliveryLocation = NSMutableDictionary()
        deliveryLocation.setValue(OrderObj.delivery, forKey: "value")
        deliveryLocation.setValue("delivery", forKey:"title" )

        ArrToDraw.add(deliveryLocation)
        
        let DicTimeType = NSMutableDictionary()
        DicTimeType.setValue(OrderObj.time, forKey: "value")
        DicTimeType.setValue(NSLocalizedString("Time", comment: ""), forKey:"title" )
        ArrToDraw.add(DicTimeType)
        
        let DicawayType = NSMutableDictionary()
        DicawayType.setValue(OrderObj.distance, forKey: "value")
        DicawayType.setValue(NSLocalizedString("AwayFromYou", comment: ""), forKey:"title" )
        ArrToDraw.add(DicawayType)
        
        let img = "https://maps.googleapis.com/maps/api/staticmap?center=\(OrderObj.clientLat as! Float),\(OrderObj.clientLong as! Float)&zoom=15&size=500x500&maptype=roadmap%20&markers=color:red%7C\(OrderObj.clientLat as! Float),\(OrderObj.clientLong as! Float)&format=png&style=feature:poi%7Celement:labels%7Cvisibility:off"
       let imgUrl =  URL(string:img)
        img_Map.kf.setImage(with:imgUrl, placeholder: UIImage.init(named:"" ), options: nil, progressBlock: nil, completionHandler: nil)

        self.tbl_orderDetails.reloadData()


    }
    
    func getOrdersDetailsWithOrderId (_ orderId : String)
    {
        viewModel.getOrderDetails(orderId: orderId, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                self.IsFirstLoading = false
                self.RequestedOrder = OrderObj!
                self.adjustOrderDataToDrawWithOrderObj(self.RequestedOrder)
                
            } else{
                self.ErrorStr = errorMsg
                self.IsFirstLoading = false
                self.tbl_orderDetails.reloadData()
                
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func AcceptOrdersWithOrderId (_ orderId : String)
    {
        btnAccepts.startAnimation()
        viewModel.AcceptOrder(orderId: orderId, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                
                self.CancelOrder(AnyClass.self)
                
                self.showToastMessage(title:NSLocalizedString("OrderAccepted", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)

                
            } else{
                self.ErrorStr = errorMsg
                self.IsFirstLoading = false
                self.tbl_orderDetails.reloadData()
                
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func AcceptOrder(_ sender :Any)
    {
        self.AcceptOrdersWithOrderId(Orderid)
    }
    
    @IBAction func CancelOrder(_ sender :Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AcceptsOrderViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if IsFirstLoading == true
        {
            return 5
        }
        else
        {
            return ArrToDraw.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if IsFirstLoading == true
        {
            let cellLoader:PricePlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"PricePlaceHolderTableViewCell") as UITableViewCell! as! PricePlaceHolderTableViewCell
            
            cellLoader.gradientLayers.forEach { gradientLayer in
                let baseColor = cellLoader.lblServiceName.backgroundColor!
                gradientLayer.colors = [baseColor.cgColor,
                                        baseColor.brightened(by: 0.93).cgColor,
                                        baseColor.cgColor]
                gradientLayer.slide(to: .right)
            }
            return cellLoader
            
        }
        else
        {
          
            let cellpriceCell:PriceTableViewCell = tableView.dequeueReusableCell(withIdentifier:"PriceTableViewCell") as UITableViewCell! as! PriceTableViewCell
            
            let DicOrderType = ArrToDraw.object(at: indexPath.row) as! NSDictionary
            if let DicValue = DicOrderType.value(forKey: "value")
            {
                cellpriceCell.lbl_ServiceCoast.text = DicValue as! String
            }
            else
            {
                 cellpriceCell.lbl_ServiceCoast.text = " "
            }
            cellpriceCell.lbl_serviceName.text = NSLocalizedString(DicOrderType.value(forKey: "title") as! String, comment: "")

            return cellpriceCell
        }
        
        
    }
    
}

extension AcceptsOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if IsFirstLoading == true
        {
            return 70
        }
        else
        {
            return UITableViewAutomaticDimension
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

extension AcceptsOrderViewController:DZNEmptyDataSetSource
{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let myMutableString = NSMutableAttributedString()
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "")
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("NoInternetConnection", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            var myMutableString2 = NSMutableAttributedString()
            myMutableString2 = NSMutableAttributedString(string: NSLocalizedString("ReconnectToInternet", comment: ""))
            myMutableString2.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor(red: 16 / 255.0, green: 16 / 255.0, blue: 16 / 255.0, alpha: 1.0)], range: NSRange(location:0,length:myMutableString2.length)) // What ever range you want to give
            
            
            myMutableString.append(myMutableString1)
            myMutableString.append(NSAttributedString(string: "\n"))
            myMutableString.append(myMutableString2)
            
            
        }
        else if ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("SERVER_ERROR", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            var myMutableString2 = NSMutableAttributedString()
            
            myMutableString2 = NSMutableAttributedString(string: NSLocalizedString("TryAgainLater", comment: ""))
            myMutableString2.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor(red: 16 / 255.0, green: 16 / 255.0, blue: 16 / 255.0, alpha: 1.0)], range: NSRange(location:0,length:myMutableString2.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            myMutableString.append(NSAttributedString(string: "\n"))
            myMutableString.append(myMutableString2)
            
            
        }
        else
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No Orders", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            
        }
        return myMutableString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "") || ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            return UIImage(named:"EmptyData_NoInternet")
            
        }
        else
        {
            return UIImage(named:"EmptyData_OrdersEmpty")
            
        }
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation!
    {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSValue(caTransform3D:CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1))
        animation.duration = 5
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.clear
    }
    
}

extension AcceptsOrderViewController:DZNEmptyDataSetDelegate
{
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool
    {
        return false
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!)
    {
    self.getOrdersDetailsWithOrderId(Orderid)
    }
}


