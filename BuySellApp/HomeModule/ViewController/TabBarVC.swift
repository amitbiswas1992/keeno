//
//  TabBarVC.swift
//  BuySellApp
//
//  Created by Sanzid on 2/27/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import Alamofire
import Gallery
import SPPermission
import RevealingSplashView

// Upload Images Save Array
var uploadImages : [UIImage]?
class TabBarVC: UITabBarController {
    
    var isAnimated = true
    var menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    private var revealingLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMiddleButton()
        self.UISetUp()
        // Do any additional setup after loading the view.
    }
}

//Galery Picker Delegate

extension TabBarVC:GalleryControllerDelegate{

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


//SetUp UI Elements

extension TabBarVC{
    
    private func UISetUp(){
        self.view.backgroundColor = UIColor.white
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "icon_1024")!,iconInitialSize: CGSize(width: 140, height: 140), backgroundColor: UIColor.white)
        
        //        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "twitterLogo")!, iconInitialSize: CGSize(width: 70, height: 70), backgroundImage: UIImage(named: "splashscreen")!)
        
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.duration = 4.0
        
        revealingSplashView.iconColor = UIColor.red
        revealingSplashView.useCustomIconColor = false
        
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
        
        revealingSplashView.startAnimation(){
            self.revealingLoaded = true
            self.setNeedsStatusBarAppearanceUpdate()
            let isAllowedCamera = SPPermission.isAllowed(.camera)
            let isAllowedLocation = SPPermission.isAllowed(.locationWhenInUse)
            let isAllowedMedia = SPPermission.isAllowed(.photoLibrary)
            
            
            if (isAllowedCamera == false || isAllowedLocation == false || isAllowedMedia == false){
                UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
                
                SPPermission.Dialog.request(
                    with: [.camera,.locationWhenInUse,.photoLibrary],
                    on: self,
                    delegate: self,
                    dataSource: self
                )
                
            }
            else{
                
                
            }
            
        }
        
    }
    
    func setupMiddleButton() {
        
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 10
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor.clear
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        menuButton.setImage(UIImage(named: "Group"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc private func menuButtonAction(sender: UIButton) {
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Nav", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CategeortVC") as! CategeortVC
        vc.view.backgroundColor = UIColor.clear
        //lightGray.withAlphaComponent(0.5)
        //self.definesPresentationContext = true
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)

    }
    
}


//Delegate Function
extension TabBarVC:CastHandlerDelegate{
    
    func launchObjectSuccess() {
        self.selectedIndex = 2
    }
}
