//
//  SettingsVC.swift
//  BuySellApp
//
//  Created by Sanzid on 4/5/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI



class SettingsVC: UIViewController ,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate{
    
    
    
    @IBOutlet weak var contractUsView: UIView!
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var privacy: UIView!
    @IBOutlet weak var terms: UIView!
    @IBOutlet weak var help: UIView!
    @IBOutlet weak var logout: UIView!
    
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var locality = ""
    var administrativeArea = ""
    var country = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        privacy.addTapGestureRecognizer {
            if let url = URL(string: "https://keeno.app/privacy-policy") {
                UIApplication.shared.open(url, options: [:])
            }
            
        }
        terms.addTapGestureRecognizer {
            if let url = URL(string: "https://keeno.app/privacy-policy") {
                UIApplication.shared.open(url, options: [:])
            }
            
        }
        help.addTapGestureRecognizer {
           // CollapsibleTableViewController
            
            let vc = CollapsibleTableViewController()
            self.navigationController?.pushViewController(vc, animated: true)


//            let inititalViewController = UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
//            self.show(inititalViewController, sender: nil)
            
        }
        
        logout.addTapGestureRecognizer {
            
//            let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
//
//            self.navigationController?.pushViewController(inititalViewController, animated: true)
            
            
            UserDefaults.standard.removeObject(forKey: "ID2")
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            var vc : UIViewController
            vc = storyBoard.instantiateInitialViewController()!
            self.show(vc, sender: nil)
        
            
        }
        
        contractUsView.addTapGestureRecognizer {
            
            let mailComposeViewController = self.configureMailComposer()
            if MFMailComposeViewController.canSendMail(){
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else{
                print("Can't send email")
            }
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["amit@mazegeek.com"])
        mailComposeVC.setSubject("Suggest Keeno")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
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
               // self.locality = placemark.locality!
               // self.location.text = placemark.locality!
                self.location.text = placemark.administrativeArea!
                self.country = placemark.country!
            }
        })
    }
    
    func userLocationString() -> String {
        let userLocationString = "\(locality), \(administrativeArea), \(country)"
        return userLocationString
    }

}
