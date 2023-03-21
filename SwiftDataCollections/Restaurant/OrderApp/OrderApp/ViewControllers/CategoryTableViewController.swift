//
//  CategoryTableViewController.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    // MARK: Properties
    
    /*
     /// Создаем инстанс класса `MenuController` для работы с веб запросами
     let menuController = MenuController()
     */
    
    /// Проперти для хранения списка категорий меню ресторана
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                let categories = try await MenuController.shared.fetchCategories()
                updateUI(with: categories)
            } catch {
                dispayError(error, title: "Failed to fetch categories")
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        /// Настраиваем количество секций в таблице категорий.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Настраиваем количество строк в таблице. Ставим значение равное количеству категорий
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Выбираем идентификатор reusable cell, производим ее dequeue и проводим ее найтройку
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        
        /// Вызов helper функции по настройке клетки
        configureCell(cell, forCategoryAt: indexPath)
        
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
    
    /// Метод для обновления данных таблицы с использованием полученного списка категорий
    /// На входе берет список категорий, обновляет property `self.categories` в соответствии с переданными
    /// значениями и обновляет данные таблицы
    /// - Parameter categories: список категорий
    func updateUI(with categories: [String]) {
        self.categories = categories
        self.tableView.reloadData()
    }
    
    /// Функция dispayError используется для отображения сообщений об ошибках в виде UIAlertController на экране
    /// в iOS-приложении.
    /// - Parameters:
    ///   - error: Параметр error передает ошибку, которую необходиЖжмо отобразить на экране
    ///   - title: Параметр title представляет заголовок UIAlertController.
    func dispayError(_ error: Error, title: String) {
        
        /// Используется  для проверки наличия окна на экране (viewIfLoaded), прежде чем отображать
        /// сообщение об ошибке. Если окна нет, функция просто выходит, не отображая UIAlertController добавляя warning
        /// в выводе в консоль.
        guard let _ = viewIfLoaded?.window else { return }
        
        /// Cоздаем объект `UIAlertController` с заданным заголовком `title` и сообщением, извлеченным
        /// из переданного параметра ошибки `error.localizedDescription`. Затем добавляется действие "Dismiss"
        /// в UIAlertController, которое закрывает `UIAlertController`, когда пользователь нажимает на кнопку "Dismiss".
        let alert = UIAlertController(title: title,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        /// Используя `present(_:animated:completion:)`, функция отображает `UIAlertController` на экране
        /// с анимацией.
        /// Если animated равно `true`, то `UIAlertController` отобразится с анимацией, в противном случае
        /// он появится мгновенно.
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Helper функция настройки конкретных cell's таблицы категорий
    /// - Parameters:
    ///   - cell: Клетка, которую требуется настроить под категорию
    ///   - indexPath: indexPath объект, для которого будет проводится настройка
    func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
        /// Получаем категорию, для которой необходимо настроить ряд в таблице
        /// `indexPath.row`:  индекс, в котором будет находится информация о категории, с такимже индексом в массиве
        let category = categories[indexPath.row]
        
        /// Настройка конфигурации клетки
        var content = cell.defaultContentConfiguration()
        content.text = category.capitalized
        cell.contentConfiguration = content
    }
    
    // MARK: Segues actions
    
    
    /// Segue action для передачи информации о выбранной категории в `MenuTableViewController`
    @IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
        /// Сначала проверяется является ли отправителем клетка таблицы и какой у нажатой клетки `indexPath`
        /// Если условия выше не выполнены, то функция не возвращает ничего
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
        else { return nil }
        
        /// Получаем нажатую пользователем категорию путем навигации в массиве через его `indexPath`
        let category = categories[indexPath.row]
        
        /// Возвращаем экземпляр VC `MenuTableViewController` с предустановленной категорией, чтобы он
        /// мог загрузить данные в соответствии с этой категорией
        return MenuTableViewController(coder: coder, category: category)
    }
}
