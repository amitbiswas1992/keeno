//
//  ProductDetailsVC.swift
//  BuySellApp
//
//  Created by Sanzid on 2/27/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import AccountKit
import SquareFlowLayout
import Alamofire
import ObjectMapper
import Gallery
import Lottie
import CoreLocation
import AlamofireImage
import DZNEmptyDataSet
import SDWebImage
import ImageSlideshow

class ProductDetailsVC: BaseViewController{
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private var collectionView2: UICollectionView!
    var imageArray : Array<CategeoryMapper> = []
    var resultProduct : Array<ProductMapper> = []
    var detailProduct : Array<ProductInfo> = []
    var resultProductImage : Array<ProductMapper> = []
    var pageNumber = 1
    var totalItems = 10000
    var lat = ""
    var long = ""
    let manager = CLLocationManager()
    var imageDummy  = ["001-car","002-shop","003-mobile-phone","004-chair","005-scooter","006-dress","007-baby"]
    private var boatAnimation: LOTAnimationView?
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var searchBar: UISearchBar!
    enum CellType {
        case normal
        case expanded
    }
    private var photos: [Int : UIImage] = [:]
    private let layoutValues: [CellType] = [
        .normal, .normal, .normal,
        .expanded, .normal, .normal,
        .normal, .normal, .normal,
        .normal, .expanded, .normal,
        .expanded, .normal, .normal,
        .normal, .expanded, .normal,
        .normal, .normal, .normal,
        .normal, .normal, .expanded,
        .normal, .normal, .normal,
        .normal, .expanded, .normal,
        .normal, .normal, .normal,
        .expanded, .normal, .normal,
        .normal, .normal, .normal,
        .normal, .expanded, .normal,
        .normal, .normal, .normal,
        .normal, .normal, .normal,
        .expanded, .normal, .normal,
        .normal, .normal, .normal,
        .normal, .normal, .expanded,
        .normal, .expanded, .normal,
        .normal, .normal, .normal,
        .normal, .normal, .normal,
        .expanded, .normal, .normal,
        .normal, .expanded, .normal,
        .normal, .normal, .normal,
        .normal, .normal, .expanded,
        .expanded, .normal, .normal
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView2.emptyDataSetSource = self
        collectionView2.emptyDataSetDelegate = self
        setUpUIComponent()
        addSlideMenuButton()
        getCategeory()
        //getProduct(cate: nil, priceLow: nil, priceHigh: nil, sortBy: "", from: "feed")
    }
   
    
    override func viewWillAppear(_ animated: Bool) {
            collectionDelegateSetUp()
            getProduct(cate: nil, priceLow: nil, priceHigh: nil, sortBy: "", from: "feed")

        
        
    }
  
    // Action Outlets
    @IBAction func fliterAction(_ sender: Any) {
        
                let storyBoard:UIStoryboard = UIStoryboard(name: "Nav", bundle: nil)
                let vc = storyBoard.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
                vc.view.backgroundColor = UIColor.clear
                vc.delegate = self
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: true, completion: nil)

    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let flowLayout = self.collectionView.collectionViewLayout as? SquareFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}

// Search Products
extension ProductDetailsVC:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        // If the search bar contains text, filter our data with the string
        if let searchText = searchController.searchBar.text {
            print(searchText)
            searchData(searchValue: searchText)
            //collectionView2.reloadData()
        }
    }
    public func setUpUIComponent(){
        searchController.searchResultsUpdater = self
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.placeholder = "Search Product"
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.getTextField()?.font = UIFont(name: "DIN Alternate", size: 17.0)
        searchController.searchBar.getTextField()?.keyboardAppearance = .dark
        searchController.hidesNavigationBarDuringPresentation = false
        let nib = UINib(nibName: "CategoeryCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: "CategoeryCell")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    private func collectionDelegateSetUp(){
        
        let flowLayout = SquareFlowLayout()
        flowLayout.flowDelegate = self
        self.collectionView2.collectionViewLayout = flowLayout
        self.collectionView2.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
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
//ColectionView Delegate

extension ProductDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
              return imageArray.count
        }
        else{
            
            return resultProduct.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        
        if collectionView == self.collectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoeryCell", for: indexPath) as! CategoeryCell
            cell.logoImage.image = UIImage(named: imageDummy[indexPath.row])
            cell.nameTitle.text = imageArray[indexPath.row].name
            return cell
            
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            let url = NSURL(string: resultProduct[indexPath.row].url)
            
            if url != nil{
                 cell.imageView.af_setImage(withURL: url! as URL)
            }
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: 120 , height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return -40
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == self.collectionView{
            
           // print(indexPath.row)
            getProduct(cate: indexPath.row + 1, priceLow: nil, priceHigh: nil, sortBy: "", from: "cate")
            
        }
        else{
//            let storyBoard:UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            let vc = storyBoard.instantiateViewController(withIdentifier: "ProductNavigateVCViewController") as! ProductNavigateVCViewController
//             vc.imageURL = resultProduct[indexPath.row].url
//             vc.ID = resultProduct[indexPath.row].id
//             self.navigationController?.pushViewController(vc, animated: true)
        }

        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
     
    }
 
}

extension ProductDetailsVC: SquareFlowLayoutDelegate {
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        return self.layoutValues[indexPath.row] == .expanded
    }
}

// API Call Search,List,Categoery

extension ProductDetailsVC {
    
    func searchData(searchValue:String){
        self.resultProduct.removeAll()
        self.detailProduct.removeAll()
        let parameters: [String : Any]? = [
            "search_string": searchValue,
            ]
        
        Alamofire.request("http://198.199.80.106/api/v1/product/search?=\(pageNumber)", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["products"] as? [String:Any]) != nil{
                            
                            if let products = jsonRoot["products"] as? [String:Any]{
                                
                                self.totalItems = products["total"] as! Int
                                
                                if let data = products["data"] as? [[String:Any]]{
                                    for item in data{
                                        guard  let ProductDetails = Mapper<ProductInfo>().map(JSON: item) else {
                                            continue
                                        }
                                        let images = item["image"] as? [String:Any]
                                        
                                        guard  let ImagesArray = Mapper<ProductMapper>().map(JSON:images!) else {
                                            continue
                                        }
                                        self.detailProduct.append(ProductDetails)
                                        self.resultProduct.append(ImagesArray)
                                        
                                    }
                                    
                                    let flowLayout = SquareFlowLayout()
                                    flowLayout.flowDelegate = self
                                    self.collectionView2.collectionViewLayout = flowLayout
                                    self.collectionView2.reloadData()
                                    print(self.resultProduct.count)
                                    self.animationStop()
                                    
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

    func getCategeory(){
        
            let parameters: [String : Any]? = [
                "id": UserDefaults.standard.string(forKey: "ID") ?? 0,
                ]
            Alamofire.request("http://198.199.80.106/api/v1/product/categories", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
                
                if response.result.value != nil {
                    switch response.result {
                        
                    case .success:
                        
                        let data = response.result.value! as? [[String: Any]]
                        
                        
                        for value in data! {
                            
                            guard  let CompititionImage = Mapper<CategeoryMapper>().map(JSON: value) else {
                                continue
                                
                            }
                            
                            self.imageArray.append(CompititionImage)
                        }
                        print(self.imageArray.count)
                        self.collectionView.reloadData()
                    
                    case .failure(let error):
                        print(error)
                        
                    }
                }
                else{
                    

                }
            }
        }
    func getProduct(cate:Int?,priceLow:Int?,priceHigh:Int?,sortBy:String?,from:String){
        
       // self.animationStart()
        self.resultProduct.removeAll()
        self.detailProduct.removeAll()
        
        var parameters: [String : Any]?
        if from == "feed"{
            parameters = [
            "latitude": "88",
            "longitude": "88",
            ]
        }
        else if  from == "cate"{
            parameters = [
                "latitude": "88",
                "longitude": "88",
                "category_id" : cate!,
            ]
        }
        else{
            
            parameters = [
                "latitude": "88",
                "longitude": "88",
                "category_id" : cate!,
                 "lower_price_limit":priceLow!,
                 "upper_price_limit":priceHigh!,
            ]
            
        }
        
        Alamofire.request("http://198.199.80.106/api/v1/product/get?page=\(pageNumber)", method:.post, parameters:parameters,encoding: URLEncoding.httpBody, headers:nil).responseJSON { response in
            
            if response.result.value != nil {
                switch response.result {
                    
                case .success:
                    if let jsonRoot = response.result.value as? [String:Any]{
                        
                        if (jsonRoot["products"] as? [String:Any]) != nil{
                            
                            
                            if let products = jsonRoot["products"] as? [String:Any]{
                                
                                self.totalItems = products["total"] as! Int
                                
                                if let data = products["data"] as? [[String:Any]]{
                                    for item in data{
                                        guard  let ProductDetails = Mapper<ProductInfo>().map(JSON: item) else {
                                            continue
                                        }
                                        let images = item["image"] as? [String:Any]
                                        
                                        guard  let ImagesArray = Mapper<ProductMapper>().map(JSON:images!) else {
                                            continue
                                        }
                                        self.detailProduct.append(ProductDetails)
                                        self.resultProduct.append(ImagesArray)

                                    }
                                    let flowLayout = SquareFlowLayout()
                                    flowLayout.flowDelegate = self
                                    self.collectionView2.collectionViewLayout = flowLayout
                                    self.collectionView2.reloadData()
                                    print(self.resultProduct.count)
                                    self.animationStop()
                                    
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

extension ProductDetailsVC :DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Empty Product List"
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

// Delegate functions
extension ProductDetailsVC:FilterHandlerDelegate{
    
    func launchObjectSuccess(cate: Int, priceLow: Int, priceHigh: Int, sortBy: String, from: String) {
        
        getProduct(cate: cate, priceLow: priceLow, priceHigh: priceHigh, sortBy: sortBy, from: sortBy)
        
    }
    
}

//Location Delegate
extension ProductDetailsVC:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let location = locations[0]
        manager.stopUpdatingLocation()
        lat =  location.coordinate.latitude.description
        long = location.coordinate.longitude.description
        
    }
    
}

extension ProductDetailsVC:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (totalItems > resultProduct.count) {
            
            pageNumber = pageNumber + 1
            //getProduct(cate: nil, priceLow: nil, priceHigh: nil, sortBy: "", from: "feed")

        }
        else {
            
        }
        
    }
    
    
}
