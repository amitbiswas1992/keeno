//
//  ProductTab.swift
//  BuySellApp
//
//  Created by Sanzid on 4/3/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

import Tabman
import Pageboy

class ProductTab: TabmanViewController {
    
    
    var viewControllers = [UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "PurchesedVC1") as! PurchesedVC,UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "SellingVC") as! SellingVC,UIStoryboard(name: "Nav", bundle: nil).instantiateViewController(withIdentifier: "SoldVC") as! SoldVC]
    var tabTitle = ["Purchesed","Selling","Sold"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Products"
        
        self.dataSource = self
        self.view.backgroundColor = UIColor.white
        
        // Create bar
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap // Customize
        bar.layout.contentMode = .fit
        bar.indicator.tintColor = UIColor.red
        bar.buttons.customize { (button) in
            button.selectedTintColor = UIColor.red
        }
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white

    }
}

extension ProductTab: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title = tabTitle[index]
        return TMBarItem(title: title)
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    
}
