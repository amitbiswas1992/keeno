//
//  ViewController.swift
//  elasticOnboard
//
//  Created by Anton Skopin on 28/12/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit
import liquid_swipe

class ColoredController: UIViewController {
    var viewColor: UIColor = .white {
        didSet {
            viewIfLoaded?.backgroundColor = viewColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewColor
    }
}

class ViewController: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    
    var viewControllers: [UIViewController] = {
        let firstPageVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "page1")
        let secondPageVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "page2")
        let thirdPageVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "page3")
        let forthPageVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "page4")


        var controllers: [UIViewController] = [firstPageVC, secondPageVC,thirdPageVC]
        let vcColors: [UIColor] = [#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 1, green: 0.3529352546, blue: 0.2339158952, alpha: 1),#colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
//        controllers.append(contentsOf: vcColors.map {
//            let vc = ColoredController()
//            vc.viewColor = $0
//            return vc
//        })
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        datasource = self
    }
    
    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return viewControllers.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
}

