//
//  ToDo.swift
//  ToDoList
//
//  Created by Антон Шалимов on 19.02.2023.
//

import Foundation

struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    /// Статическая константа структуры для хранения входной точки в попку документов приложения
    static let documentsDirectory = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask).first!
    
    /// Путь до файла, в котором будут храниться данные ToDo list'a
    static let archiveURL = documentsDirectory.appending(path: "toDos.plist")
    
    /// Задаем инициализатор для того, чтобы избавиться от ошибки протокола `Codable` с предустановленным значением
    /// `let id = UUID()` -> `let id: UUID` и присваиваем `id` в самом инициализаторе
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    
    
    /// Редекларация метода протокола `==` для того, чтобы обозначить что тудушки равны
    /// в случае если их `id` совпадают
    /// - Parameters:
    ///   - lhs: Первый экземпляр для сравнения
    ///   - rhs: Второй экземпляр для сравнения
    /// - Returns: `True` если `id` совпадают
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// Статический метод для загрузки тудушек
    /// - Returns: пока ничего, позже добавлю имплементацию
    static func loadToDos() -> [ToDo]? {
        // Пробуем достать данные из файла, в которых хранятся ToDo'шки
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        // Объявляем класс декодер того, что лежит внутри распакованного документа, если он
        // присутствует
        let propertyListEncoder = PropertyListDecoder()
        // Попытка декодировать информацию из файла
        return try? propertyListEncoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    /// Статический метод для записи тудушек в файл
    /// - Parameter toDos: список тудушек для записи
    static func saveToDos(_ toDos: [ToDo]) {
        // Объявляем экземпляр класса encoder'a
        let propertyListEncoder = PropertyListEncoder()
        // Пытаемся закодирвать наш список
        let codedToDos = try? propertyListEncoder.encode(toDos)
        // Попытка записать наш закодированный список в файл
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    /// Static method for generation dummy data with list of ToDo's as started point of an app
    /// - Returns: [List] of 3 ToDo's items
    static func loadSampleToDos() -> [ToDo] {
        return [
            ToDo(title: "Wash dishes",
                 isComplete: false,
                 dueDate: Date(),
                 notes: "Need to do it ASAP"),
            ToDo(title: "Do homework",
                 isComplete: false,
                 dueDate: Date(),
                 notes: "Maybe after two games of APEX :)"),
            ToDo(title: "Visit dentist",
                 isComplete: false,
                 dueDate: Date(),
                 notes: "Better be sooner that later")
        ]
    }
}
