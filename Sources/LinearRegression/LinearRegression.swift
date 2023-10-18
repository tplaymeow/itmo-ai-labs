import Foundation
import LinearAlgebra
import Matrix

public enum LinearRegressionError: Error {
  case wrongSize
}

public struct LinearRegression {
  @usableFromInline
  internal let coefficients: Matrix<Double>

  @usableFromInline
  internal init(coefficients: Matrix<Double>) {
    self.coefficients = coefficients
  }
}

extension LinearRegression {
  @inlinable
  public static func fit(x: Matrix<Double>, y: Matrix<Double>) throws -> Self {
    let x = x.insertedOnes()

    guard
      x.rowsCount == y.rowsCount,
      x.rowsCount >= x.columnsCount,
      y.columnsCount == 1
    else {
      throw LinearRegressionError.wrongSize
    }

    let xt = x.transposed()
    return .init(
      coefficients: try (xt * x).inversed() * xt * y
    )
  }
}

extension LinearRegression {
  @inlinable
  public func predict(x: Matrix<Double>) throws -> Matrix<Double> {
    let x = x.insertedOnes()

    guard
      x.columnsCount == self.coefficients.rowsCount
    else {
      throw LinearRegressionError.wrongSize
    }

    return try (x * self.coefficients)
  }
}

extension Matrix where Element == Double {
  @usableFromInline
  internal func insertedOnes() -> Matrix {
    try! .init(rows: self.array.map { [1.0] + $0 })
  }
}
