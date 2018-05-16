//
//  UploadProfissionalFilesViewController.swift
//  WathaqLawyer
//
//  Created by Ahmed Zaky on 12/10/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton


class UploadProfissionalFilesViewController: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate,ToastAlertProtocol {
  
    @IBOutlet weak var lblProfessionTitle: UILabel!
    @IBOutlet weak var lblProfessionTitleMsg: UILabel!
    @IBOutlet weak var btnLawyer: UIButton!
    @IBOutlet weak var btnMa2zon: UIButton!
    @IBOutlet weak var lblIdCardFile: UILabel!
    @IBOutlet weak var lblliscenceFile: UILabel!
    @IBOutlet weak var btnIdCardFile: UIButton!
    @IBOutlet weak var btnliscenceFile: UIButton!
    @IBOutlet weak var btnSendData: TransitionButton! {
        didSet {
            btnSendData.applyBorderProperties()
        }
    }
    var viewModel: UserViewModel!

    
    var LawyerType : String!  //authorized - clerk
    var IdCardFile : String!  //authorized - clerk
    var liscenceFile : String!  //authorized - clerk

    var FileType : String!
    var pickerController = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        LawyerType = "authorized"


        // Do any additional setup after loading the view.
    }
    
    override  func viewDidLayoutSubviews() {
        lblProfessionTitle.text = NSLocalizedString("ProveProfession", comment: "")
        lblProfessionTitleMsg.text = NSLocalizedString("ProveProfessionMsg", comment: "")
        lblIdCardFile.text = NSLocalizedString("idFile", comment: "")
        lblliscenceFile.text = NSLocalizedString("liscenceFile", comment: "")
        btnLawyer.setTitle(NSLocalizedString("Lawyer", comment: ""), for: .normal)
        btnMa2zon.setTitle(NSLocalizedString("Ma2zon", comment: ""), for: .normal)
        btnSendData.setTitle(NSLocalizedString("SendData", comment: ""), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ChangeType (_ sender :Any)
    {
        let Tag = (sender as AnyObject).tag
        
        if Tag == 0
        {
            LawyerType = "clerk"
            UIView.animate(withDuration: 0.2, animations: {
                 self.btnLawyer.backgroundColor = UIColor.clear
                 self.btnMa2zon.backgroundColor = UIColor.lightpink
                 self.btnMa2zon.setTitleColor(UIColor.white, for: .normal)
                 self.btnLawyer.setTitleColor(UIColor.lightimpactGray, for: .normal)
            })
        }
        else
        {
            LawyerType = "authorized"
            UIView.animate(withDuration: 0.2, animations: {
                self.btnLawyer.backgroundColor = UIColor.lightpink
                 self.btnMa2zon.backgroundColor = UIColor.clear
                 self.btnMa2zon.setTitleColor(UIColor.lightimpactGray, for: .normal)
                self.btnLawyer.setTitleColor(UIColor.white, for: .normal)
            })
        }
    }
    
    @IBAction func OpenTakePhotoOptions (_ sender :Any)
    {
        let Tag = (sender as AnyObject).tag
        if Tag == 10
        {
            FileType = "IDCardFile"
        }
        else
        {
            FileType = "licenseFile"
        }

        let actionSheetController: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Take Picture from", comment: ""), preferredStyle: .alert)
        
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
        if FileType == "IDCardFile"
        {
            btnIdCardFile.setBackgroundImage(returnedImg, for: .normal)
            IdCardFile = convertChoosedImgToBase64(returnedImg)
        }
        else
        {
            btnliscenceFile.setBackgroundImage(returnedImg, for: .normal)
            liscenceFile = convertChoosedImgToBase64(returnedImg)

        }
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
    
    
    @IBAction func  sendData (_sender : Any)
    {
        if IdCardFile == nil || liscenceFile == nil{
            self.showToastMessage(title: NSLocalizedString(("FillAllFields"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
        
        self.btnSendData.startAnimation()


            viewModel.completeUserFiles(LawyerType: LawyerType, IDCard: IdCardFile, license: liscenceFile, completion: { (userObj, errorMsg) in
                if errorMsg == nil {
                    
                    self.btnSendData.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("profession Data files uploaded successfully Thank you", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.closeView ()
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    self.btnSendData.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
    }
    
    func closeView ()
    {
                let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let TabViewController = MainStoryBoard.instantiateViewController(withIdentifier: "rootVC") as! UITabBarController
                UIApplication.shared.keyWindow?.rootViewController = TabViewController
    }
    
}


