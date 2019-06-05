//
//  ViewController.swift
//  Sheba
//
//  Created by Sanzid iOS on 3/7/18.
//  Copyright © 2018 Sanzid Ashan. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import YPImagePicker
import Lottie



protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}


class MenuViewController: UIViewController{
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet var tableMenuOptions : UITableView!
    @IBOutlet weak var cameraView: UIView!
    private var boatAnimation: LOTAnimationView?

    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var buttonCloseMenuOverlay : UIButton!
    var arrayMenuOptions = [Dictionary<String,String>]()
    var buttonMenu : UIButton!
    var delegate : SlideMenuDelegate?
    let menuTitle = ["My Product","Saved Item","Payment","Invite Friend","Settings"]
    let menuIcon = ["","","","",""]
    let menuIconImage = [UIImage(named: "My_Product"),UIImage(named: "Save_item"),UIImage(named: "payment"),UIImage(named: "invite_frd"),UIImage(named: "settings")]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableMenuOptions.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 120.0, right: 0.0)
        navigationController?.navigationItem.leftBarButtonItem = nil
        editProfileButton.clipsToBounds = true
        editProfileButton.layer.cornerRadius = 4.0
        editProfileButton.layer.borderWidth = 1.0
        editProfileButton.layer.borderColor = UIColor.gray.cgColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
        self.setDrawerMenus()
        self.setUserProfile()
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.layer.borderColor = UIColor(rgba:"#6747CE").cgColor
        profileImage.layer.borderWidth = 1.0
        
        profileImage.addTapGestureRecognizer {
            self.closeMenu(with: -1, button: self.buttonMenu)
            //        navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationItem.leftBarButtonItem = nil
            
            var config = YPImagePickerConfiguration()
            
            config.isScrollToChangeModesEnabled = true
            config.onlySquareImagesFromCamera = true
            config.usesFrontCamera = true
            config.showsFilters = false
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = "Keeno"
            config.colors.navigationBarActivityIndicatorColor = UIColor.green
            config.startOnScreen = YPPickerScreen.library
            config.screens = [.library, .photo]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            let picker = YPImagePicker(configuration: config)
            
            self.navigationController?.navigationBar.prefersLargeTitles = true
            
            
            //let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    print(photo.fromCamera) // Image source (camera or library)
                    print(photo.image) // Final image selected by the user
                    print(photo.originalImage) // original image selected by the user, unfiltered
                    
                    self.getUserEdit(profileImage:photo.originalImage)
                    
                }
                picker.dismiss(animated: true, completion: nil)
            }
            
            self.present(picker, animated: true, completion: nil)
        }
        
        cameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = cameraView.frame.height/2
        
        cameraView.addTapGestureRecognizer {
            
            self.closeMenu(with: -1, button: self.buttonMenu)
            //        navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationItem.leftBarButtonItem = nil
        
            
            
            
            var config = YPImagePickerConfiguration()
            
            config.isScrollToChangeModesEnabled = true
            config.onlySquareImagesFromCamera = true
            config.usesFrontCamera = true
            config.showsFilters = false
            config.shouldSaveNewPicturesToAlbum = true
            config.albumName = "Keeno"
            config.colors.navigationBarActivityIndicatorColor = UIColor.green
            config.startOnScreen = YPPickerScreen.library
            config.screens = [.library, .photo]
            config.showsCrop = .none
            config.targetImageSize = YPImageSize.original
            config.overlayView = UIView()
            config.hidesStatusBar = true
            config.hidesBottomBar = false
            config.preferredStatusBarStyle = UIStatusBarStyle.default
            let picker = YPImagePicker(configuration: config)
            
            self.navigationController?.navigationBar.prefersLargeTitles = true

            
            //let picker = YPImagePicker()
            picker.didFinishPicking { [unowned picker] items, _ in
                if let photo = items.singlePhoto {
                    print(photo.fromCamera) // Image source (camera or library)
                    print(photo.image) // Final image selected by the user
                    print(photo.originalImage) // original image selected by the user, unfiltered
                    
                    self.getUserEdit(profileImage:photo.originalImage)
                    
                }
                picker.dismiss(animated: true, completion: nil)
            }
            
            self.present(picker, animated: true, completion: nil)
            
            
            
        }
        
        

    }
    
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        
              //let tabBar = TabBarVC()
             // tabBar.selectedIndex = 4
        
             self.closeMenu(with: sender.tag, button: sender)
             let inititalViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            // inititalViewController.selectedIndex = 4
            self.show(inititalViewController, sender: nil)
        
        
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
    
    private func setUserProfile(){
//        guard let userData = UserInfoLocalData.getUserData() else{
//            return
//        }
//        self.setProfileImage()
    }
    
    private func setProfileImage(){
        
        //        guard !(UserInfoLocalData.getUserData()?.profile!.isEmpty)! else{
        //            return
        //        }
        //        guard let url = (UserInfoLocalData.getUserData()?.profile!) else{
        //            return
        //        }
        //        self.profilePic.sd_setImage(with: URL(string:  url), placeholderImage: UIImage(named: "placeholder.png"))
        
    }
    private func setDrawerMenus(){
    
        
        for i in 0..<menuTitle.count{
                
                arrayMenuOptions.append(["title":menuTitle[i], "icon":menuIcon[i]])
        }
  
        tableMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        self.closeMenu(with: button.tag, button: button)
        //        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationItem.leftBarButtonItem = nil
        
        
    }
    
    func closeMenu(with tag:Int, button:UIButton){
        buttonMenu.tag = 0
        if (self.delegate != nil) {
            var index = Int32(tag)
            if(button == self.buttonCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
        
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        let labelTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let labelImage : UIImageView = cell.contentView.viewWithTag(102) as! UIImageView

        
        labelTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        labelImage.image = menuIconImage[indexPath.row]

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

// API Calling Actions
extension MenuViewController{
    private func getUser(){

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
//                          self.profileImage.sd_setImage(with: URL(string: profilePic), completed: nil)
                                self.profileImage.sd_setImage(with: URL(string: profilePic ?? ""), placeholderImage: UIImage(named: "profile_cover"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
                                
                          let email = data["email"] as? String
                          self.emailLabel.text = email
                                
                                
                          let name = data["name"] as? String
                          self.profileName.text = name
                                
        
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
    
    private func getUserEdit(profileImage:UIImage){
    
        self.animationStart()

        let image = profileImage
        //       imageProfile = image
        let imageData = image.jpegData(compressionQuality: 0.3)
        //UIImageJPEGRepresentation(profileImage, 0.2)!
    
        let parameters: [String : Any]? = [
            "id": String(UserDefaults.standard.string(forKey: "ID") ?? ""),
            ]
    
        let URL = try! URLRequest(url: "http://198.199.80.106/api/v1/profile/update", method: .post)
    
        Alamofire.upload(multipartFormData: {
            multipartFormData in
    
            multipartFormData.append(imageData!, withName: "profile_picture", fileName: "file.png", mimeType: "image/png")
    
            for (key, value) in parameters! {
    
                multipartFormData.append((value as! String).data(using:.utf8)!, withName: key as! String)
    
            }
    
    
    
        }, with: URL, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
    
                upload.responseJSON { response in
                    self.animationStop()
                    debugPrint("SUCCESS RESPONSE: \(response)")
    
    
                }
            case .failure(let encodingError):
                // hide progressbas here
                print("ERROR RESPONSE: \(encodingError)")
                self.animationStop()

    
    
    
            }
        })
    
    
    
    }
//    private func getUserEdit(profileImage:UIImage){
//
//        let parameters: [String : Any]? = [
//            "id": 9,
//            "name" : profileName.text!,
//            "email": emailLabel.text!,
//            "new_password" : "123456",
//            "password": "123456",
//            "profile_picture" : profileImage.pngData()!,
//                //profileImage!,
//            "cover_picture": "",
//            "latitude" : "123456",
//            "longitude": "123456",
//            "address" : "Dhaka",
//            "phone" : "123456",
//
//            ]
//
//        Alamofire.request("http://198.199.80.106/api/v1/profile/update", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
//
//            if response.result.value != nil {
//                switch response.result {
//
//                case .success:
//                    if let jsonRoot = response.result.value as? [String:Any]{
//
//                        if (jsonRoot["data"] as? [String:Any]) != nil{
//
//                            if let data = jsonRoot["data"] as? [String:Any]{
//
//                                print(data)
//
//                            }
//
//
//                        }
//                        else{
//                            let errorMsg = jsonRoot["error"] as! String
//                            print(errorMsg)
//                        }
//
//                    }
//                case .failure(let error):
//                    print(error)
//
//                }
//            }
//        }
//    }
}



//private func getUserEdit(profileImage:UIImage){
//
//
//    let image = profileImage
//    //       imageProfile = image
//    let imageData = image.jpegData(compressionQuality: 0.3)
//    //UIImageJPEGRepresentation(profileImage, 0.2)!
//
//    let parameters: [String : Any]? = [
//        "id": "9",
//        "name" : profileName.text!,
//        "email": emailLabel.text!,
//        "new_password" : "123456",
//        "password": "123456",
//        "latitude" : "123456",
//        "longitude": "123456",
//        "address" : "Dhaka",
//        "phone" : "123456",
//
//        ]
//
//    let URL = try! URLRequest(url: "http://198.199.80.106/api/v1/profile/update", method: .post)
//
//    Alamofire.upload(multipartFormData: {
//        multipartFormData in
//
//        multipartFormData.append(imageData!, withName: "file", fileName: "file.png", mimeType: "image/png")
//
//        for (key, value) in parameters! {
//
//            multipartFormData.append((value as! String).data(using:.utf8)!, withName: key as! String)
//
//        }
//
//
//
//    }, with: URL, encodingCompletion: {
//        encodingResult in
//        switch encodingResult {
//        case .success(let upload, _, _):
//
//            upload.responseJSON { response in
//                debugPrint("SUCCESS RESPONSE: \(response)")
//
//
//            }
//        case .failure(let encodingError):
//            // hide progressbas here
//            print("ERROR RESPONSE: \(encodingError)")
//
//
//
//        }
//    })
//
//
//
//}
