//
//  ViewController.swift
//  RainbowTabs
//
//  Created by Антон Шалимов on 23.01.2023.
//

import UIKit

class RedViewController: UIViewController {

    override func viewDidLoad() {
        tabBarItem.badgeValue = "!"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarItem.badgeValue = nil
    }


}

