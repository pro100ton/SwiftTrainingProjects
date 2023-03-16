import UIKit

struct Food {
    var name: String
    var description: String
}


struct Meal {
    var name: String
    var food: [Food]
}



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


func numbersOfRowsInSection() -> [Int] {
    var tmp: [Int] = []
    for meal in meals {
        tmp.append(meal.food.count)
    }
    return tmp
}

print(numbersOfRowsInSection())
