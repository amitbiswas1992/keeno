//
//  SellingVC.swift
//  BuySellApp
//
//  Created by Sanzid on 4/3/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import Alamofire
import Lottie
import ObjectMapper
import SDWebImage
import DZNEmptyDataSet

class SellingVC: UIViewController {
    var resultProduct : Array<ProductMapper> = []
    @IBOutlet weak var sellingTable: UITableView!
    private var boatAnimation: LOTAnimationView?
    var detailProduct : Array<ProductInfo> = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        sellingTable.emptyDataSetSource = self
        sellingTable.emptyDataSetDelegate = self
        sellingTable.tableFooterView = UIView()
        
        self.view.backgroundColor = UIColor.white
        sellingTable.register(UINib(nibName: "SellingCell", bundle: nil), forCellReuseIdentifier: "SellingCell")
        sellingTable.separatorColor = UIColor.clear
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

extension SellingVC{
    
    func getProduct(){
        
        self.animationStart()
        self.resultProduct.removeAll()
        
        
        let parameters: [String : Any]? = [
            "user_id": UserDefaults.standard.string(forKey: "ID")!,
        ]
        
        Alamofire.request("http://198.199.80.106/api/v1/product/my-products", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["products"] as? [String:Any]) != nil{
                            
                            if let products = jsonRoot["products"] as? [String:Any]{
                                
                                // print(products)
                                if let data = products["data"] as? [[String:Any]]{
                                    
                                    //print(data)
                                    for item in data{
                                        
                                        guard  let ProductDetails = Mapper<ProductInfo>().map(JSON: item) else {
                                            continue
                                            
                                        }
                                        let images = item["images"] as? [[String:Any]]
                                        //print()
                                        guard  let ProductImage = Mapper<ProductMapper>().map(JSON: (images?.first!)!) else {
                                            continue
                                            
                                        }
                                        self.resultProduct.append(ProductImage)
                                        self.detailProduct.append(ProductDetails)
                                        self.sellingTable.reloadData()
                                        self.animationStop()


                                    }
                                    
//                                    for item in data{
//
//                                        let images = item["images"] as? [[String:Any]]
//                                        //print()
//                                        guard  let ProductImage = Mapper<ProductMapper>().map(JSON: (images?.first!)!) else {
//                                            continue
//
//                                        }
//                                        self.resultProduct.append(ProductImage)
//                                        self.sellingTable.reloadData()
//                                        self.animationStop()
//
//                                    }
                                    
                                }
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

extension SellingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sellingTable.dequeueReusableCell(withIdentifier: "SellingCell", for: indexPath) as! SellingCell
         cell.productImage.sd_setImage(with: URL(string: resultProduct[indexPath.row].url), completed: nil)
        cell.boostButton.addTapGestureRecognizer {
            
            let inititalViewController = UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "BoostVC") as! BoostVC
            inititalViewController.imageTop = cell.productImage.image!

            self.show(inititalViewController, sender: nil)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.height/2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let inititalViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CameraVC") as! CameraVC
//        self.show(inititalViewController, sender: nil)
    }
    
    
}

extension SellingVC :DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Empty Selling List"
        self.animationStop()
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .medium)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = ""
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "Board")
    }
    
}


