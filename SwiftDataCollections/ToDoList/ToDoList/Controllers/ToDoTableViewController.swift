//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Антон Шалимов on 19.02.2023.
//

import UIKit

/// Расщиряя класс протоколом клетки мы обозначаем, что в роли делегата клетки может выступать данный VC
class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    func checkMarkTapped(sender: ToDoCell) {
        /// Имплеменатция метода нажатия кнопки клетки. В данном случае код выполнится в момент, когда пользователь
        /// нажмет на кнопку в клетке с выбором о статусе конкретной ToDo
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // Вызываем метод записи в файл списка тудушек
            ToDo.saveToDos(toDos)
        }
    }
    
    
    // MARK: Properties
    /// Объявляем переменную, которая будет менеджить список тудушек
    var toDos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Следующий код проверяет есть ли тудушки в базе
        /// Если есть то он их загружает, если нет - генерирует dummy данные
        if let savedToDos = ToDo.loadToDos() {
            self.toDos = savedToDos
        } else {
            self.toDos = ToDo.loadSampleToDos()
        }
        
        /// Включение "Умного" режима редактирования для таблицы. При его нажатии появляется интерфейс удаленияn
        /// элементов таблицы
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDos.count
    }
    
    override func tableView(
        _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Объявляем объект типа "клетка" для каждой клетки в таблице
            // Также downcast'им эту клетку до нашего кастомного класса, отвечающего за поведение
            // клетки
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "ToDoCellIdentifier",
                for: indexPath) as! ToDoCell
            
            // Устанавливаем делегатом клетки данный VC
            cell.delegate = self
            
            // Достаем текущее значение тудушки в соответствии с номером
            let currentToDo = toDos[indexPath.row]
            
            // Настраиваем клетку согласно нашему кастомному классу для нее
            cell.titleLabel?.text = currentToDo.title
            cell.isCompleteButton.isSelected = currentToDo.isComplete
                       
            // Возвращаем клетку
            return cell
        }
    
    // Override to support conditional editing of the table view.
    override func tableView( _ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Так как все клетки должны иметь возможность редактирования, то просто возвращаем `true`
        return true
    }
    
    /// Перегружаем метод `commit:forRowAt` чтобы можно было свайпом удалять объекты таблицы
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                toDos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                // Вызываем метод записи в файл списка тудушек
                ToDo.saveToDos(toDos)
            }
        }
    
    // MARK: Segues
    /// Unwind method to allow different scenes to navigate back to ToDo list table
    /// - Parameter segue: Any segue can trigger that action
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        // Guarding identifier of save button unwind segue from new to do VC
        guard segue.identifier == "saveUnwind" else { return }
        // Force unpacking segue source as to do detail VC
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        // If source VC has toDo property initilized
        if let toDo = sourceViewController.toDo {
            /// If editing action is performed (toDo item UUID was initialized with VC) - find the existing toDo item in array
            /// `firstIndex` returns the occurance of item in array
            if let indexOfExistingToDo = toDos.firstIndex(of: toDo){
                // Replace object in current array and replace with edited one
                toDos[indexOfExistingToDo] = toDo
                // Reload row at indexPath of edited object
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)],
                                     with: .automatic)
            } else {
                // Calculate new index path for new row in table
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                // Append new object to list of ToDo's
                toDos.append(toDo)
                // Insert new row with new object
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        // Вызываем метод записи в файл списка тудушек
        ToDo.saveToDos(toDos)
    }
    
    
    /// Segue action to perform edit and add new todo item management
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        // First setting up VC which we will configure
        let detailController = ToDoDetailTableViewController(coder: coder)
        
        // Next we guard sender and checking if user taps a cell and if it is, grabbing index path
        // of that cell
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            // Otherwise if user taps not on a cell - initialize exmpty detail todo VC
            return detailController
        }
        
        // Deselecting row that user taps
        tableView.deselectRow(at: indexPath, animated: true)
        // Initializing optional todo in details VC, that stores current ToDo item
        detailController?.toDo = toDos[indexPath.row]
        
        return detailController
    }
    
    
}
