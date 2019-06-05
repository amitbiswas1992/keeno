//
//  PaymentMethodVC.swift
//  BuySellApp
//
//  Created by Sanzid on 4/5/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class PaymentMethodVC: UIViewController {

    
    @IBOutlet weak var addPersonalTextField: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment Method"
        self.navigationItem.backBarButtonItem?.title = ""
        

        
        addPersonalTextField.addTapGestureRecognizer {
            
            let inititalViewController = UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.show(inititalViewController, sender: nil)
            
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
