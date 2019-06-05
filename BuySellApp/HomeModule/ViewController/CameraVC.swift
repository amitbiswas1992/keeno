//
//  CameraVC.swift
//  BuySellApp
//
//  Created by Sanzid on 3/26/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import XLActionController
import CoreLocation
import SwiftMessages
import Gallery





class CameraVC: BaseViewController {
    //Outlets
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var describtionTextView: UITextView!
    @IBOutlet weak var stackViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var catgeoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var describtionTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var productTypeTextField: UITextField!
    @IBOutlet weak var postProductButton: UIButton!
    private var boatAnimation: LOTAnimationView?
    var nameCtegeory = ""
    var locality = ""
    var administrativeArea = ""
    var country = ""
    var lat = ""
    var long = ""
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          self.setUPUIComponent()
        
    }

    // Actions
    
    @IBAction func postProductAction(_ sender: Any) {
        
        if titleTextField.text == ""  || priceTextField.text == "" || productTypeTextField.text == ""{
            
            self.warningMessage(title: "Description Missing", subtitle: "Please Add Empty Description")
            
            
        }
        else{
            uploadImagesFile()

        }
    
        
    }
}


// SetLocation Delegate


extension CameraVC:CLLocationManagerDelegate{
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        manager.stopUpdatingLocation()
        lat = "2" //location.coordinate.latitude.description
        long = "2"//location.coordinate.longitude.description
        
        
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
                return
            }
            
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                // self.locality = placemark.locality!
                //self.locationTextField.text = placemark.locality!
                self.locationTextField.text = placemark.administrativeArea
                
                self.UpdateUserLocation()
                
                self.country = placemark.country!
            }
        })
    }
    
}

extension CameraVC{
    
    
    func setUPUIComponent(){
        
        productView.clipsToBounds = true
        productView.layer.cornerRadius = 16.0
        
        imageCollection.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "FooterView")
        priceTextField.text = ""
        titleTextField.text = ""
        //describtionTextField.text = ""
        productTypeTextField.text = ""
        self.addSlideMenuButton()
        
        
        priceTextField.clipsToBounds = true
        priceTextField.layer.cornerRadius = 8.0
        
        
        titleTextField.clipsToBounds = true
        titleTextField.layer.cornerRadius = 8.0
        
        //        describtionTextField.clipsToBounds = true
        //        describtionTextField.layer.cornerRadius = 8.0
        //
        locationTextField.clipsToBounds = true
        locationTextField.layer.cornerRadius = 8.0
        
        productTypeTextField.clipsToBounds = true
        productTypeTextField.layer.cornerRadius = 8.0
        
        
        
        postProductButton.clipsToBounds = true
        postProductButton.layer.cornerRadius = 8.0
 
  
    productTypeTextField.addTapGestureRecognizer {
    
    self.view.endEditing(true)
    
    let actionSheet = TwitterActionController()
    // set up a header title
    actionSheet.headerData = "Sort by Product Type"
    // Add some actions, note that the first parameter of `Action` initializer is `ActionData`.
    actionSheet.addAction(Action(ActionData(title: "Brand New", subtitle: "product type is Brand New ", image: UIImage(named: "Board")!), style: .default, handler: { action in
    // do something useful
    self.productTypeTextField.text = "Brand New"
    
    
    }))
    
    actionSheet.addAction(Action(ActionData(title: "Used, Open Box", subtitle: "product type is Used, Open Box ", image: UIImage(named: "Board")!), style: .default, handler: { action in
    // do something useful
    self.productTypeTextField.text = "Used, Open Box"
    
    }))
    actionSheet.addAction(Action(ActionData(title: "Refurbished", subtitle: "product type is Refurbished ", image: UIImage(named: "Board")!), style: .default, handler: { action in
    // do something useful
    self.productTypeTextField.text = "Refurbished"
    
    }))
    actionSheet.addAction(Action(ActionData(title: "Recondition", subtitle: "product type is Recondition ", image: UIImage(named: "Board")!), style: .default, handler: { action in
    // do something useful
    self.productTypeTextField.text = "Recondition"
    
    }))
    actionSheet.addAction(Action(ActionData(title: "Used", subtitle: "product type is Used ", image: UIImage(named: "Board")!), style: .default, handler: { action in
    // do something useful
    self.productTypeTextField.text = "Used"
    
    }))
    
    // present actionSheet like any other view controller
    self.present(actionSheet, animated: true, completion: nil)
    
    }
        
        
    
}
    func animationStart(){
        
        self.boatAnimation = LOTAnimationView(name: "142-loading-animation.json")
        // Set view to full screen, aspectFill
        self.boatAnimation!.autoresizingMask = [.flexibleWidth]
        self.boatAnimation!.contentMode = .scaleAspectFit
        self.boatAnimation!.frame = self.view.bounds
        // Add the Animation
        self.view.addSubview(self.boatAnimation!)
        self.boatAnimation?.play()
        self.boatAnimation?.animationSpeed = 2
        self.boatAnimation?.loopAnimation = true
    }
    func animationStop(){
        
        self.boatAnimation?.removeFromSuperview()
        
    }

private func warningMessage(title:String,subtitle:String){
    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
    // files in the main bundle first, so you can easily copy them into your project and make changes.
    let view = MessageView.viewFromNib(layout: .cardView)
    
    // Theme message elements with the warning style.
    view.configureTheme(.error)
    view.button?.isHidden = true
    var config = SwiftMessages.Config()
    config.presentationContext = .window(windowLevel: .statusBar)
    
    // Add a drop shadow.
    view.configureDropShadow()
    
    // Set message title, body, and icon. Here, we're overriding the default warning
    // image with an emoji character.
    let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
    view.configureContent(title: title, body: subtitle, iconText: iconText)
    
    // Increase the external margin around the card. In general, the effect of this setting
    // depends on how the given layout is constrained to the layout margins.
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // Reduce the corner radius (applicable to layouts featuring rounded corners).
    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
    
    // Show the message.
    SwiftMessages.show(config: config, view: view)
    
}

private func successMessage(title:String,subtitle:String){
    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
    // files in the main bundle first, so you can easily copy them into your project and make changes.
    let view = MessageView.viewFromNib(layout: .cardView)
    
    // Theme message elements with the warning style.
    view.configureTheme(.success)
    view.button?.isHidden = true
    var config = SwiftMessages.Config()
    config.presentationContext = .window(windowLevel: .statusBar)
    
    // Add a drop shadow.
    view.configureDropShadow()
    
    
    // Set message title, body, and icon. Here, we're overriding the default warning
    // image with an emoji character.
    //        let iconText = ["", "", "", ""].sm_random()!
    view.configureContent(title: title, body: subtitle)
    
    // Increase the external margin around the card. In general, the effect of this setting
    // depends on how the given layout is constrained to the layout margins.
    view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // Reduce the corner radius (applicable to layouts featuring rounded corners).
    (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
    
    SwiftMessages.show(config: config, view: view)
    
}
    
    
}




//API Calling

extension CameraVC{
    
    func uploadImagesFile(){
        
        self.animationStart()
        _ = uploadImages!
        
        let parameters: [String : Any]? = [
            
            "user_id": UserDefaults.standard.string(forKey: "ID")!,
            "category_id" : String(categeortType),
            "type" : productTypeTextField.text!,
            "title" : titleTextField.text!,
            "description" : describtionTextView.text!,
            "price" : priceTextField.text!,
            ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                // for (index,image) in imageData.enumerated() {
                if let imageData = uploadImages?.first?.jpegData(compressionQuality: 0.3){
                    multipartFormData.append(imageData, withName: "images[]", fileName: "images", mimeType: "image/png")  }
                // }
                
                for (key, value) in parameters! {
                    
                    if key == "images"{
                        
                        //                             multipartFormData.append(value, withName: "images")
                        
                    } else{
                        
                        multipartFormData.append((value as! String).data(using:.utf8)!, withName: key as! String)
                        
                    }
                    
                    
                }
        },
            to: "http://198.199.80.106/api/v1/product/upload",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        print(response)
                        
                        debugPrint("SUCCESS RESPONSE: \(response)")
                        self.animationStop()
                        
                        self.tabBarController?.selectedIndex = 0
                        //                                    self.dismiss(animated: true, completion: nil)
                        self.successMessage(title: "Product Uploaded", subtitle: "Your product Upload Successfully")
                        
                    }
                case .failure(let encodingError):
                    // hide progressbas here
                    print("ERROR RESPONSE: \(encodingError)")
                    self.animationStop()
                    
                }
                
        })
        
    }
    
    func UpdateUserLocation(){
        
        
        let parameters: [String : Any]? = [
            "id": UserDefaults.standard.string(forKey: "ID") ?? 0,
            "address" : locationTextField.text!,
            "latitude" : "88",
            "longitude" : "88"
        ]
        
        Alamofire.request("http://198.199.80.106/api/v1/profile/update", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{
                                
                                print(data)
                                
                                
                            }
                            
                            
                        }
                        else{
                            let errorMsg = jsonRoot["error"] as! String
                            print(errorMsg)
                            
                            
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
        
    }
    
}


//Collection View Delegate

extension CameraVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        describtionTextView.text = ""
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  (uploadImages?.count)!
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.image.image = uploadImages![indexPath.row]
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 8.0
            cell.image.clipsToBounds = true
            cell.clipsToBounds = true
            cell.image.layer.cornerRadius = 8.0
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 90 , height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        return CGSize(width: 90 , height: 90)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
        
        headerView.addTapGestureRecognizer {
            
            categeortType = indexPath.row + 1
            let gallery = GalleryController()
            gallery.delegate = self
            self.present(gallery, animated: true, completion: nil)
            
        }
        return headerView
    }

}

// Custom Delegate and Gallery Picker

extension CameraVC:GalleryControllerDelegate,CastHandlerDelegate{
    func launchObjectSuccess() {
        
        
    }
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        Image.resolve(images: images) { (imagesFile) in
            
            uploadImages = imagesFile as? [UIImage]

            controller.dismiss(animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
        controller.dismiss(animated: true, completion: nil)
        
    }
}
