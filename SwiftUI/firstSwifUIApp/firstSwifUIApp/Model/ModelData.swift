//
//  ModelData.swift
//  firstSwifUIApp
//
//  Created by Антон Шалимов on 01.04.2023.
//

import Foundation

/// Загружаем данные хранения информации о местах интереса
var landmarks: [Landmark] = load("landmarkData.json")

/// Создаем функцию, которая принимает параметры:
/// - Parameter filename: название файла и тип объектов, котоые нужно загрузить и декодировать - `T`, где `T` должен соответствовать протоколу `Decodable`
/// - Returns: Возвращаться как раз должен объект, который может быть декодирован
func load<T: Decodable>(_ filename: String) -> T {
    /// Объявляем контсанту, в которой будет храниться содержимое файла
    let data: Data
    
    /// Пытаемся получить URL файла с заданным именем из `main bundle`.
    /// Если файл не найден, выводим сообщение что не можем найти этот файл
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Could not find \(filename) in main bundle")
    }
    
    /// Пытаемся загрузить содержимое полученного файла в переменную `data`.
    /// Если возникает ошибка выводим соответствующее уведомление
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Could not load \(filename) from main bundle: \n\(error)")
    }
    
    /// Декодируем объекты типа `T` из JSON с помощью декодера.
    /// При ошибке выводим сообщение об ошибке
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Could not parse \(filename) as \(T.self):\n\(error)")
    }
}
