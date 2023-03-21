//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    // MARK: Properties
    
    let menuItem: MenuItem
    
    // MARK: Outlets
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!
    @IBOutlet var detailTextLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Initializers
    
    init?(coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.menuItem = MenuItem.createFailedInstance()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Helper methods
    func updateUI() {
        self.nameLabel.text = menuItem.name
        self.priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
        self.detailTextLabel.text = menuItem.detailText
    }
}
