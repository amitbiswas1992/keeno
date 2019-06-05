//
//  CategeortVC.swift
//  BuySellApp
//
//  Created by Sanzid on 3/27/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Gallery
import ZMSwiftRangeSlider
import XLActionController
import CoreLocation


protocol FilterHandlerDelegate: class {
    
    /// Media Launched successfully on the cast device
    func launchObjectSuccess(cate: Int, priceLow: Int, priceHigh: Int, sortBy: String, from: String)
    
}

class FilterVC: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var sortTextField: UITextField!
    @IBOutlet weak var categeoryCollection: UICollectionView!
    weak var delegate: FilterHandlerDelegate?
    
    var categeory = 0

    
    
    @IBOutlet weak var applyFilterButton: UIButton!
    @IBOutlet weak var rangeSlider1: RangeSlider!

    @IBOutlet weak var topView: UIView!
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var locality = ""
    var administrativeArea = ""
    var country = ""
    
    var imageArray : Array<CategeoryMapper> = []
    var imageDummy  = ["001-car","002-shop","003-mobile-phone","004-chair","005-scooter","006-dress","007-baby"]

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        applyFilterButton.clipsToBounds = true
        applyFilterButton.layer.cornerRadius = 8.0
        
        view.isOpaque = false
       // view.backgroundColor = .clear
        
   
        //sortTextField.isEnabled = false
        sortTextField.addTapGestureRecognizer {
            self.view.endEditing(true)
            
            let actionSheet = TwitterActionController()
            // set up a header title
            actionSheet.headerData = "Sort by Product Type"
            // Add some actions, note that the first parameter of `Action` initializer is `ActionData`.
            actionSheet.addAction(Action(ActionData(title: "Brand New", subtitle: "product type is Brand New ", image: UIImage(named: "Board")!), style: .default, handler: { action in
                // do something useful
                self.sortTextField.text = "Brand New"
                
                
            }))
            
            actionSheet.addAction(Action(ActionData(title: "Used, Open Box", subtitle: "product type is Used, Open Box ", image: UIImage(named: "Board")!), style: .default, handler: { action in
                // do something useful
                self.sortTextField.text = "Used, Open Box"
                
            }))
            actionSheet.addAction(Action(ActionData(title: "Refurbished", subtitle: "product type is Refurbished ", image: UIImage(named: "Board")!), style: .default, handler: { action in
                // do something useful
                self.sortTextField.text = "Refurbished"
                
            }))
            actionSheet.addAction(Action(ActionData(title: "Recondition", subtitle: "product type is Recondition ", image: UIImage(named: "Board")!), style: .default, handler: { action in
                // do something useful
                self.sortTextField.text = "Recondition"
                
            }))
            actionSheet.addAction(Action(ActionData(title: "Used", subtitle: "product type is Used ", image: UIImage(named: "Board")!), style: .default, handler: { action in
                // do something useful
                self.sortTextField.text = "Used"
                
            }))
            
            // present actionSheet like any other view controller
            self.present(actionSheet, animated: true, completion: nil)
            // Instantiate custom action sheet controller
//            let actionSheet = TwitterActionController()
//            // set up a header title
//            actionSheet.headerData = "Sort by Filter"
//            // Add some actions, note that the first parameter of `Action` initializer is `ActionData`.
//            actionSheet.addAction(Action(ActionData(title: "New to Old", subtitle: "See product new to old", image: UIImage(named: "Board")!), style: .default, handler: { action in
//                // do something useful
//                self.sortTextField.text = "New to Old"
//
//            }))
//            actionSheet.addAction(Action(ActionData(title: "Old to New", subtitle: "See product old to new", image: UIImage(named: "Board")!), style: .default, handler: { action in
//                // do something useful
//                self.sortTextField.text = "Old to New"
//
//            }))
//            // present actionSheet like any other view controller
//            self.present(actionSheet, animated: true, completion: nil)
            
        }
        let nib = UINib(nibName: "CategoeryCell", bundle: nil)
        categeoryCollection?.register(nib, forCellWithReuseIdentifier: "CategoeryCell")
        getCategeory()
        
        rangeSlider1.setValueChangedCallback { (minValue, maxValue) in
            print("rangeSlider1 min value:\(minValue)")
            print("rangeSlider1 max value:\(maxValue)")
        }
        rangeSlider1.setMinValueDisplayTextGetter { (minValue) -> String? in
            return "\(minValue)K"
        }
        rangeSlider1.setMaxValueDisplayTextGetter { (maxValue) -> String? in
            return "\(maxValue)K"
        }
        rangeSlider1.setMinAndMaxRange(1, maxRange: 99)
        
        topView.addTapGestureRecognizer {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func applyFilterAction(_ sender: Any) {
        
        self.delegate?.launchObjectSuccess(cate: categeory, priceLow: 0, priceHigh: 1000000, sortBy: "", from: "")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        manager.stopUpdatingLocation()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("Error in reverseGeocode")
                return
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                //self.locality = placemark.locality!
                //self.locality = placemark.locality!
                self.location.text = placemark.administrativeArea!
                self.country = placemark.country!
            }
        })
    }
    
    
    
}

extension FilterVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoeryCell", for: indexPath) as! CategoeryCell
        
        // print(imageArray[indexPath.row].icon_url)
        
        cell.logoImage.image = UIImage(named: imageDummy[indexPath.row])
        //sd_setImage(with: URL(string: imageArray[indexPath.row].icon_url), completed: nil)
        cell.nameTitle.text = imageArray[indexPath.row].name
//        cell.imagesMain.image = UIImage(named: imageDummy[indexPath.row])
        
        return cell
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoeryCell", for: indexPath) as! CategoeryCell
        categeory = indexPath.row + 1
       // cell.contentView.backgroundColor = UIColor.green

       // self.dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoeryCell", for: indexPath) as! CategoeryCell
        cell.contentView.backgroundColor = UIColor.clear


    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 120 , height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return -40
    }
    
    
    
}
extension FilterVC {
    func getCategeory(){
        
        let parameters: [String : Any]? = [
            "id": UserDefaults.standard.string(forKey: "ID") ?? 0,
            ]
        
        Alamofire.request("http://198.199.80.106/api/v1/product/categories", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    
                    let data = response.result.value! as? [[String: Any]]
                    
                    
                    for value in data! {
                        
                        guard  let CompititionImage = Mapper<CategeoryMapper>().map(JSON: value) else {
                            continue
                            
                        }
                        
                        self.imageArray.append(CompititionImage)
                    }
                    print(self.imageArray.count)
                    self.categeoryCollection.reloadData()
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
}


extension FilterVC: GalleryControllerDelegate{
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        // uploadImages = images
        Image.resolve(images: images) { (imagesFile) in
            
            //print(uploadImages)
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
