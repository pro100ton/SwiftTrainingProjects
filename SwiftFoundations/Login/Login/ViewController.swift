//
//  ViewController.swift
//  Login
//
//  Created by Антон Шалимов on 10.01.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var forgotPasswordOutlet: UIButton!
    @IBOutlet var forgotUsernameOutlet: UIButton!
    @IBOutlet var enteredUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func forgotUsernameTap(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginProgrammSegue", sender: sender)
    }
    
    
    @IBAction func forgotPasswordTap(_ sender: UIButton) {
        performSegue(withIdentifier: "LoginProgrammSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else {return}
        if sender == forgotPasswordOutlet {
            segue.destination.title = "Forgot password"
        } else if sender == forgotUsernameOutlet {
            segue.destination.title = "Forgot username"
        } else {
            segue.destination.title = enteredUsername.text
        }
    }
    

}

