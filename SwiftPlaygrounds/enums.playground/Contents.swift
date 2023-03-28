import UIKit

enum StateRestorationController {
    enum Identifier: String {
        case categories, menu, order
    }
    
    case categories
    case menu(category: String)
    case order
    
    var identifier: Identifier {
        switch self {
        case .categories: return Identifier.categories
        case .menu: return Identifier.menu
        case .order: return Identifier.order
        }
    }
}

print(StateRestorationController.Identifier(rawValue: "menu")!)
