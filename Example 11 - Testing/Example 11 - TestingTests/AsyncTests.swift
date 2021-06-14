@testable import Example_11___Testing
import XCTest

class AsyncTests: XCTestCase {

    func testAsync() async {
        // Arrange
        let sut = TestActor()

        // Act
        let integer = await sut.fetchAnswerToEverything()

        // Assert
        XCTAssertEqual(integer, 42)
    }
}
