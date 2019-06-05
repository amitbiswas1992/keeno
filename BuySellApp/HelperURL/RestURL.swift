//
//  RestUrl.swift
//  BuySellApp
//
//  Created by Sanzid on 3/30/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//


import Foundation

public class RestURL : NSObject{
    
    static let sharedInstance = RestURL()
    // Mark : BaseUrl
    private var baseURL = "http://198.199.80.106/api/v1/"
    
    // Mark : UrlBody
    public var PostLoginAPI = "login/email"
    public var PostRegisterAPI = "register/email"
    public var PostGmailAPI = "login/google/manual"
    public var PostFacebookAPI = "login/facebook"
    public var PostPhoneAPI = "login/phone"

    override init(){
        
        PostLoginAPI = baseURL+PostLoginAPI
        PostRegisterAPI = baseURL+PostRegisterAPI
        PostGmailAPI = baseURL+PostGmailAPI
        PostFacebookAPI = baseURL+PostFacebookAPI
        PostPhoneAPI = baseURL+PostPhoneAPI

    }
}
