//
//  LandingVC.swift
//  BuySellApp
//
//  Created by Sanzid on 2/26/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import EasySocialButton
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftMessages
import GoogleSignIn
import Lottie
import AccountKit
import RevealingSplashView


class LandingVC: UIViewController {
    // Splash Animation
    private var revealingLoaded = false
    
    // Outlets
    @IBOutlet weak var fbLogin: AZSocialButton!
    @IBOutlet weak var gmailLogin: AZSocialButton!
    @IBOutlet weak var lotieAnimationView: UIView!
    private var boatAnimation: LOTAnimationView?
    var dict : [String : AnyObject]!
    var _accountKit: AKFAccountKit!
    var accessTokenAccountKit = ""
    
    override var shouldAutorotate: Bool {
        return revealingLoaded
    }
    //Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.splashAnimation()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setUpUIComponent()
        self.loginExist()
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        

    }
    
    // Button Actions
    @IBAction func signWithMailAction(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(inititalViewController, animated: true)
        
    }
    @IBAction func signUpMail(_ sender: Any) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.show(inititalViewController, sender: nil)
        
    }
    
    @IBAction func connectWithPhn(_ sender: Any) {
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
        
    }
}

// Set Up UI Elements

extension LandingVC{
    
    private func setUpUIComponent(){
        //configureDropShadow()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func loginExist(){
        fbLoginCall()
        gmailLoginCall()
        if _accountKit?.currentAccessToken != nil {
            //getPhoneNo(accessToken: accessTokenAccountKit)
            _accountKit.requestAccount{[weak self] (account, error) in
                
                let phoneNo = Int((account?.phoneNumber?.phoneNumber)!)
                self!.loginPhonelUser(number: phoneNo!)
            }
            
        }
        else {
            print("Nothing logged In")
        }
        
    }
    
    private func splashAnimation(){
        // Create Boat Animation
        self.boatAnimation = LOTAnimationView(name: "4681-liquid-loading.json")
        // Set view to full screen, aspectFill
        self.boatAnimation!.autoresizingMask = [.flexibleWidth]
        self.boatAnimation!.contentMode = .scaleAspectFill
        self.boatAnimation!.frame = self.lotieAnimationView.bounds
        // Add the Animation
        //self.lotieAnimationView.addSubview(self.boatAnimation!)
        self.boatAnimation?.play()
        self.boatAnimation?.loopAnimation = true
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "icon_1024")!,iconInitialSize: CGSize(width: 140, height: 140), backgroundColor: UIColor.white)
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.duration = 4.0
        
        revealingSplashView.iconColor = UIColor.red
        revealingSplashView.useCustomIconColor = false
        
        revealingSplashView.animationType = SplashAnimationType.swingAndZoomOut
        
        revealingSplashView.startAnimation(){
            self.revealingLoaded = true
            self.setNeedsStatusBarAppearanceUpdate()
            
            if self._accountKit == nil {
                self._accountKit = AKFAccountKit(responseType: .accessToken)
            }
            
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

// FaceBook Login Api Call
extension LandingVC{

    private func fbLoginCall() {
        fbLogin.onClickAction = { (button) in
            print("FB LOGIN")
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled)!{
                        self.animationStop()
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        self.animationStart()
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbAccessToken = FBSDKAccessToken.current().tokenString
                    self.dict = result as? [String : AnyObject]
                    let fbID = self.dict["id"] as! String
                    print(fbID)
                    self.loginFbUser(fbID: fbID, fbToken: fbAccessToken!)
                }
                else{
                    
                    self.animationStop()

                }
            })
        }
    }
    private func loginFbUser(fbID:String,fbToken:String){
        
        let parameters: [String : Any]? = [
            "facebook_user_id":fbID,
            "facebook_access_token":fbToken,
            
            ]
        
        Alamofire.request(RestURL.sharedInstance.PostFacebookAPI, method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{
                                    let id = data["id"] as! Int
                                    UserDefaults.standard.set(id, forKey: "ID")
                                    UserDefaults.standard.set("C", forKey: "ID2")

                                    print(UserDefaults.standard.string(forKey: "ID") ?? 0)
                                    UserDefaults.standard.set("animation", forKey: "animation")
                                    self.animationStop()
                                self.navigationController?.setNavigationBarHidden(false, animated: true)
                                let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                self.show(inititalViewController, sender: nil)
                                
                            }
                            
                        }
                            
                        else{
                            self.animationStop()
                            let errorMsg = jsonRoot["error"] as! String
                            self.warningMessage(title: "Warning", subtitle: errorMsg)
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

// gmail Login Api Call
extension LandingVC:GIDSignInDelegate,GIDSignInUIDelegate{
    
    private func gmailLoginCall() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        GIDSignIn.sharedInstance().clientID = "783557886515-jatf9dva5bv250qn0ia4pt0gi9ge79lt.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self

        gmailLogin.onClickAction = { (button) in
           // print("Gmail LOGIN")
            GIDSignIn.sharedInstance().signIn()

        }

     }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            self.animationStop()
        } else {
            // Perform any operations on signed in user here.
            self.animationStart()
            let userId = 123456
            let name = user.profile.givenName
            let email = user.profile.email
            let pic = user.profile.imageURL(withDimension: 200)
            loginGmailUser(gmailID: userId, gmailUserName: name!, gmailEmail: email!, gmailPic: pic!)
            // ...
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        self.animationStop()
        // Perform any operations when the user disconnects from app here.
        // ...
    }
   
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {

    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    private func loginGmailUser(gmailID:Int,gmailUserName:String,gmailEmail:String,gmailPic:URL){

        let parameters: [String : Any]? = [
            "google_username" : gmailUserName,
            "gmail": gmailEmail,
            "google_picture_url": gmailPic ,
            "google_user_id": gmailID ,
            ]
        
        Alamofire.request(RestURL.sharedInstance.PostGmailAPI, method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            //print(jsonRoot)
                            if let data = jsonRoot["data"] as? [String:Any]{
                                //print(data)
                                let id = data["id"] as! Int
                                UserDefaults.standard.set(id, forKey: "ID")
                                UserDefaults.standard.set("C", forKey: "ID2")
                                print(UserDefaults.standard.string(forKey: "ID") ?? 0)
                                UserDefaults.standard.set("animation", forKey: "animation")

                            self.animationStop()
                            GIDSignIn.sharedInstance()?.signOut()
                            let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self.show(inititalViewController, sender: nil)
                            
                        }
                        else{
                            self.animationStop()
                            let errorMsg = jsonRoot["error"] as! String
                            self.warningMessage(title: "Warning", subtitle: errorMsg)
                            GIDSignIn.sharedInstance()?.signOut()
                        }
                    }
                }
                case .failure(let error):
                    self.animationStop()
                    print(error)
                    
                }
            }
        }
    }

}


// Login With Phone Number Call

extension LandingVC:AKFViewControllerDelegate{
    
    private func loginPhonelUser(number:Int){
        self.animationStart()
        let parameters: [String : Any]? = [
            "phone":number,
            ]
        
        Alamofire.request(RestURL.sharedInstance.PostPhoneAPI, method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        if (jsonRoot["data"] as? [String:Any]) != nil{
                            
                            if let data = jsonRoot["data"] as? [String:Any]{
                                //print(data)
                                let id = data["id"] as! Int
                                UserDefaults.standard.set(id, forKey: "ID")
                                UserDefaults.standard.set("C", forKey: "ID2")
                                print(UserDefaults.standard.string(forKey: "ID") ?? 0)
                                UserDefaults.standard.set("animation", forKey: "animation")

                                
                           // print(jsonRoot)
                            
                            self.animationStop()
                            self._accountKit.logOut()
                            let inititalViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self.show(inititalViewController, sender: nil)
                            
                        }
                        else{
                            self.animationStop()
                            let errorMsg = jsonRoot["error"] as! String
                             self.warningMessage(title: "Warning", subtitle: errorMsg)
                             print(errorMsg)
                        }
                    }
                        
                }
                case .failure(let error):
                    self.animationStop()
                    print(error)
                    
                }
            }
        }
    }
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self

        //loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: UIColor.blue)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "story 2")
        let image = imageView.image
        loginViewController.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: UIColor.black, backgroundImage: image, backgroundTint: AKFBackgroundTint.white, tintIntensity: 0.5)
        loginViewController.enableGetACall = true
  
    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        //print("did complete login with access token \(accessToken.tokenString) state \(state)")
        accessTokenAccountKit = accessToken.tokenString

    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        //...
    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        self.animationStop()
    }
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        // ... handle user cancellation of the login process ...
    }
    
}
