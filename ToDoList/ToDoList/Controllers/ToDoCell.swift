//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Антон Шалимов on 27.02.2023.
//

import UIKit

/// Протокол с методом для передачи клетки делегату
protocol ToDoCellDelegate: AnyObject {
    func checkMarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    // MARK: Properties
    
    /// Объявление проперти делегата для того, чтобы клетка имела что-то для информирования (в ншем случае - VC
    /// главной таблицы)
    weak var delegate: ToDoCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Outlets
    
    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: Actions
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        /// Внутри экшона по нажатию кнопки информируем делегата о том, что кнопка была нажата (вызываем метод
        /// протокола)
        delegate?.checkMarkTapped(sender: self)
    }
}
