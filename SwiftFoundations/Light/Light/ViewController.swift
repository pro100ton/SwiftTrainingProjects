//
//  ViewController.swift
//  Light
//
//  Created by Антон Шалимов on 13.12.2022.
//

import UIKit

class ViewController: UIViewController {
    var lightOn = true
    
    fileprivate func toggleLights() {
        view.backgroundColor = lightOn ? .white : .black
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        lightOn.toggle()
        toggleLights()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleLights()
        // Do any additional setup after loading the view.
    }
}
