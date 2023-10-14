import Matrix
import XCTest

@testable import Utils

final class StandardScalerTests: XCTestCase {
  func testFitAndTransform() throws {
    let testData = try Matrix<Double>(rows: [
      [1.0, 2.0, 3.0],
      [4.0, 5.0, 6.0],
      [7.0, 8.0, 9.0],
    ])

    let scaler = StandardScaler.fit(testData)

    XCTAssertEqual(scaler.mean, [4.0, 5.0, 6.0])
    XCTAssertEqual(scaler.std, [2.449489742783178, 2.449489742783178, 2.449489742783178])

    let transformedData = scaler.transform(testData)

    let expectedTransformedData = try Matrix<Double>(rows: [
      [-1.2247448713915892, -1.2247448713915892, -1.2247448713915892],
      [0.0, 0.0, 0.0],
      [1.2247448713915892, 1.2247448713915892, 1.2247448713915892],
    ])

    XCTAssertEqual(transformedData, expectedTransformedData)
  }
}
