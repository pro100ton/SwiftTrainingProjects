
import UIKit


@MainActor
class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    
    /// Массив хранения найденных по поиску элементов
    var items = [StoreItem]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    /// Инстанс контроллера получаемых результатов. Используется в дальнейшем для получения информации из инета
    let storeItemController = StoreItemController()
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// Функция для сброса `self.items` и перезагрузки table view для очистки старых записей.
    /// После этого функция "захватывает" текст из строки поиска и берет тип медиа из сегментированного контроллера
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            
            // set up query dictionary
            let queryDictianory = [
                "term": searchTerm,
                "media": mediaType,
                "limit": "10"
            ]
            
            Task {
                do {
                    let searchData = try await storeItemController.fetchItems(
                        matching: queryDictianory)
                    self.items = searchData
                    self.tableView.reloadData()
                } catch {
                    print("Something went wrong")
                }
            }
        }
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        /// Настраиваем имя клетки именем полученного экземпляра
        cell.name = item.name
        
        /// Настраиваем исполнителя клетки исполнителем полученного экземпляра
        cell.artist = item.artist
       
        /// Ничего не присваиваем картинке клекти
        imageLoadTasks[indexPath] = Task {
            do {
                let imageData = try await storeItemController.setCellImage(with: item.artworkURL)
                cell.artworkImage = imageData
            } catch {
                print("Something went wrong during image loading process")
            }
            imageLoadTasks[indexPath] = nil
        }
        cell.artworkImage = nil
        
        // initialize a network task to fetch the item's artwork keeping track of the task
        // in imageLoadTasks so they can be cancelled if the cell will not be shown after
        // the task completes.
        //
        // if successful, set the cell.artworkImage using the returned image
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cancel the image fetching task if we no longer need it
        imageLoadTasks[indexPath]?.cancel()
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}

