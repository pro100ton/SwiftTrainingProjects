//
//  ViewController.swift
//  Apple pie
//
//  Created by Антон Шалимов on 25.12.2022.
//

import UIKit

class ViewController: UIViewController {
    var listOfWords = ["buccaneer", "swift", "glorious", "incandescent", "bug", "programm"]
    let incorrectMovesAllowed = 7
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLoses = 0 {
        didSet {
            newRound()
        }
    }
    
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var treeImageView: UIImageView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        // Deactivate button when player pressed it
        sender.isEnabled = false
        let letterPressed = sender.configuration!.title!
        let letter = Character(letterPressed.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newRound()
    }
    
    var currentGame : Game!
    
    func updateGameState(){
        if currentGame.incorrectMovesRemeaning == 0 {
            totalLoses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
//        correctWordLabel.text = currentGame.formattedWord
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLoses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemeaning)")
    }
    
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemeaning: incorrectMovesAllowed, guessedLetters: [])
            enableAllButtons(true)
            updateUI()
        } else {
            enableAllButtons(false)
        }
    }
    
    func enableAllButtons(_ enable: Bool){
        for button in letterButtons {
            button.isEnabled = enable
        }
    }


}

