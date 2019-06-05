//
//  CategeortVC.swift
//  BuySellApp
//
//  Created by Sanzid on 3/27/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Gallery

protocol CastHandlerDelegate: class {
    
    /// Media Launched successfully on the cast device
    func launchObjectSuccess()
    
}
var categeortType = 0
class CategeortVC: UIViewController {
    // Outlets
    @IBOutlet weak var topViewFilter: UIView!
    @IBOutlet weak var categeoryCollection: UICollectionView!
    @IBOutlet weak var categeoryView: UIView!
    var imageArray : Array<CategeoryMapper> = []
    weak var delegate: CastHandlerDelegate?
    var imageDummy  = ["001-car","002-shop","003-mobile-phone","004-chair","005-scooter","006-dress","007-baby"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUIComponent()
        getCategeory()

    }

}


extension CategeortVC{
    
    
    func setUpUIComponent(){
        topViewFilter.addTapGestureRecognizer {
            self.dismiss(animated: true, completion: nil)
        }
        let nib = UINib(nibName: "CategoeryCell", bundle: nil)
        categeoryCollection?.register(nib, forCellWithReuseIdentifier: "CategoeryCell")
        Gallery.Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.recordLocation = true
        
    }
}


// Collection View Delegate

extension CategeortVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
                    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoeryCell", for: indexPath) as! CategoeryCell
            
            // print(imageArray[indexPath.row].icon_url)
            
             cell.logoImage.image = UIImage(named: imageDummy[indexPath.row])
        //sd_setImage(with: URL(string: imageArray[indexPath.row].icon_url), completed: nil)
            cell.nameTitle.text = imageArray[indexPath.row].name
            //cell.logoImage.image = UIImage(named: imageDummy[indexPath.row])
            
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
                categeortType = indexPath.row + 1
                let gallery = GalleryController()
                gallery.delegate = self
                present(gallery, animated: true, completion: nil)

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.size.width/3 , height: collectionView.frame.size.width/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return -20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -40

    }
    
    
    
}

// API Calling

extension CategeortVC {
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
                    self.categeoryCollection.reloadData()
                    
                case .failure(let error):
                    print(error)
                    
                }
            }
        }
    }
}


// Image Picker Delegate
extension CategeortVC: GalleryControllerDelegate{

    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        // uploadImages = images
        categeoryView.isHidden = true
        Image.resolve(images: images) { (imagesFile) in
            
            //print(uploadImages)
            uploadImages = imagesFile as? [UIImage]
            self.delegate?.launchObjectSuccess()

            
            controller.dismiss(animated: true, completion: {
                
                self.dismiss(animated: true, completion: {
                    

                })

                
            })
            
        }
        
        
        
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        categeoryView.isHidden = true
        controller.dismiss(animated: true, completion: {
            
            self.dismiss(animated: true, completion: {
                
                self.tabBarController?.selectedIndex = 2
            })

        })
        
    }
}
