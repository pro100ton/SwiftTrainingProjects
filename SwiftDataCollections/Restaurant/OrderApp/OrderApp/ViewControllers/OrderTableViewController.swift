//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    // MARK: Properties
    
    /// Проперти для хранения времени приготовления заказа, которое придет от сервера после получения ответа на
    /// запрос о принятии заказа
    var minutesToPrepareOrder = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Создание кнопки режима редактирования
        navigationItem.leftBarButtonItem = editButtonItem
        
        /// Создание наблюдателя за уведомлением `MenuController.orderUpdateNotification`
        NotificationCenter.default.addObserver(tableView!,
                                               selector: #selector(UITableView.reloadData),
                                               name: MenuController.orderUpdateNotification,
                                               object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuController.shared.order.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }

    /// Method for allowing user swipe-to-delete functionality
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Helper methods
    /// Метод для конфигурации клеток такблицы
    /// - Parameters:
    ///   - cell: клетка таблицы для настройки
    ///   - indexPath: `indexPath` клетки, для которой проводится настройка
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        /// Используюя переменную `order` класса `MenuController`, которую мы берем из статического экземпляра
        /// `MenuController.shared` получаем пользовательские пункты меню в заказе
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        
        /// Стандартная настройка клетки таблицы
        var content = cell.defaultContentConfiguration()
        content.text = menuItem.name
        content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        cell.contentConfiguration = content
    }
    
    // MARK: Segues
    
    /// Segue при переходе из таблицы во вью подтверждения заказа
    @IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
        /// Возвращаем экземпляр класса `OrderConfirmationViewController` с установленным временем
        /// приготовления заказа
        return OrderConfirmationViewController(coder: coder,
                                               minutesToPrepare: minutesToPrepareOrder)
    }
    
    /// Unwind segue для возврата из вью подтверждения заказа
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        
    }
    
}
