import Foundation

struct Todo: Decodable {
    let userId: Int
}

struct CustomError: Error {}

@main
struct Main {
    static func main() async {
        print("Fetching todo.")

        let todo = await fetchTodo()
        print(todo.userId)

        print("Fetching custom data.")

        do {
            let customData = try await fetchCustomData()
            print(customData)
        } catch {
            print("Error caught: \(error)")
        }
    }

    static func updateWithCustomData(completionHandler: @escaping (Int) -> Void) {
        async(priority: .background) {
            let data = try await fetchCustomData()

            completionHandler(data)
        }
    }

    static func fetchCustomData() async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            closureBasedOutput { result in
                continuation.resume(with: result)
            }
        }
    }

    static func fetchTodo() async -> Todo {
        // Invoke the synchronous callback-based API
        await withCheckedContinuation { continuation in
            let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    let todo = try! JSONDecoder().decode(Todo.self, from: data)

                    // ...and resume the continuation when the callback is invoked
                    continuation.resume(returning: todo)
                } else {
                    // TBD - Example3
                }
            }.resume()
        }
    }

    static func closureBasedOutput(_ completionHandler: (Result<Int, Error>) -> Void) {
        if Int.random(in: 0...1) == 0 {
            completionHandler(.success(3))
        } else {
            completionHandler(.failure(CustomError()))
        }
    }
}
