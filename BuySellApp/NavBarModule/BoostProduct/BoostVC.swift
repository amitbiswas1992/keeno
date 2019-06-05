//
//  BoostVC.swift
//  BuySellApp
//
//  Created by Sanzid on 4/5/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import ObjectMapper


class BoostVC: UIViewController {

    @IBOutlet weak var sellingTable: UITableView!
    @IBOutlet weak var boostImageTop: UIImageView!
    @IBOutlet weak var priceButton: UIButton!
    private var boatAnimation: LOTAnimationView?
    @IBOutlet weak var productTitle: UILabel!
    var detailOffer : Array<Offer> = []

    
    var imageTop = UIImage()
    var detailsTitle = ""
    var price = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        boostImageTop.image = imageTop
        productTitle.text = detailsTitle
        print(price)
        self.priceButton.setTitle("TK " + price, for: .normal)
        
        self.title = "Boost Product"
        
        sellingTable.register(UINib(nibName: "BoostCell", bundle: nil), forCellReuseIdentifier: "BoostCell")
        sellingTable.separatorColor = UIColor.clear

        boostImageTop.clipsToBounds = true
        boostImageTop.layer.cornerRadius = 8.0
        
        
        priceButton.clipsToBounds = true
        priceButton.layer.cornerRadius = 8.0
        self.navigationItem.backBarButtonItem?.title = ""
        getProduct()
        

        
        // Do any additional setup after loading the view.
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


}
extension BoostVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailOffer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sellingTable.dequeueReusableCell(withIdentifier: "BoostCell", for: indexPath) as! BoostCell
        
        cell.label1.text = detailOffer[indexPath.row].name
        cell.label2.text = "TK " + detailOffer[indexPath.row].price.description
        cell.label3.text = detailOffer[indexPath.row].duration.description + " days"

        

        cell.boostButton.addTapGestureRecognizer {
            
            let inititalViewController = UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
            self.show(inititalViewController, sender: nil)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
    
    
}


extension BoostVC{
    
    
    func getProduct(){
        
        self.animationStart()
        self.detailOffer.removeAll()
    
        
        Alamofire.request("http://198.199.80.106/api/v1/offer/get", method:.post, parameters:nil,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        
                            if let products = jsonRoot["data"] as? [[String:Any]]{
                                
                                 print(products)
                                for item in products{
                                    
                                    guard  let ProductDetails = Mapper<Offer>().map(JSON: item) else {
                                        continue
                                        
                                    }
                                    self.detailOffer.append(ProductDetails)
                                    self.sellingTable.reloadData()
                                    self.animationStop()

                                    
                            }
                        }
                    
                    }
                    
                case .failure(let error):
                    print(error)
                    self.animationStop()
                    
                }
            }
            else{
                
                self.animationStop()
                
            }
        }
    }
    
    
    
}
