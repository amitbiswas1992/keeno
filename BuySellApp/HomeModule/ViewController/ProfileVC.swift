//
//  ProductDetailsVC.swift
//  BuySellApp
//
//  Created by Sanzid on 2/27/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import YPImagePicker
import Alamofire
import Lottie
import SwiftMessages
import SDWebImage



class ProfileVC: BaseViewController {
    
    //Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var profileCamera: UIView!
    @IBOutlet weak var coverCamera: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var newPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var phnNumberField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var new2Password: SkyFloatingLabelTextFieldWithIcon!
    private var boatAnimation: LOTAnimationView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIComponent()
        addSlideMenuButton()
        getUser()
    }
    
    
    //Button Action
    @IBAction func saveButtonAction(_ sender: Any) {
        self.getUserEdit()
    }
}

// SetUp UIElements

extension ProfileVC{
    private func setUpUIComponent(){
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 6.0
        coverCamera.clipsToBounds = true
        coverCamera.layer.cornerRadius = 8.0
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.layer.borderWidth = 2.0
        profilePhoto.layer.borderColor = UIColor(rgba:"#6747CE").cgColor
        profileCamera.clipsToBounds = true
        profileCamera.layer.cornerRadius = profileCamera.frame.height/2
        profileCamera.addTapGestureRecognizer {
            
            var config = YPImagePickerConfiguration()
            config.isScrollToChangeModesEnabled = true
            config.onlySquareImagesFromCamera = true
            config.usesFrontCamera = true
            config.showsFilters = false
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = "DefaultYPImagePickerAlbumName"
            config.startOnScreen = YPPickerScreen.library
            config.screens = [.library, .photo]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            config.showsFilters = true
            config.wordings.next = "Select"
            config.wordings.libraryTitle = "Keeno Library"
            config.wordings.cameraTitle = "Keeno Camera"

            let picker = YPImagePicker(configuration: config)
            
            //let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    print(photo.fromCamera) // Image source (camera or library)
                    print(photo.image) // Final image selected by the user
                    print(photo.originalImage) // original image selected by the user, unfiltered
                    
                    self.profilePhoto.image = photo.originalImage
                    
                }
                picker.dismiss(animated: true, completion: nil)
            }
            self.present(picker, animated: true, completion: nil)
            
        }
        
        coverCamera.addTapGestureRecognizer {
            var config = YPImagePickerConfiguration()
            config.isScrollToChangeModesEnabled = true
            config.onlySquareImagesFromCamera = true
            config.usesFrontCamera = true
            config.showsFilters = false
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = "DefaultYPImagePickerAlbumName"
            config.startOnScreen = YPPickerScreen.photo
            config.screens = [.library, .photo]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            config.showsFilters = true
            config.wordings.next = "Select"
            config.wordings.libraryTitle = "Keeno Library"
            config.wordings.cameraTitle = "Keeno Camera"
            
            let picker = YPImagePicker(configuration: config)
            
            //let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    print(photo.fromCamera) // Image source (camera or library)
                    print(photo.image) // Final image selected by the user
                    print(photo.originalImage) // original image selected by the user, unfiltered
                    
                    self.coverPhoto.image = photo.originalImage
                    self.getUserEdit()
                    //self.getUser()

                    
                    
                }
                picker.dismiss(animated: true, completion: nil)
            }
            self.present(picker, animated: true, completion: nil)
        }
        
        
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
    
    
    func converDate(date:String){
        
    
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM dd,yyyy"
    
    if let date = dateFormatterGet.date(from: date) {
        self.joinedLabel.text = "Updated at : " +  dateFormatterPrint.string(from: date)

    } else {
    print("There was an error decoding the string")
    }
    
}
}


// API Calling Actions
extension ProfileVC{
    
    private func getUser(){
        
        self.animationStart()
        
        let parameters: [String : Any]? = [
            "id": UserDefaults.standard.string(forKey: "ID") ?? 0,
            ]
        
        Alamofire.request("http://198.199.80.106/api/v1/profile", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{

                                print(data)
                                let profilePic = data["profile_picture_url"] as? String
                                let coverPic = data["cover_picture_url"] as? String
                                let date = data["updated_at"] as? String
                                self.converDate(date: date!)

                                self.coverPhoto.sd_setImage(with: URL(string: coverPic ?? ""), placeholderImage: UIImage(named: "profile_cover"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
                                self.profilePhoto.sd_setImage(with: URL(string: profilePic ??  ""), placeholderImage: UIImage(named: "profile_cover"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)

                                let email = data["email"] as? String
                                self.emailField.text = email
                                let name = data["name"] as? String
                                let phone = data["phone"] as? String
                                self.phnNumberField.text = phone
                                self.nameField.text = name
                                //self.newPassword.text = "123456"
                                self.nameLabel.text = name
                                self.animationStop()
                                self.animationStop()
                                
                            }
                            
                            
                        }
                        else{
                            let errorMsg = jsonRoot["error"] as! String
                            print(errorMsg)
                            self.warningMessage(title: "Warning", subtitle: errorMsg)
                            self.animationStop()

                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
}
    
    
    private func getUserEdit(){
        self.animationStart()
        
        //       imageProfile = image
        let imageDataProfile = profilePhoto.image?.jpegData(compressionQuality: 0.3)
        let imageDataProfileCover = coverPhoto.image?.jpegData(compressionQuality: 0.3)

            //image.jpegData(compressionQuality: 0.3)
        
                 var parameters: [String : Any]?
        
        if newPassword.text != "" || new2Password.text != ""{
            
            parameters = [
                "id": String(UserDefaults.standard.string(forKey: "ID") ?? ""),
                "name" : nameField.text!,
                "email": emailField.text!,
                "latitude" : "123456",
                "longitude": "123456",
                "address" : "Dhaka",
                "phone" : phnNumberField.text!,
                "password" : newPassword.text!,
                "new_password": new2Password.text!,
                
            ]
            
        }
        else{
            parameters = [
                "id": String(UserDefaults.standard.string(forKey: "ID") ?? ""),
                "name" : nameField.text!,
                "email": emailField.text!,
                "latitude" : "123456",
                "longitude": "123456",
                "address" : "Dhaka",
                "phone" : phnNumberField.text!,
                
            ]
            
        }
        
        let URL = try! URLRequest(url: "http://198.199.80.106/api/v1/profile/update", method: .post)
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            multipartFormData.append(imageDataProfile!, withName: "profile_picture", fileName: "file.png", mimeType: "image/png")
            multipartFormData.append(imageDataProfileCover!, withName: "cover_picture", fileName: "file.png", mimeType: "image/png")

            for (key, value) in parameters! {
                
                multipartFormData.append((value as! String).data(using:.utf8)!, withName: key as! String)
                
            }
            
            
            
        }, with: URL, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    debugPrint("SUCCESS RESPONSE: \(response)")
                    self.successMessage(title: "profile Changed", subtitle: "profile Changed Successfully")
                    self.animationStop()
                    self.getUser()
                    
                    
                }
            case .failure(let encodingError):
                // hide progressbas here
                print("ERROR RESPONSE: \(encodingError)")
                self.warningMessage(title: "Warning", subtitle: encodingError as! String)
                self.animationStop()
                
            }
        })
        
        
        
    }
    

}
