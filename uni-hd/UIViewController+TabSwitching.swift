//
//  UIViewController+TabSwitching.swift
//  uni-hd
//
//  Created by Nils Fischer on 05.01.15.
//  Copyright (c) 2015 Universität Heidelberg. All rights reserved.
//

import UIKit

// TODO: find a better way to do this, should be handled by AppDelegate

extension UIViewController {
    
    public func showLocation(location: UHDRemoteManagedLocation, animated: Bool) {
        self.showTabBarItemAtIndex(3, animated: animated) { (tabBarController, previousSelectedIndex) in
            if let mapsNavC = tabBarController.selectedViewController? as? UINavigationController {
                if let mapsVC = mapsNavC.viewControllers.first as? UHDMapsViewController {
                    mapsNavC.popToViewController(mapsVC, animated: animated&&tabBarController.selectedIndex==previousSelectedIndex)
                    mapsVC.showLocation(location, animated: animated)
                }
            }
        }
    }
    
    public func showMensaMenu(mensa: UHDMensa, animated: Bool) {
        NSUserDefaults.standardUserDefaults().setValue(NSNumber(short: mensa.remoteObjectId), forKey: "UHDUserDefaultsKeySelectedMensaId")
        self.showTabBarItemAtIndex(0, animated: true) { (tabBarController, previousSelectedIndex) in
            if let mensaNavC = tabBarController.selectedViewController as? UINavigationController {
                mensaNavC.popToRootViewControllerAnimated(animated&&tabBarController.selectedIndex==previousSelectedIndex)
            }
        }
    }
    
    public func showTabBarItemAtIndex(index: Int, animated: Bool, completion: (tabBarController: UITabBarController, previousSelectedIndex: Int) -> ()) {
        if let presentingViewController = self.presentingViewController {
            // dismiss when presented modally
            presentingViewController.dismissViewControllerAnimated(animated, completion: nil)
            presentingViewController.showTabBarItemAtIndex(index, animated: animated, completion)
        } else if let tabBarController = self.tabBarController {
            // forward to tab bar controller in hierarchy
            tabBarController.showTabBarItemAtIndex(index, animated: animated, completion)
        } else if let tabBarController = self as? UITabBarController {
            // arrived at main tab bar controller
            // switch to appropriate tab and configure
            let previousSelectedIndex = tabBarController.selectedIndex
            tabBarController.selectedIndex = index
            completion(tabBarController: tabBarController, previousSelectedIndex: previousSelectedIndex)
        }

    }
    
}
