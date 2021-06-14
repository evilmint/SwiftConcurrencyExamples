import UIKit

@available(iOS 9999, *)
class ViewController: UIViewController {
    let cart = Cart(eventDispatcher: EventDispatcher())

    override func viewDidLoad() {
        super.viewDidLoad()

        simulateCartOperations()
    }

    func simulateCartOperations() {
        let group = DispatchGroup()

        group.enter()
        group.enter()

        asyncDetached {
            for i in 1...100 {
                await self.cart.add(Offer(id: "abc"), count: i)
            }

            group.leave()
        }

        asyncDetached {
            for i in 1...100 {
                await self.cart.add(Offer(id: "abc"), count: i)
            }

            group.leave()
        }

        group.wait()

        asyncDetached {
            await print(cart.items)
        }
    }
}
