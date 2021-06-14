import Foundation

struct Offer: Hashable {
    let id: String
}

struct SomeTask {}

@available(iOS 9999, *)
actor TaskExecutor {
    func execute(_ task: SomeTask) async {
        await withUnsafeContinuation { c in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                c.resume()
            }
        }
    }
}

@available(iOS 9999, *)
actor Cart {
    var items: [Offer: Int] = [:]

    func add(_ item: Offer, count: Int) async {
        items[item] = (items[item] ?? 0) + count
    }
}
