//
//  SellingVC.swift
//  BuySellApp
//
//  Created by Sanzid on 4/3/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class SoldVC: UIViewController {
    

    @IBOutlet weak var sellingTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        sellingTable.emptyDataSetSource = self
        sellingTable.emptyDataSetDelegate = self
        sellingTable.tableFooterView = UIView()
        sellingTable.register(UINib(nibName: "SellingCell", bundle: nil), forCellReuseIdentifier: "SellingCell")
        sellingTable.separatorColor = UIColor.clear

        // Do any additional setup after loading the view.
    }
    
}

extension SoldVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = sellingTable.dequeueReusableCell(withIdentifier: "SellingCell", for: indexPath) as! SellingCell
        cell.boostButton.addTapGestureRecognizer {
            
                    let inititalViewController = UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "BoostVC") as! BoostVC
                    self.show(inititalViewController, sender: nil)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

    }
    
    
    
    
}


extension SoldVC :DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Empty Sold List"
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
