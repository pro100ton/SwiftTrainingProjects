//
//  MenuItemCell.swift
//  OrderApp
//
//  Created by Антон Шалимов on 26.03.2023.
//

import UIKit

/// Класс для менеджмента ячеек таблицы меню
class MenuItemCell: UITableViewCell {
    /// Для каждой проперти объявяется следующая констуркция:
    /// Опциональной проперти ставится значение `nil`
    /// При установке значения проперти вызывается наблюдатель `didSet`, который сравнивает - изменилось ли
    /// значение этой проперти.
    /// В случае если изменилось - вызывается метод `setNeedsUpdateConfiguration()`, который помечает ячейку
    /// как необходимую для реконфигурации
    var itemName: String? = nil {
        didSet {
            if oldValue != itemName {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var price: Double? = nil {
        didSet {
            if oldValue != price {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            if oldValue != image {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    /// Перегрузка метода `updateConfiguration(using:)`, который вызывается в случае, если был вызван метод
    /// `setNeedsUpdateConfiguration()`
    /// - Parameter state: state object of the cell
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)
        content.text = itemName
        content.secondaryText = price?.formatted(.currency(code: "usd"))
        content.prefersSideBySideTextAndSecondaryText = true
        content.imageProperties.maximumSize = CGSize(width: 60, height: 40)
        
        if let image = image {
            content.image = image
        } else {
            content.image = UIImage(systemName: "photo.on.rectangle")
        }
        self.contentConfiguration = content
    }
}
