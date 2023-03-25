//
//  ViewController.swift
//  trafficSegues
//
//  Created by Антон Шалимов on 09.01.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var segueSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func greenButtonTapped(_ sender: Any) {
        print("Green button pressed")
        print(segueSwitch.isOn)
        if segueSwitch.isOn {
            performSegue(withIdentifier: "Green", sender: nil)
        }
    }
    @IBAction func yellowButtonTapped(_ sender: Any) {
        print("Yellow button pressed")
        print(segueSwitch.isOn)
        if segueSwitch.isOn {
            performSegue(withIdentifier: "Yellow", sender: nil)
        }
    }
}

