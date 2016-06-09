//
//  ChildViewController.swift
//  Paged Tabs Example
//
//  Created by Merrick Sapsford on 04/05/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

import UIKit
import MSSTabbedPageViewController

class ChildViewController: UIViewController {
    
    // MARK: Vars
    
    @IBOutlet weak var titleLabel: UILabel?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel?.text = String(format: "Page %d", self.pageIndex + 1)
    }
}
