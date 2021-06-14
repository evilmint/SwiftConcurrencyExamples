//
//  TestActor.swift
//  Example 11 - Testing
//
//  Created by Aleksander Lorenc on 13/06/2021.
//

import Foundation

actor TestActor {
    func fetchAnswerToEverything() async -> Int {
        await withCheckedContinuation { c in
            DispatchQueue.global().async {
                c.resume(returning: 42)
            }
        }
    }
}
