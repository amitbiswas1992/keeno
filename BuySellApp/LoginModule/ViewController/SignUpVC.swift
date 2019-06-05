//
//  SignUpVC.swift
//  BuySellApp
//
//  Created by Sanzid on 2/22/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftMessages
import Lottie


class SignUpVC: UIViewController {
    //Outlets
    @IBOutlet weak var enterName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextFieldWithIcon!
    // Animation Loader
    private var boatAnimation: LOTAnimationView?

    // Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIComponent()
        // Do any additional setup after loading the view.
    }
    
    
    //  Buttom Actions
    @IBAction func signUpOnClickAction(_ sender: Any) {
        
        if passwordTextField.text == confirmPassTextField.text{
            registerUser()

        }
        else{
            self.warningMessage(title: "Password mismatch", subtitle: "Please check your password")
        }
        
    }
    
}


// Sign Up UI Elements
extension SignUpVC{
    
    private func setUpUIComponent(){
        self.navigationController?.navigationBar.prefersLargeTitles = false
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

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
    private func configureDropShadow() {
        let layer = signUpView.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        updateShadowPath()
    }
    
    private func updateShadowPath() {
        signUpView.layer.shadowPath = UIBezierPath(roundedRect: signUpView.layer.bounds, cornerRadius: signUpView.layer.cornerRadius).cgPath
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

// TextField Delegate
extension SignUpVC:UITextFieldDelegate{
    
    // This will notify us when something has changed on the textfield
    @objc func textFieldDidChange(_ textfield: UITextField) {
        if let text = textfield.text {
            if let floatingLabelTextField = textfield as? SkyFloatingLabelTextField {
                if(text.count < 3 || !text.contains("@") || !text.contains(".")) {
                    floatingLabelTextField.errorMessage = "Invalid email"
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
}

// Sign Up API Call
extension SignUpVC{
    
    func registerUser(){
        self.animationStart()
        let parameters: [String : Any]? = [
            "name":enterName.text!,
            "email":emailTextField.text!,
            "password":passwordTextField.text!,

            ]
        Alamofire.request(RestURL.sharedInstance.PostRegisterAPI, method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{
                                print(data)
                                let id = data["id"] as! Int
                                UserDefaults.standard.set(id, forKey: "ID")
                                UserDefaults.standard.set("C", forKey: "ID2")
                                print(UserDefaults.standard.string(forKey: "ID") ?? 0)
                                UserDefaults.standard.set("animation", forKey: "animation")

                                self.animationStop()
                                let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                self.show(inititalViewController, sender: nil)
                            }
                          
                            
                        }
                        else{
                            self.animationStop()
                            let errorMsg = jsonRoot["error"] as! String
                            self.warningMessage(title: "Warning", subtitle: errorMsg)
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
