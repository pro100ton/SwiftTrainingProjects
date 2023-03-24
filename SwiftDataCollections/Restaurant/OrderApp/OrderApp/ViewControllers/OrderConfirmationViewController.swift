//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Антон Шалимов on 23.03.2023.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    // MARK: Properties
    
    /// Property для хранения времени приготовления заказа
    let minutesToPrepare: Int
    
    // MARK: Initializers
    
    /// Инициализатор для property `minutesToPrepare`
    init?(coder:NSCoder, minutesToPrepare: Int){
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    /// В случае если инициализатор выше провалиться - необходимый инициализатор выполнится и присвоит значение
    /// времни приготовления = 0
    required init?(coder: NSCoder) {
        self.minutesToPrepare = 0
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Формируем и задаем сообщения для лейбла
        confirmationLable.text = "We started prepearing your order. It will take approximately \(minutesToPrepare) minutes"

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
    
    // MARK: Outlets
    
    @IBOutlet var confirmationLable: UILabel!
    
}
