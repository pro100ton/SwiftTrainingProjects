//
//  FoodTableViewController.swift
//  MealTracker
//
//  Created by Антон Шалимов on 05.02.2023.
//

import UIKit

class FoodTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    var omelet: Food = Food(name: "Omelete", description: "Declicious 2 eggs omelete")
    var pasta: Food = Food(name: "Pasta", description: "Italian classic pasta")
    var yogurt: Food = Food(name: "Yogurt", description: "Nice healthy yogurt to end day on a good note")
    var bread: Food = Food(name: "Bread", description: "Nice sncak to use as a side meal")
    var chips: Food = Food(name: "Chips", description: "Not healthy but very tasty snack")
    
    var meals: [Meal] {
        let meal1 = Meal(name: "Breakfast", food: [omelet, bread])
        let meal2 = Meal(name: "Lunch", food: [pasta, chips])
        let meal3 = Meal(name: "Dinner", food: [yogurt])
        return [meal1, meal2, meal3]
    }
    
    var numberOfRowsInSection: [Int] {
        var tmp: [Int] = []
        for meal in meals {
            tmp.append(meal.food.count)
        }
        return tmp
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        
        if section < numberOfRowsInSection.count {
            rows = numberOfRowsInSection[section]
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food", for: indexPath)
        let meal = meals[indexPath.section]
        let food = meal.food[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = food.name
        content.secondaryText = food.description
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meals[section].name
    }
   
}
