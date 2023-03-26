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
        content.image = UIImage(systemName: "photo.on.rectangle")
        cell.contentConfiguration = content
    }
    
    /// Хелпер функция для отправки request'a с заказом
    func uploadOrder() {
        /// С помощью функции `map` - перебираем массив элементов заказа и формируем новый массив, в котором
        /// будут хранится только `id` элементов заказа
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        
        Task.init {
            do {
                let minutesToPrepare = try await
                   MenuController.shared.submitOrder(forMenuIDs: menuIds)
                minutesToPrepareOrder = minutesToPrepare
                performSegue(withIdentifier: "confirmOrder", sender: nil)
            } catch {
                displayError(error, title: "Order Submission Failed")
            }
        }
    }
    
    
    func displayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title, message:
           error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default,
           handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        /// Проверить используем ли мы exit segues из модального информативно окна с временем приготовления заказа
        /// Если это она - то удаляем все объекты из заказа
        if segue.identifier == "dismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    // MARK: Actions
    
    /// Экшон таб бар кнопки submit
    /// - Parameter sender: отпраиветелм должна быть `UIBarButtonItem`
    @IBAction func submitOrder(_ sender: UIBarButtonItem) {
        /// В первую очередь мы должны посчитать сумму заказа пользователя
        /// Для этого воспользуемся методом `reduce`, в котором ставится изначальное значение = 0.0
        /// Затем перебирая массив элементов заказов (`menuItem`) добавляем к 0.0 (`result`) стоимость элемента
        let orederTotal = MenuController.shared.order.menuItems.reduce(0.0){
            (result, menuItem) -> Double in return result + menuItem.price
        }
        
        /// Форматируем для долларов сумму
        let formattedTotal = orederTotal.formatted(.currency(code: "usd"))
        
        /// Создаем алерт с подтверждением того, что пользователь хочет совершить заказ
        let alertController = UIAlertController(
            title: "Confirm order",
            message: "You are about to submit your order with a total of \(formattedTotal)",
            preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Submit",
                                                style: .default,
                                                handler: {_ in self.uploadOrder()}
                                               ))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
}
