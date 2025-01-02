import Foundation

enum Category: String {
    case breakfast = "Breakfast"
    case soup = "Soup"
    case salad = "Salad"
    case appetizer = "Appetizer"
    case main = "Main"
    case side = "Side"
    case dessert = "Dessert"
    case snack = "Snack"
    case drink = "Drink"
}

struct Recipe: Identifiable, Decodable {
    let id = UUID() // Local UUID for your app
    var firestoreId: String? // Firestore document ID (optional)
    let name: String
    let image: String
    let ingredients: String
    let directions: String
    let category: Category.RawValue
    let datePublished: String
    let chefName: String
    let approved: Bool
}

extension Recipe {
    static let all: [Recipe] = [
        Recipe(name: "Cranberry Salsa",
               image: "https://plantyou.com/wp-content/uploads/2024/11/DSC04576.jpg",
               ingredients: "faruk",
               directions: "rafi",
               category: "soup",
               datePublished: "2019-11-11",
               chefName: "John Doe",
               approved: true)
    ]
}
