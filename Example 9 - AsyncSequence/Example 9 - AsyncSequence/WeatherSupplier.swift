//
//  WeatherSupplier.swift
//  Example 9 - AsyncSequence
//
//  Created by Aleksander Lorenc on 12/06/2021.
//

import Foundation

struct Weather {
    let temp: Float
    let city: String
}

class WeatherSupplier: AsyncSequence {
    typealias Element = Weather

    struct AsyncIterator : AsyncIteratorProtocol {
        mutating func next() async -> Weather? {
            // If the task was cancelled - return nil
            if Task.isCancelled {
                print("Task was cancelled")
                return nil
            }

            await someLongTask()
            let degrees = Float.random(in: -10...35)

            // If the task was cancelled after returning from running a long task - return nil
            // Additionally, since Tasks from a tree, subtasks can check for cancellation as well.
            if Task.isCancelled {
                print("Task was cancelled")
                return nil
            }

            return Weather(temp: degrees, city: "Poznań")
        }

        private func someLongTask() async {
            return await withCheckedContinuation { c in
                // In this case if the task was cancelled we are calling resume anyway,
                // because otherwise our application would sit in an invalid state - someLongTask
                // would never return.
                if Task.isCancelled {
                    print("Task was cancelled")
                }

                DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
                    c.resume()
                }
            }
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator()
    }
}
