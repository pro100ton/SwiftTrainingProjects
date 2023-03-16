//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Антон Шалимов on 04.02.2023.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis: [Emoji] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Test if it works, otherwise set it via size inspector of TVC
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
        
        // MARK: Note: Way 1 to implement enabling edit mode for the table
        navigationItem.leftBarButtonItem = editButtonItem

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        let loadedEmojis = Emoji.loadFromFile()
        if loadedEmojis.count == 0 {
            emojis = Emoji.sampleEmojis()
        } else {
            emojis = loadedEmojis
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: Note: this code will reload table view data when edit is done
        tableView.reloadData()
    }

    // MARK: - Table view data source
    // MARK: Note - code below moved to Emoji model file in Lab for saving data
    /*
    var emojis: [Emoji] = [
        Emoji(symbol: "😀", name: "Grinning Face",
              description: "A typical smiley face.", usage: "happiness"),
        Emoji(symbol: "😕", name: "Confused Face",
              description: "A confused, puzzled face.", usage: "unsure what to think; displeasure"),
        Emoji(symbol: "😍", name: "Heart Eyes",
              description: "A smiley face with hearts for eyes.",
              usage: "love of something; attractive"),
        Emoji(symbol: "🧑‍💻", name: "Developer",
              description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).", usage: "apps, software, programming"),
        Emoji(symbol: "🐢", name: "Turtle", description:
                "A cute turtle.", usage: "something slow"),
        Emoji(symbol: "🐘", name: "Elephant", description:
                "A gray elephant.", usage: "good memory"),
        Emoji(symbol: "🍝", name: "Spaghetti",
              description: "A plate of spaghetti.", usage: "spaghetti"),
        Emoji(symbol: "🎲", name: "Die", description: "A single die.", usage: "taking a risk, chance; game"),
        Emoji(symbol: "⛺️", name: "Tent", description: "A small tent.", usage: "camping"),
        Emoji(symbol: "📚", name: "Stack of Books",
              description: "Three colored books stacked on each other.",
              usage: "homework, studying"),
        Emoji(symbol: "💔", name: "Broken Heart",
              description: "A red, broken heart.", usage: "extreme sadness"), Emoji(symbol: "💤", name: "Snore", description: "Three blue \'z\'s.", usage: "tired, sleepiness"),
        Emoji(symbol: "🏁", name: "Checkered Flag",
              description: "A black-and-white checkered flag.", usage:
                "completion")
    ]
     */
   
    // MARK: Note: Way 2 to implement enabling edit mode for the table
//    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
//        let tableViewEditingMode = tableView.isEditing
//        tableView.setEditing(!tableViewEditingMode, animated: true)
//    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // MARK: Note: only one emoji section is initialized in this app
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojis.count
    }
    
    // MARK: Note: Add "delete" icon to rows when going into editing mode
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath)
        // Setting up emoji row content
        let emoji = emojis[indexPath.row]
        // Configuring cell content
        var content = cell.defaultContentConfiguration()
        content.text = "\(emoji.symbol) - \(emoji.name)"
        content.secondaryText = emoji.description
        cell.contentConfiguration = content
        
        // Enabling the reorder mode fot table view cells
        // MARK: Note: this option only works when table is in edit mode
        cell.showsReorderControl = true
        return cell
    }
         */
        // Step 1: Dequeue cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as! EmojiTableViewCell
        // Step 2: Fetch model object to display
        let emoji = emojis[indexPath.row]
        
        // Step 3: Configure the cell
        cell.update(with: emoji)
        cell.showsReorderControl = true
        return cell
    }
    

    @IBAction func unwindEmojiTableView(unwindSegue: UIStoryboardSegue) {
        // Verifing that "saveUnwind" segue was triggered
        // 1 - checking the segue ID
        // 2 - checking that segue source is Add emoji VC
        // 3 - assigning emoji to Emoji object from add VC
        guard unwindSegue.identifier == "saveUnwind",
              let sourceViewController = unwindSegue.source as? AddEditEmojiTableViewController,
              let emoji = sourceViewController.emoji else {return}
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            Emoji.saveToFile(emojis: emojis)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            Emoji.saveToFile(emojis: emojis)
        }
        
    }
    
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            print("Cell was tapped")
            // Editing the emoji
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        } else {
            // Adding emoji
            print("Add button was tapped")
            return AddEditEmojiTableViewController(coder: coder, emoji: nil)
        }
    }
    
    /*
    // MARK: Note: Table View Delegate "didSelectRowAt" method implementation
    /// Table view delegate "didSelectRowAt" method implementation
    /// - Parameters:
    ///   - tableView: source table view class
    ///   - indexPath: indexPath of the user selected row to edit
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let emoji = emojis[indexPath.row]
        print("\(emoji.symbol) - \(indexPath)")
    }
    */

    // MARK: Note: Table View Delegate "moveRowAt" method implementation
    /// Implementation of Table View Delegate "moveRowAt" method
    /// - Parameters:
    ///   - tableView: source table view class
    ///   - sourceIndexPath: row, selected by use to move
    ///   - destinationIndexPath: destination row user selecter to move source row at
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = emojis.remove(at:sourceIndexPath.row)
        emojis.insert(movedEmoji, at: destinationIndexPath.row)
        Emoji.saveToFile(emojis: emojis)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Emoji.saveToFile(emojis: emojis)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
