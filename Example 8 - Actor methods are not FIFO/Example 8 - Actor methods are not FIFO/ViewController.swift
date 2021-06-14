//
//  ViewController.swift
//  Example 8 - Actor methods are not FIFO
//
//  Created by Aleksander Lorenc on 11/06/2021.
//

import UIKit

actor OtherCache {
    func sometimesALongTask() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                continuation.resume()
            }
        }
    }
}

actor Cache {
    let otherCache = OtherCache()
    private var callCount = 0

    // Caches models, but every second models takes a long time to cache
    // and is suspended for 2 seconds.
    // In the meantime, because of reentrancy, every other model is immediately cached.
    func cache(_ model: Model) async {
        callCount += 1

        // Call to a long task to demonstrate reentrancy and
        // non-FIFO nature of actor method finishing
        if callCount % 2 == 0 {
            await sometimesALongTask()
        }
    }

    func sometimesALongTask() async {
        await otherCache.sometimesALongTask()
    }

}

struct Model {
    let name: String
}

class ViewController: UIViewController {
    let cache = Cache()

    override func viewDidLoad() {
        super.viewDidLoad()

        async {
            // Spawns a task group
            let result = await withTaskGroup(of: Model.self) { group -> [Model] in

                // Spawns 10 tasks which cache models
                // If the execution of methods' body were FIFO
                // the output would be models ordered from 1 to 10.
                // Running the example yields different results, however.
                for i in 1...10 {
                    group.async {
                        let model = Model(name: "Model \(i)")
                        await self.cache.cache(model)
                        return model
                    }
                }

                var models: [Model] = []

                // Await models
                for await model in group {
                    models.append(model)
                }

                return models
            }

            for model in result {
                print(model)
            }
        }
    }
}

/* Sample execution results:

Model 1
Model 3
Model 5
Model 7
Model 9
Model 2
Model 6
Model 8
Model 10
Model 4
*/
