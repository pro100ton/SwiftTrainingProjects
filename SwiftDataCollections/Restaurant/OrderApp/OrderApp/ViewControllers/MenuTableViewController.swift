//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    // MARK: Properties
    let category: String
    let menuController = MenuController()
    var menuItems: [MenuItem] =  [MenuItem]()
    
    // MARK: Initializers
    /// Объявляем failable инициализатор для того, чтобы задать проперти category при создании экземпляра класса
    init?(coder:NSCoder, category: String){
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.category = ""
        super.init(coder: coder)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.capitalized
        
        Task {
            do {
                print(self.category)
                let menuItems = try await menuController.fetchMenuItems(forCategory: category)
                updateUI(with: menuItems)
            } catch {
                dispayError(error, title: "Failed to fetch Menu Items for \(self.category)")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
        
        let menuItem = menuItems[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = menuItem.name
        content.secondaryText = "$\(menuItem.price)"
        cell.contentConfiguration = content
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
    /// Метод для обновления данных таблицы объектов меню
    /// - Parameter menuItems: Массив объектов `MenuItem`, которыми нужно заполнить таблицу
    func updateUI(with menuItems: [MenuItem]) {
        self.menuItems = menuItems
        self.tableView.reloadData()
    }
    
    /// Метод для отображения ошибок, если таковые появляются при работе VC
    /// - Parameters:
    ///   - error: Ошибка, которую требуется отобразить
    ///   - title: Текст, который требуется отразить в ошибке
    /// Подробное описание подобной функции можно посмотреть в `CategoryTableViewController.swift`
    func dispayError(_ error: Error, title: String) {
        guard let _ = viewIfLoaded?.window else { return }
        let alert = UIAlertController(title: title,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
