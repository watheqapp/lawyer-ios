//  MIT License

//  Copyright (c) 2017 Satish Babariya

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit
import Photos
import Firebase
import CoreLocation
import TransitionButton
import DZNEmptyDataSet
import MapKit
import CoreLocation

class ChatVC: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate,ToastAlertProtocol {
    
    //MARK: Properties
    var OrderObj : Orderdata!
    var ClientObj : Client!
    var viewModel: OrderViewModel!
    @IBOutlet weak var btncloseOrder: TransitionButton!


    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!

    var custmoizeBackButton : Bool!

    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    let locationManager = CLLocationManager()
    var items = [Message]()
    let imagePicker = UIImagePickerController()
    let barHeight: CGFloat = 50
    var currentUser: User?
    var canSendLocation = true
    
    
    func checkOrderStatus()
    {
        if OrderObj.status == "Closed"
        {
            self.inputTextField.isEnabled = false
            btncloseOrder.setTitle(NSLocalizedString("OrderClosed", comment: ""), for: .normal)
            btncloseOrder.setTitleColor(UIColor.ashGrey, for: .normal)
        }
    }
    
    //MARK: Methods
    func customization() {
        self.imagePicker.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.locationManager.delegate = self
        btncloseOrder.setTitle(NSLocalizedString("closeOrderTitle", comment: ""), for: .normal)
        if custmoizeBackButton == true
        {
            self.navigationItem.setHidesBackButton(true, animated: false)
            
            
            var strIconName :String!
            var lang = Language.getCurrentLanguage()

            if lang.contains("en")
            {
                strIconName = "ic_arrow_r"
            }
            else
            {
                strIconName = "ic_arrow_l"

            }
            
            let icon = UIImage.init(named: strIconName)?.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @IBAction func closeOrderAction (_ sender:Any)
    {
        if OrderObj.status != "Closed"
        {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("closeOrder",comment:""), preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        }
        actionSheetController.addAction(cancelButton)
        
        let ConfirmButton = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default) { _ in
            self.CloseOrdersWithOrderId("\(self.OrderObj.id as! Int)")
        }
        actionSheetController.addAction(ConfirmButton)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    func CloseOrdersWithOrderId (_ orderId : String)
    {
        viewModel.CloseOrder(orderId: orderId, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
             self.showToastMessage(title:NSLocalizedString("OrderClosed", comment: "") , isBottom:false , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                self.inputTextField.isEnabled = false
                self.btncloseOrder.setTitle(NSLocalizedString("OrderClosed", comment: ""), for: .normal)

                
            } else{
            self.showToastMessage(title:errorMsg! , isBottom:false , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    //Hides current viewcontroller
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
  
    
    //Downloads messages
    func fetchData() {
        Message.downloadAllMessages(toID: "\(ClientObj.id! as! Int)", orderId: "\(OrderObj.id! as! Int)", completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
    }
    

    
    func composeMessage(type: MessageType, content: Any)  {
        
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
        let message = Message.init(from:"\(userObj!.userID as! Int)" , to:"\(ClientObj.id! as! Int)"    , body:content as! String, timestamp: Int(Date().timeIntervalSince1970), dayTimestamp: 123333333)
        Message.send(message: message, toID:"\(ClientObj.id! as! Int)", orderId:"\(OrderObj.id! as! Int)"   , completion: {(_) in
        })
    }
    
    
    func animateExtraButtons(toHide: Bool)  {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func showMessage(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
    }
    


    
   
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.characters.count > 0 {
                self.composeMessage(type: .text, content: self.inputTextField.text!)
                self.inputTextField.text = ""
            }
        }
    }
    
    

    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            if self.items.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User

        
        if  (self.items[indexPath.row].from == "\(userObj?.userID as! Int)")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
            // cell.profilePic.image = self.userObj?.profilePic
            cell.message.text = self.items[indexPath.row].body as! String

            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            cell.message.text = self.items[indexPath.row].body as! String

            return cell
        }
        
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }


    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureTitleView() {
        
        
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
        self.configureTitleView()
        self.checkOrderStatus()

        viewModel = OrderViewModel()
        self.title = "\(NSLocalizedString("OrderNumber", comment: "") as String) \(OrderObj.id as! Int)"
        
        let CallImg    = UIImage(named: "phone-outgoing")!
        let LocationImg  = UIImage(named: "gps-remove")!
        
        let CallButton   = UIBarButtonItem(image: CallImg,  style: .plain, target: self, action: "didTapCallButton:")
        let LocatonButton = UIBarButtonItem(image: LocationImg,  style: .plain, target: self, action: "didTapLocationButton:")
        btnSend.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        inputTextField.placeholder = NSLocalizedString("writeMessage", comment: "")
        navigationItem.rightBarButtonItems = [CallButton, LocatonButton]

    }
    
    @IBAction func didTapCallButton(_ sender: Any){
        
        if let Phone =  OrderObj.client?.phone
        {
        guard let number = URL(string: "tel://" + "\(Phone as! Int)") else { return }
        UIApplication.shared.open(number)
        }
        
    }
    
    @IBAction func didTapLocationButton(_ sender: Any){
        
        if let location =  OrderObj.clientLat
        {
            let coordinate = CLLocationCoordinate2DMake(Double((OrderObj.clientLat)!),Double((OrderObj.clientLong)!))
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = OrderObj.client?.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
        
        
        
    }
}

extension ChatVC:DZNEmptyDataSetSource
{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let myMutableString = NSMutableAttributedString()
        
       
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No messages", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            
        return myMutableString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
            return UIImage(named:"EmptyData_OrdersEmpty")
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

extension ChatVC:DZNEmptyDataSetDelegate
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
    }
}


