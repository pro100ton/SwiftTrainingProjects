//
//  ViewController.swift
//  Two buttons
//
//  Created by Антон Шалимов on 24.12.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var labelText: UILabel!
    @IBOutlet var enteredText: UITextField!
   
    
    @IBAction func setTextButtonTapped(_ sender: UIButton) {
        // Get entered text from user
        var enteredText = enteredText.text
        // Set label text to user text
        labelText.text = enteredText
    }
    
    @IBAction func clearTextButtonTapped(_ sender: UIButton) {
        return labelText.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

