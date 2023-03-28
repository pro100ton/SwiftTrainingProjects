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
    var menuItems: [MenuItem] =  [MenuItem]()
    /// Проперти словарь для хранения тасок загрузки картинок
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    // MARK: Initializers
    /// Объявляем failable инициализатор для того, чтобы задать проперти category при создании экземпляра класса
    init?(coder:NSCoder, category: String){
        self.category = category
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        /// `category` должна быть инициализирована в каком-либо виде до вызова инициализатора суперкласса
        self.category = ""
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.capitalized
        
        Task {
            do {
                let menuItems = try await MenuController.shared.fetchMenuItems(
                    forCategory: category)
                updateUI(with: menuItems)
            } catch {
                dispayError(error, title: "Failed to fetch Menu Items for \(self.category)")
            }
        }
    }
    
    /// Перегружем метод для кастомизации того, что будет выполнено тогда, когда view будет загружен в приложении
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// Устанавливаем значение `category` enum'a `StateRestorationController`
        MenuController.shared.updateUserActivity(with: .menu(category: category))
    }
    
    /// Перегружаем метод `View` для момента, когда пользователь ушел в другой `View` и этот перестал отображаться
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /// Проходимся по всему словарю хранения тасок и отменяем все задачи по скачиванию картинок
        imageLoadTasks.forEach{
            key, value in value.cancel()
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
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    /// Перегружаем метод TVC для момента, когда ячейки перестают отображаться пользователю
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// Удалем таску загрузку картинки для ячейки, которая перестала отображаться
        imageLoadTasks[indexPath]?.cancel()
    }
    
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
    
    /// Метод для конфигурации клеток такблицы
    /// - Parameters:
    ///   - cell: клетка таблицы для настройки
    ///   - indexPath: `indexPath` клетки, для которой проводится настройка
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        /// Проверка на то, что в качестве клетки используется кастомный класс `MenuItemCell`
        guard let cell = cell as? MenuItemCell else {
            return
        }
        
        let menuItem = menuItems[indexPath.row]
        
        /// Производим базовую конфигурацию ячейки без картинки
        cell.itemName = menuItem.name
        cell.price = menuItem.price
        cell.image = nil
        
        imageLoadTasks[indexPath] = Task {
            if let image = try? await MenuController.shared.fetchImages(from: menuItem.imageURL) {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                   currentIndexPath == indexPath {
                    cell.image = image
                }
            }
            imageLoadTasks[indexPath] = nil
        }
        
        /* Old code
         
        /// Получаем `menuItem` из массива под индексом той клектки, в которую его надо вписaть
        let menuItem = menuItems[indexPath.row]
        
        /// Стандартная настройка клетки таблицы
        var content = cell.defaultContentConfiguration()
        content.text = menuItem.name
        /// Настройка дополнительного текста путем форматирования его под доллары США
        content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        /// Настраиваем placeholder картинки для элементов заказа
        content.image = UIImage(systemName: "photo.on.rectangle")
        
        /// Здесь мы не ловим никакие ошибки, так как пользователя уведмолять об ошибках загрузки картинок
        /// не совсем корректно, однако в реальном приложении по хорошему бы куда-то записывать логи ошибки.
        /// Поэтому тут мы используем опциональный `try` вместо `do/catch` чтобы в случае ошибки просто сразу
        /// выходить из таски
        /// Также мы добавляем в словарь тасок по загрузке картинок эту самую таску
        imageLoadTasks[indexPath] = Task {
            if let image = try? await MenuController.shared.fetchImages(from: menuItem.imageURL) {
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                   currentIndexPath == indexPath {
                    var content = cell.defaultContentConfiguration()
                    content.text = menuItem.name
                    content.secondaryText =
                    menuItem.price.formatted(.currency(code: "usd"))
                    content.image = image
                    cell.contentConfiguration = content
                }
            }
            /// После успешно выполненной загрзки картинки надо убрать из словаря тасок эту таску
            imageLoadTasks[indexPath] = nil
        }
        cell.contentConfiguration = content
         
        */
    }
    
    // MARK: Segues
    
    @IBSegueAction func showMenuItem(_ coder: NSCoder,
                                     sender: Any?) ->MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
        else {return nil}
        
        let menuItem = menuItems[indexPath.row]
        return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
    }
}
