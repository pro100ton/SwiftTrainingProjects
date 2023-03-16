//
//  ViewController.swift
//  Contest
//
//  Created by Антон Шалимов on 09.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Ok
    }
    
    // MARK: Actions
    
    @IBAction func contestSubmitButton(_ sender: UIButton) {
        let emailEntered = emailField.text ?? ""
        if emailEntered.contains("@"){
            print("Email in")
            performSegue(withIdentifier: "contestInitSegue", sender: nil)
        } else {
            UIView.animate(withDuration: 0.15, animations: {
                let scaleUpTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                let scaleDownTransform = CGAffineTransform.identity
                let comboTransform = scaleUpTransform.concatenating(scaleDownTransform)
                self.emailField.transform = scaleUpTransform
            }) { (_) in
                UIView.animate(withDuration: 0.15) {
                    self.emailField.transform = CGAffineTransform.identity
                }
            }
        }
    }
    
    
}

