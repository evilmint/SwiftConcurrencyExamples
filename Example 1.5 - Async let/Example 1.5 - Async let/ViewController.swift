//
//  ViewController.swift
//  Example 1.5 - Async let
//
//  Created by Aleksander Lorenc on 14/06/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        async {
            async let firstNumber = fetchFirstNumber()
            async let secondNumber = fetchSecondNumber()

            textLabel.text = "Numbers: \(await firstNumber), \(await secondNumber)"
        }
    }

    func fetchFirstNumber() async -> Int {
        print("Fetching first number")
        return 42
    }

    func fetchSecondNumber() async -> Int {
        print("Fetching second number")
        return await withCheckedContinuation { c in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                c.resume(returning: 420)
            }
        }
    }
}

