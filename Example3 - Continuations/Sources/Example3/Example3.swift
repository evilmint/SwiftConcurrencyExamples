import Foundation

struct Todo: Decodable {
    let userId: Int
}

struct CustomError: Error {}
struct URLConstructionError: Error {}

@main
struct Main {
    static func main() async {
        do {
            let todo = try await fetchTodo()
            print(todo.userId)
        } catch {
            print("Error thrown while fetching todos")
        }
    }

    static func fetchTodo() async throws -> Todo {
        try await withUnsafeThrowingContinuation { continuation in
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
                continuation.resume(throwing: URLConstructionError())
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    do {
                        let todo = try JSONDecoder().decode(Todo.self, from: data)
                        continuation.resume(returning: todo)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                } else {
                    continuation.resume(throwing: CustomError())
                }
            }.resume()
        }
    }
}
