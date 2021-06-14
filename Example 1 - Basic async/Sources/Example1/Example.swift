import Foundation

@main
struct Main {
    static func main() async {
        let x = await fetchAmountOfApples_Unsafe()
        print(x)

        async let y = fetchAmountOfApples_Checked()
        print(await y)
        // or await print(y) - just like try method(throwingFunc()) or method(try throwingFunc())

        async let zipped_1 = fetchAmountOfApples_Unsafe()
        async let zipped_2 = fetchAmountOfApples_Unsafe()

        await print(zipped_1, zipped_2)
    }

    static func fetchAmountOfApples_Unsafe() async -> Int {
        print("Started fetchAmountOfApples_Unsafe")

        return await withUnsafeContinuation { c in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                c.resume(returning: 3)
            }
        }
    }

    static func fetchAmountOfApples_Checked() async -> Int {
        print("Started fetchAmountOfApples_Checked")
        return await withCheckedContinuation { c in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                c.resume(returning: 5)
            }
        }
    }

    static func fetchAmountOfApplesChecked() async -> Int {
        print("Started fetchAmountOfApplesChecked")
        return await withCheckedContinuation { c in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                c.resume(returning: 5)
            }
        }
    }
}
