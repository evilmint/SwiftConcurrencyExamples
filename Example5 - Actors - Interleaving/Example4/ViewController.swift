import UIKit

struct TextGenerator {
    static func generateText() -> String {
        "wow \(Int.random(in: 111...999))"
    }
}

@available(iOS 9999, *)
class ViewController: UIViewController {
    @IBOutlet var counterLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchInitialText()
    }

    @IBAction func fetchTextTapped(_ sender: Any) {
        fetchText()
    }

    func fetchInitialText() {
        fetchText()
    }

    private func fetchText() {
        asyncDetached(priority: .userInteractive) {
            await updateText(TextGenerator.generateText())
        }
    }

    @MainActor
    func updateText(_ text: String) {
        counterLabel.text = text
    }
}
