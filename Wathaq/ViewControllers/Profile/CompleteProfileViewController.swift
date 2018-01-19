//
//  CompleteProfileViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/29/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton
import CoreLocation
import Firebase


class CompleteProfileViewController: UIViewController,ToastAlertProtocol,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {
   
    var viewModel: UserViewModel!
    var pickerController = UIImagePickerController()
    var chooseUserImge = ""
    var locationManager:CLLocationManager!
    var currentLocation: CLLocation?
    @IBOutlet weak var lblCompleteProfileHello: UILabel!
    @IBOutlet weak var lblCompleteProfileMsg: UILabel!
    @IBOutlet weak var btnAgreeTermsandConditions: UIButton!
    @IBOutlet weak var btnProfilepicture: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtmail: UITextField!
    @IBOutlet weak var btnUpdateLocation: UIButton!

    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var viewContaineruserTextFields: UIView!
        {
        didSet {
            viewContaineruserTextFields.applyDimmviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContaineMailTextFields: UIView!
        {
        didSet {
            viewContaineMailTextFields.applyDimmviewBorderProperties()
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        view.addTapToDismissKeyboard()
        self.setupLocationManager()

    }
    
    override  func viewDidLayoutSubviews() {
        lblCompleteProfileHello.text = NSLocalizedString("hello", comment: "")
        lblCompleteProfileMsg.text = NSLocalizedString("CompleteProfileMsg", comment: "")
        btnAgreeTermsandConditions.setTitle(NSLocalizedString("AgreeOnTerms", comment: ""), for: .normal)
        txtUserName.placeholder = NSLocalizedString("userName", comment: "")
        txtmail.placeholder = NSLocalizedString("UserMail", comment: "")
        ConfirmButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        btnUpdateLocation.setTitle(NSLocalizedString("Updatelocation", comment: ""), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateLocation (_ sender :Any)
    {
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let ChooseLocationView = MainStoryBoard.instantiateViewController(withIdentifier: "CurrentLocationViewController") as! CurrentLocationViewController
        ChooseLocationView.delegate = self as! MoawtheqLocationDelegate
        self.present(ChooseLocationView, animated: true, completion: nil)
        
    }
    
    
    func getAddress(handler: @escaping (String) -> Void)
    {
        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary ?? "")
            
            // Location name
            if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                address += locationName + ", "
            }
            
            // Street address
//            if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
//                address += street + ", "
//            }
            
            // City
            if let city = placeMark?.addressDictionary?["City"] as? String {
                address += city + ", "
            }
            
            // Zip code
//            if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
//                address += zip + ", "
//            }
            // Country
//            if let country = placeMark?.addressDictionary?["Country"] as? String {
//                address += country
//            }
//
            // Passing address back
            handler(address)
        })
    }
    
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locationValue)")
            locationManager?.stopUpdatingLocation()
            getAddress { (address) in
                self.btnUpdateLocation.setTitle( address , for: .normal)
                self.btnUpdateLocation.setTitle( address , for: .highlighted)
                self.btnUpdateLocation.setTitle( address , for: .selected)
            }
 
        }
    }
    // Below Mehtod will print error if not able to update location.
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    @IBAction func OpenTakePhotoOptions (_ sender :Any)
    {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Take Profile Pictuere from", comment: ""), preferredStyle: .actionSheet)
        
        let CancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        }
        actionSheetController.addAction(CancelButton)
        
        let GalleryButton = UIAlertAction(title: NSLocalizedString("Photo Gallery", comment: ""), style: .default) { _ in
            self.openGallary()
        }
        actionSheetController.addAction(GalleryButton)
        
        let CameraButton = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            self.openCamera()
        }
        actionSheetController.addAction(CameraButton)
        self.present(actionSheetController, animated: true, completion: nil)
        
        
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            pickerController.delegate = self
            self.pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.allowsEditing = true
            self .present(self.pickerController, animated: true, completion: nil)
        }
        else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let returnedImg = info[UIImagePickerControllerEditedImage] as! UIImage
        btnProfilepicture.setBackgroundImage(returnedImg, for: .normal)
        chooseUserImge = convertChoosedImgToBase64(returnedImg)
        dismiss(animated:true, completion: nil)
    }
    
    func convertChoosedImgToBase64 (_ chosedImg : UIImage ) -> (String)
    {
        let jpegCompressionQuality: CGFloat = 0.6 // Set this to whatever suits your purpose
        if let base64String = UIImageJPEGRepresentation(chosedImg, jpegCompressionQuality)?.base64EncodedString() {
            // Upload base64String to your database
            return "data:image/jpeg;base64,\(base64String)"
        }
        return ""
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    
  
    

    @IBAction func SendCompleteProfileData(_ sender: Any) {
        view.endEditing(true)
        
        if txtUserName.text?.isEmpty == true || txtmail.text?.isEmpty == true {
            self.showToastMessage(title: NSLocalizedString(("FillAllFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
      
        if  txtmail.text?.isEmail == true {
            ConfirmButton.startAnimation()
            self.view.isUserInteractionEnabled = false
            
            let userMail =  txtmail.text!
            let username =  txtUserName.text!
            var longtiude : Double!
            var latitude :Double!
            
            if ((currentLocation?.coordinate.latitude) != nil)
            {
                longtiude = currentLocation?.coordinate.longitude
                latitude = currentLocation?.coordinate.latitude
            }
            else
            {
                longtiude = 0
                latitude = 0
                
            }
            
            viewModel.completeUserProfile(userName: username, UseEmail: userMail, UseImage: chooseUserImge, Userlat: latitude, Userlong:longtiude, completion: { (userObj, errorMsg) in
                if errorMsg == nil {

                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    let values = ["displayName": userObj?.name, "email": userObj?.email, "instanceId": userObj?.token!, "uid" :"\(userObj!.userID as! Int)"]
                    Database.database().reference().child("users").child("\(userObj!.userID as! Int)").updateChildValues(values, withCompletionBlock: { (errr, _) in
                        if errr == nil {
                            
                        }
                    })

                    
                      self.showToastMessage(title:NSLocalizedString("Profile Data Completed Thank you", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.goToUploadProfessionalFiles ()
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })


           
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("EmailisNotValid"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

        }
    }
    
     func goToUploadProfessionalFiles ()
    {
        
        self.performSegue(withIdentifier: "S_CompleteProfile_UploadProfessionalFiles", sender: nil)
        
//       // self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
//
//                            let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                            let TabViewController = MainStoryBoard.instantiateViewController(withIdentifier: "rootVC") as! UITabBarController
//                            UIApplication.shared.keyWindow?.rootViewController = TabViewController
    }

}



extension CompleteProfileViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtUserName {
            viewContaineruserTextFields.applyActiveviewBorderProperties()
            viewContaineMailTextFields.applyDimmviewBorderProperties()
            
        }
        else
        {
            viewContaineruserTextFields.applyDimmviewBorderProperties()
            viewContaineMailTextFields.applyActiveviewBorderProperties()
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtUserName {
            viewContaineruserTextFields.applyDimmviewBorderProperties()
        }
        else
        {
            viewContaineMailTextFields.applyDimmviewBorderProperties()
        }
}
}

extension CompleteProfileViewController : MoawtheqLocationDelegate {
    func didChooseLocation(currentLocation: CLLocation) {
        self.currentLocation = currentLocation
        getAddress { (address) in
            self.btnUpdateLocation.setTitle( address , for: .normal)
            self.btnUpdateLocation.setTitle( address , for: .highlighted)
            self.btnUpdateLocation.setTitle( address , for: .selected)
        }
    }
    
    

}

