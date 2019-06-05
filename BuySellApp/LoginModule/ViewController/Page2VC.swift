//
//  Page2VC.swift
//  BuySellApp
//
//  Created by Sanzid on 3/31/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

class Page2VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipAction(_ sender: Any) {
        
        let inititalViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "page4") as! TabBarVC
        self.show(inititalViewController, sender: true)
    }
    
}
