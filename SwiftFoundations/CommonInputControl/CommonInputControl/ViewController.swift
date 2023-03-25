//
//  ViewController.swift
//  CommonInputControl
//
//  Created by Антон Шалимов on 23.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttonRef: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonRef.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    
    @IBAction func respondToTapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        print(location)
    }
    
    @IBOutlet var switchState: UISwitch!
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            print("Switch is on")
        } else {
            print("Switch is off")
        }
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        print(sender.value)
    }
    
    @IBAction func keyboardReturnKeyPressed(_ sender: UITextField) {
        if let text = sender.text {
            print("User entered: \(text)")
        }
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        //        if let text = sender.text {
        //            print("User changed text to: \(text)")
        //        }
        //        if sender.text == "OFF" {
        //            switchState.setOn(false, animated: true)
        //        }
        let text = sender.text
        switch text {
        case "OFF":
            switchState.setOn(false, animated: true)
        case "ON":
            switchState.setOn(true, animated: true)
        default:
            print(text!)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if switchState.isOn {
            print("Switch is on")
        } else {
            print("Switch is off")
        }
    }
}

