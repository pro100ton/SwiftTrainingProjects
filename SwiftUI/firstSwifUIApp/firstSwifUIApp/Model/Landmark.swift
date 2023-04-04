//
//  Landmark.swift
//  firstSwifUIApp
//
//  Created by Антон Шалимов on 01.04.2023.
//

import Foundation
import CoreLocation
import SwiftUI

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool
    
    /// Приватная проперти для чтения именя изображения.
    /// Приватная потому-что пользователям не нужно название картинки. Их интересует только сама картинка
    private var imageName: String
    /// Computed property для загрузки изображения из Assets
    var image: Image {
        Image(imageName)
    }
    
    /// Настраиваем координаты места, где находится искомый маркер
    /// Создаем приватную проперти (приватную, тк она не нужна пользователям. Им нужна `locationCoordinates`
    /// В качестве типа указываем кастомную структуру, объявленную ниже, которая состоит из двух проперти, нужных
    /// для `locationCoordinates`
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
    
}
