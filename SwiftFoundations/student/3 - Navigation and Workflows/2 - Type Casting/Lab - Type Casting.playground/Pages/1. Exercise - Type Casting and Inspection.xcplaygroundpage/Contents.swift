/*:
## Exercise - Type Casting and Inspection

 Create a collection of type [Any], including a few doubles, integers, strings, and booleans within the collection. Print the contents of the collection.
 */
var collection: [Any] = [1, 1.2, "Hello", false, true, "Amogus", 2.2, 1234]
print(collection)
//:  Loop through the collection. For each integer, print "The integer has a value of ", followed by the integer value. Repeat the steps for doubles, strings and booleans.
for item in collection {
    if let curr_item = item as? Int {
        print("Integer value: \(curr_item)")
    } else if let curr_item = item as? Double {
        print("Double value: \(curr_item)")
    } else if let curr_item = item as? String {
        print("This is string: \(curr_item)")
    } else if let curr_item = item as? Bool {
        print("This bool value equals to: \(curr_item)")
    }
}

//:  Create a [String : Any] dictionary, where the values are a mixture of doubles, integers, strings, and booleans. Print the key/value pairs within the collection
var dictTest: [String: Any] = ["String_value": "123.1", "Double_value": 8.2, "Bool_value": false, "Int_value": 12]
print(dictTest)

//:  Create a variable `total` of type `Double` set to 0. Then loop through the dictionary, and add the value of each integer and double to your variable's value. For each string value, add 1 to the total. For each boolean, add 2 to the total if the boolean is `true`, or subtract 3 if it's `false`. Print the value of `total`.
var total: Double = 0
for (_, value) in dictTest{
    if value is String {
        total += 1
    } else if let curr_entry = value as? Bool {
        if curr_entry {
            total += 2
        } else {
            total -= 3
        }
    } else if let curr_entry = value as? Int {
        total += Double(curr_entry)
    } else if let curr_entry = value as? Double {
        total += curr_entry
    }
}
print (total)

//:  Create a variable `total2` of type `Double` set to 0. Loop through the collection again, adding up all the integers and doubles. For each string that you come across during the loop, attempt to convert the string into a number, and add that value to the total. Ignore booleans. Print the total.
var total2: Double = 0
for (_, value) in dictTest{
    if let curr_entry = value as? String {
        if let converted_string = Double(curr_entry){
            total += converted_string
        }
    } else if let curr_entry = value as? Int {
        total += Double(curr_entry)
    } else if let curr_entry = value as? Double {
        total += curr_entry
    }
}
print (total)

/*:
page 1 of 2  |  [Next: App Exercise - Workout Types](@next)
 */
