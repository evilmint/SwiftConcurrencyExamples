import Foundation

@main
struct Main {
    static func main() {

    }
}

struct Offer: Hashable {
    let id: String
}

class Cart {
    var items: [Offer: Int] = [:]

    func add(_ item: Offer, count: Int) {
        items[item] = (items[item] ?? 0) + count
    }

    func remove(_ item: Offer, count: Int) {
        items[item] = max(0, (items[item] ?? 0) - count)
    }
}
