//
//  WatheqViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import DAKeychain
import Firebase
import DZNEmptyDataSet

class WatheqViewController: AbstractViewController,ToastAlertProtocol {
    var viewModel: UserViewModel!
    var IsFirstLoading : Bool!
    var ArrCat :[Category]!
    var Pricesmodel: PricesViewModel!
    var ErrorStr : String!
    @IBOutlet weak var tbl_prices: UITableView!



    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        Pricesmodel = PricesViewModel()
        getPricesCategories()
        self.ErrorStr = ""

        self.checktoRegisterDeviceToken()
        IsFirstLoading = false
        ArrCat = [Category]()

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }

        self.tbl_prices.rowHeight = UITableViewAutomaticDimension

        self.title = NSLocalizedString("Prices", comment: "")
        self.tabBarItem.title = NSLocalizedString("Prices", comment: "")

       // AbstractViewController.showMessage(title: "No Internet Connection", body: "", isWindowNeeded: false, BackgroundColor: UIColor.black, foregroundColor: UIColor.white)

        // Do any additional setup after loading the view.
    }
    
    func getPricesCategories()
    {
        Pricesmodel.GetCategories { (wkalatTypeObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                self.IsFirstLoading = false
                if let arrCatData = wkalatTypeObj?.categories
                {
                    self.ArrCat = arrCatData as [Category]
                }
                else
                {
                    self.ArrCat = [Category]()
                }
                
                self.tbl_prices.reloadData()
                
            } else{
                self.ErrorStr = errorMsg
                self.IsFirstLoading = false
                
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                self.tbl_prices.reloadData()
                
                
                
            }
        }
    }
    
    
    func checktoRegisterDeviceToken()
    {
        if  UserDefaults.standard.string(forKey: "TokenDevice") != nil
        {
            let UuidData : String!
            if let uuidvalue = DAKeychain.shared["uuid"]
            {
                UuidData = uuidvalue
            }
            else
            {
                let uuid = UUID().uuidString
                DAKeychain.shared["uuid"] = uuid // Store
                UuidData = uuid
            }
            
            let NotificationData =  NSMutableDictionary()
            NotificationData.setValue(UserDefaults.standard.string(forKey: "TokenDevice"), forKey: "token")
            NotificationData.setValue(UuidData, forKey: "identifier")
            NotificationData.setValue(NSLocale.preferredLanguages[0], forKey: "locale")
            
            
            self.RegisterDeviceToken(ident: UuidData, FBToken: UserDefaults.standard.string(forKey: "TokenDevice")!)
        }
    }
    
    func RegisterDeviceToken(ident :String , FBToken : String)
    {
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
        
        let values = ["displayName": userObj?.name, "email": userObj?.email, "instanceId": FBToken, "uid" :"\(userObj!.userID as! Int)"]
        Database.database().reference().child("users").child("\(userObj!.userID as! Int)").updateChildValues(values, withCompletionBlock: { (errr, _) in
            if errr == nil {
                
            }
        })
        
        viewModel.RegisterDeviceToken(identifier:ident , firebaseToken:FBToken,  completion: { (ResponseDic, errorMsg) in
            if errorMsg == nil {
                
                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
        
    }
    
    override  func viewDidLayoutSubviews() {
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }

    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension WatheqViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
            if IsFirstLoading == true
            {
                return 5
            }
            else
            {
                return ArrCat.count
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
                
                let CatObj =  self.ArrCat[indexPath.row]
                cellpriceCell.lbl_serviceName.text = CatObj.name
                cellpriceCell.lbl_ServiceCoast.text = "\(CatObj.cost as! Int)"
              
                return cellpriceCell
            }
        
        
    }
    
}

extension WatheqViewController: UITableViewDelegate {
    
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

extension WatheqViewController:DZNEmptyDataSetSource
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
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No Categiories", comment: ""))
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

extension WatheqViewController:DZNEmptyDataSetDelegate
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
        getPricesCategories()
    }
}

extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}

