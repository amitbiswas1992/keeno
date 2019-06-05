//
//  ForgotPasswordVC.swift
//  Keeno
//
//  Created by Sanzid on 4/21/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftMessages
import Lottie

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    private var boatAnimation: LOTAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
          getUserEdit()
        
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
    
    // Initailly work with User edit But needed to change
    
    private func getUserEdit(){
        
        
        self.animationStart()
        
        let parameters: [String : Any]? = [
            "id": UserDefaults.standard.string(forKey: "ID") ?? 0,
            "password" : passwordTextField.text!,
            "new_password": confirmPasswordTextField.text!,
            ]
        
        Alamofire.request("http://198.199.80.106/api/v1/profile/update", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{
                                print(data)
                                self.animationStop()
                                self.navigationController?.popViewController(animated: true)
                                self.successMessage(title: "Password Changed", subtitle: "Successfully Changed the password")
                                
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

}
