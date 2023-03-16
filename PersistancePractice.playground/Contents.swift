import UIKit

struct Note: Codable {
    let title: String
    let text: String
    let timestamp: Date
}

var notes: [Note] = []
let newNote = Note(title: "Hello", text: "Hello world", timestamp: Date())
let newNote1 = Note(title: "World", text: "Hello world part 2", timestamp: Date())

notes += [newNote, newNote1]
// Encoding Note
/*
let propertyListEncoder = PropertyListEncoder()
if let encodedNote = try? propertyListEncoder.encode(newNote){
    print(encodedNote)
    
    // Decoding note
    let propertyListDecoder = PropertyListDecoder()
    if let decodedNote = try? propertyListDecoder.decode(Note.self, from: encodedNote){
        print(decodedNote)
    }
}
*/

// Getting the documents path
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
// Appending notes_test.plist file to the documents folder
let archiveURL = documentsDirectory.appending(path: "notes_test.plist")

let propertyListEncoder = PropertyListEncoder()
let encodedNote = try? propertyListEncoder.encode(notes)

try? encodedNote?.write(to: archiveURL, options: .noFileProtection)

let propertyListDecode = PropertyListDecoder()
if let retrieveNoteData = try? Data(contentsOf: archiveURL),
   let decodeNote = try? propertyListDecode.decode(Array<Note>.self, from: retrieveNoteData){
    print(decodeNote)
}
