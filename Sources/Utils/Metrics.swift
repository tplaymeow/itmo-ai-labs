import Foundation

@inlinable
public func meanAbsoluteError(
  actual: [Double],
  predicted: [Double]
) -> Double {
  zip(actual, predicted)
    .reduce(0) { $0 + abs($1.0 - $1.1) }
    / Double(min(actual.count, predicted.count))
}

@inlinable
public func meanSquaredError(
  actual: [Double],
  predicted: [Double]
) -> Double {
  zip(actual, predicted)
    .reduce(0) { $0 + pow($1.0 - $1.1, 2) }
    / Double(min(actual.count, predicted.count))
}

@inlinable
public func r2Score(
  actual: [Double],
  predicted: [Double]
) -> Double {
  let meanActual = actual.reduce(0, +) / Double(actual.count)
  let tss = actual.reduce(0) { $0 + pow($1 - meanActual, 2) }
  let rss = zip(actual, predicted).reduce(0) { $0 + pow($1.0 - $1.1, 2) }
  return 1 - (rss / tss)
}
