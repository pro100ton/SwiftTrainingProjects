//
//  ViewController.swift
//  MusicWireframe
//
//  Created by Антон Шалимов on 05.03.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    
    /// Poperty для хранения состояния воспроизведения музыки
    var isPlaying: Bool = true {
        /// В момент когда будет устаналиваться значение проперти, для аутлета кнопки паузы будет изменено
        /// состояние `selected` в установленное значение проперти
        didSet {
            pauseButton.isSelected = isPlaying
        }
    }
    
    // MARK: Outlets
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var reverseButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var reverseBackground: UIView!
    @IBOutlet var pauseBackground: UIView!
    @IBOutlet var forwardBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [reverseBackground, forwardBackground, pauseBackground].forEach { view in
            view?.layer.cornerRadius = view!.frame.height / 2
            view?.clipsToBounds = true
            view?.alpha = 0.0
        }
    }
    
    // MARK: IBActions

    /// Action для кнопки паузы, который отвечает за изменение состояния воспроизведения музыки
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        // Toggle `isPlaying` value
        isPlaying.toggle()
       
        // If music is playing
        if isPlaying {
            // Animation setting with wich album cover will restore to initial scale
            UIView.animate(withDuration: 0.8,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.1,
                           options: [],
                           animations: {
                self.albumImageView.transform = CGAffineTransform.identity
            },
                           completion: nil)
        } else {
            // Shrink album cover to 0.8 of its original size
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
        }
    }
    
    /// Отслеживание action'a нажатия кнопки пользователем
    @IBAction func touchedDown(_ sender: UIButton) {
        // Defining the UIView holder for background
        let buttonBackground: UIView
        
        // Switch sender to identify which button was pressed
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case pauseButton:
            buttonBackground = pauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        // Implementing animation for button background and scaling sender to imitate button press
        UIView.animate(withDuration: 0.25) {
            buttonBackground.alpha = 0.3
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    /// Action для отслеживания когда палец пользователя "поднимется" с кнопки
    @IBAction func touchedUpInside(_ sender: UIButton) {
        // Defining the UIView holder for background
        let buttonBackground: UIView
        
        // Switch sender to identify which button was pressed
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground
        case pauseButton:
            buttonBackground = pauseBackground
        case forwardButton:
            buttonBackground = forwardBackground
        default:
            return
        }
        
        // Задание анимации возвращения кнопки в исходное состояние
        UIView.animate(withDuration: 0.25, animations: {
            buttonBackground.alpha = 0
            buttonBackground.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            sender.transform = CGAffineTransform.identity
        }) { (_) in
            buttonBackground.transform = CGAffineTransform.identity
        }
    }
    
    
    
}

