//
//  ProductNavigateVCViewController.swift
//  Keeno
//
//  Created by Sanzid on 4/11/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import ImageSlideshow
import MapKit
import SDWebImage
import CoreLocation
import Lottie
import SwiftMessages
import Alamofire


class ProductNavigateVCViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var productCondition: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var productLocation: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productTime: UILabel!
    @IBOutlet weak var imageSlideshow: ImageSlideshow!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var makeOfferButton: UIButton!
    private var boatAnimation: LOTAnimationView?

    
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    var ID = 0
    
    var proPrice = 0
    var proTitle = ""
    var proLocation = ""
    var proTime = ""
    var proDescribtion = ""
    var proCondition = ""

    var imageURL = ""
    var imageSource: [ImageSource] = []


    
    
    override func viewDidLoad() {
        
        print(ID)
        
        super.viewDidLoad()
//        for image in self.imageURL {
//            let img = image
//            imageSource.append(SDWebImageSource(urlString: img) ?? "")
//        }
        self.imageSlideshow.setImageInputs([SDWebImageSource(urlString: imageURL)!])
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = 1.0
        manager.startUpdatingLocation()
        mapKit.showsUserLocation = true
        
        


        self.title = "Product Details"
        SetUpUIComponent()
        print(imageURL)
        
    }
    
    @IBAction func loveButtonAction(_ sender: Any) {
        
        favouriteItemPost()
        
    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        let shareText = "Keeno \n 1.list your product most easy way \n 2.buy product around your location \n 3.Boost your product for reaching more people and sale faster"
        
        if let image = UIImage(named: "Board") {
            let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: nil)
            present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //manager.stopUpdatingLocation()
        
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09))
            self.mapKit.setRegion(region, animated: true)
            
        }
    
        
        geocoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
            }
            
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                // self.locality = placemark.locality!
                //self.locationTextField.text = placemark.locality!
                self.productLocation.text = placemark.subAdministrativeArea

                
            }
        })
    }


}

extension ProductNavigateVCViewController{
    
    func SetUpUIComponent(){
        
        makeOfferButton.clipsToBounds = true
        makeOfferButton.layer.cornerRadius = 8.0
        makeOfferButton.layer.borderColor = UIColor.lightGray.cgColor
        makeOfferButton.layer.borderWidth = 1.0
   
        chatButton.clipsToBounds = true
        chatButton.layer.cornerRadius = 8.0
        chatButton.layer.borderColor = UIColor.lightGray.cgColor
        chatButton.layer.borderWidth = 1.0
        
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = shareButton.frame.height/2
        
        favouriteButton.clipsToBounds = true
        favouriteButton.layer.cornerRadius = favouriteButton.frame.height/2
        
        priceButton.clipsToBounds = true
        priceButton.layer.cornerRadius = 8.0
        
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        
        
        imageSlideshow.slideshowInterval = 5.0
        imageSlideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideshow.activityIndicator = DefaultActivityIndicator()
        //imageSlideshow.delegate = self
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
       // imageSlideshow.setImageInputs(imageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductNavigateVCViewController.didTap))
        imageSlideshow.addGestureRecognizer(recognizer)
        
        productTitle.text = proTitle
        priceButton.setTitle("TK " + String(proPrice), for: .normal)
        productDescription.text = proDescribtion
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        "created_at": "2019-03-21 14:21:37",

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: proTime) {
            
            productTime.text = "Posted : " + timeAgoSinceDate(date, currentDate: Date(), numericDates: true)

            
        }
        productCondition.text = proTitle + " (" + proCondition + ") "
    
    }
    @objc func didTap() {
        
        let fullScreenController = imageSlideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
}



func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago "
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago "
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) week ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) day ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hour ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minute ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
    
}


extension ProductNavigateVCViewController {
    
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
    
    func  favouriteItemPost(){
        
        self.animationStart()
       // sharebu
        
        shareButton.setImage(UIImage(named: "like"), for: .normal)
        let parameters: [String : Any]? = [
            "user_id": UserDefaults.standard.string(forKey: "ID")!,
            
            "liked_product_id[]":ID,
            
            ]
        
        Alamofire.request("http://198.199.80.106/api/v1/favourite/add", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{
                                print(data)
                                self.animationStop()
                                self.successMessage(title: "Saved product", subtitle: "Successfully saved product")
                            
                            }
                            
                            
                        }
                        else{
                            self.animationStop()
                            let errorMsg = jsonRoot["error"] as! String
                           // self.warningMessage(title: "Warning", subtitle: errorMsg)
                            self.successMessage(title: "Saved product", subtitle: "Successfully saved product")

                            //print(errorMsg)
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    self.animationStop()
                    
                    
                }
            }
        }
        
        
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


