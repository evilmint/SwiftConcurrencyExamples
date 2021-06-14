import Foundation

struct Offer: Hashable {
    let id: String
}

final class CartEventStore {

}

protocol Event {}
struct OfferAddedEvent: Event {
    let offer: Offer
    let count: Int
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

actor EventDispatcher {
    func dispatch(_ event: Event) async {
    }
}

@available(iOS 9999, *)
actor Cart {
    private let eventDispatcher: EventDispatcher
    private let taskExecutor = TaskExecutor()

    init(eventDispatcher: EventDispatcher) {
        self.eventDispatcher = eventDispatcher
    }

    var items: [Offer: Int] = [:]

    func add(_ item: Offer, count: Int) async {
        let count = (items[item] ?? 0) + count
        items[item] = count
        await taskExecutor.execute(SomeTask())

        let shouldBeTheSameCount = (items[item] ?? 0)

        if shouldBeTheSameCount != count {
            fatalError("Interleaving side-effect happened")
        }

        await eventDispatcher.dispatch(OfferAddedEvent(offer: item, count: items[item] ?? 0))
    }
}
