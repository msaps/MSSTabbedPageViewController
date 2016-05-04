//
//  TabViewController.swift
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 04/05/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

import UIKit
import MSSTabbedPageViewController

class TabViewController: MSSTabbedPageViewController {
    
    // MARK: MSSPageViewControllerDataSource
    
    override func viewControllersForPageViewController(pageViewController: MSSPageViewController) -> [UIViewController]? {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let viewControllers = [storyboard.instantiateViewControllerWithIdentifier("ChildViewController"),
                               storyboard.instantiateViewControllerWithIdentifier("ChildViewController"),
                               storyboard.instantiateViewControllerWithIdentifier("ChildViewController"),
                               storyboard.instantiateViewControllerWithIdentifier("ChildViewController"),
                               storyboard.instantiateViewControllerWithIdentifier("ChildViewController")]
        return viewControllers
    }
    
    // MARK: MSSTabBarViewDataSource
    
    override func tabBarView(tabBarView: MSSTabBarView, populateTab tab: MSSTabBarCollectionViewCell, atIndex index: Int) {
        
        tab.title = String(format: "Page %d", index + 1)
    }
}
