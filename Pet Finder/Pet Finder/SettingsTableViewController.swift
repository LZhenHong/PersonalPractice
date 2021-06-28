//
//  SettingsTableViewController.swift
//  Pet Finder
//
//  Created by Essan Parto on 5/16/15.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var themeSelector: UISegmentedControl!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissVc))
        
        themeSelector.selectedSegmentIndex = Theme.current.rawValue
    }
  
    @objc func dismissVc() {
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func applyTheme(sender: UIButton) {
        if let selectedTheme = Theme(rawValue: themeSelector.selectedSegmentIndex) {
            selectedTheme.apply()
        }
        dismissVc()
    }
}
