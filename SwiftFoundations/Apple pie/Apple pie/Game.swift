//
//  Game.swift
//  Apple pie
//
//  Created by Антон Шалимов on 26.12.2022.
//

import Foundation

struct Game {
    var word: String
    var incorrectMovesRemeaning: Int
    var guessedLetters: [Character]
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }

    mutating func playerGuessed(letter: Character){
        guessedLetters.append(letter)
        if !word.contains(letter) {
            incorrectMovesRemeaning -= 1
        }
    }
}
