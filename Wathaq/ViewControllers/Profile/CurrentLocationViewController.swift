//
//  CurrentLocationViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GoogleMaps
import TransitionButton



@objc protocol MoawtheqLocationDelegate {
    func didChooseLocation(currentLocation: CLLocation)
}

class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate,ToastAlertProtocol {

   

    var locationManager:CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    var delegate: MoawtheqLocationDelegate?
    var UpdateLocation = false
    var viewModel: UserViewModel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()

        self.title = NSLocalizedString("ChooseAdreess", comment: "")
         configureView()
        self.setupLocationManager()
  }
    func configureView() {
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: 24.7136,
                                              longitude: 46.6753,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        let imagepin = UIImageView.init(image: UIImage.init(named: "LocationPin"))
        imagepin.sizeToFit()
        imagepin.center = mapView.center
        mapView.addSubview(imagepin)
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        let button = TransitionButton(frame: CGRect(x: self.view.center.x - (self.view.frame.size.width - 50)/2, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 50 , height: 60))
        button.backgroundColor = UIColor.deepBlue
        button.setTitle(NSLocalizedString("ChooseAdreess", comment: ""), for: .normal)
        button.titleLabel?.font =  UIFont(name: Constants.FONTS.FONT_AR, size: 17)
        button.roundCorners([.topLeft, .topRight, .bottomLeft ,.bottomRight], radius: 10)
        button.addTarget(self, action: #selector(ChooseAddress), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @IBAction func ChooseAddress (_ sender : Any)
    {
        let TranstBtn:TransitionButton =  sender as! TransitionButton

        if currentLocation != nil {
            
            if UpdateLocation == true
            {
                TranstBtn.startAnimation()
                self.view.isUserInteractionEnabled = false
                let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
                
                viewModel.completeUserProfile(userName: (userObj?.name)!, UseEmail: (userObj?.email)!, UseImage:"" , Userlat: (self.currentLocation?.coordinate.latitude)!, Userlong:(self.currentLocation?.coordinate.longitude)!, completion: { (userObj, errorMsg) in
                    if errorMsg == nil {
                        
                        TranstBtn.stopAnimation()
                        self.view.isUserInteractionEnabled = true
                       self.showToastMessage(title:NSLocalizedString("location updated Thank you", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                        self.navigationController?.popViewController()

                    } else{
                        TranstBtn.stopAnimation()
                        self.view.isUserInteractionEnabled = true

                        self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    }
                })
            }
            else
            {
                // _ = navigationController?.popViewController(animated: true)
                self.delegate?.didChooseLocation(currentLocation: self.currentLocation!) // app crashes after executing this line
                self.dismiss(animated: true, completion: nil)
            }
          

        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("pleaseChooseaddressFirst"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

        }
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locationValue)")
            locationManager?.stopUpdatingLocation()
            let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!,
                                                  longitude: (currentLocation?.coordinate.longitude)!,
                                                  zoom: zoomLevel)
          
            
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
           
            
        }
    }
    // Below Mehtod will print error if not able to update location.
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        mapView.isHidden = false
        currentLocation =  CLLocation(latitude: 24.7136, longitude: 46.6753)


    }
    
   
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension CurrentLocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
      //  mapView.clear() // clearing Pin before adding new
//        let marker = GMSMarker(position: coordinate)
//        marker.map = mapView
//
//        self.currentLocation? =  CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        self.currentLocation? =  CLLocation(latitude: latitude, longitude: longitude)

    }

}

