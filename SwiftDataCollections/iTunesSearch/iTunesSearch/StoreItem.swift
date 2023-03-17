//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Антон Шалимов on 16.03.2023.
//

import Foundation

// Structure for working with results ot iTunes search
struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var description: String
    var artworkURL: URL
    
    // CodingKeys enum для маппинга ключей получаемых из JSON к проперти полей
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description
        case artworkURL = "artworkUrl30"
    }
    
    /* Дополнительный enum для поля description. Нужен так как маппинг для проперти
     description может быть как из поля "longDescription" так и "description".
     Для обхода этой ситуации мы объявляем этот enum который adopt'ит CodingKey и у которого
     есть case `longDescription`
     */
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    
    /// Так как у нас кастомный маппинг для проперти `description`, то протокол `Codable` не может
    /// автоматически создать для нас метод декодирования, поэтому надо определить кастомный инициализатор
    /// в котором будет описано как надо декодировать получаемый JSON и приводить его к виду нашей структуры
    init(from decoder: Decoder) throws {
        // Создаем контейнер значений закодированный с помощью нашего enum CodingKeys
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        /* Для полей, у которых соотношение ключей 1:1 с JSON - декодируем их с помощью
         Созданного контейнера с case'ами из enum CodingKeys
         */
        self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.artist = try valueContainer.decode(String.self, forKey: CodingKeys.artist)
        self.kind = try valueContainer.decode(String.self, forKey: CodingKeys.kind)
        self.artworkURL = try valueContainer.decode(URL.self, forKey: CodingKeys.artworkURL)
        /* Для проперти `description` необходимо сначала проверить есть ли в JSON поле
         `description`
         */
        if let description = try? valueContainer.decode(
            String.self,
            forKey: CodingKeys.description) {
            // Если есть - присвоить проперти `desctiption` значение поля `description` из JSON
            self.description = description
        } else {
            /* Если нет - объявить новый контейнер декодирования значений но теперь с enum'ом
             `AdditionalKeys` где есть кейс `longDescription`
             */
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            /* Проверяем есть ли с новым контейнером поле `longDescription`, если есть то
             присваиваем проперти `description` значение `longDescription`. Если нет - то
             присваиваем пустую строку
             */
            self.description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? "No description"
        }
    }
}

/// Структура для хранения результатов запроса в iTunes
struct SearchResponse: Codable {
    let results: [StoreItem]
}
