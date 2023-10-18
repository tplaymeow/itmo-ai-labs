import Matrix
import RealModule

public protocol KNNMetric<Item, Distance> {
  associatedtype Item
  associatedtype Distance: Comparable
  func distance(lhs: Matrix<Item>, rhs: Matrix<Item>) -> Distance
}

public struct EuclideanDistance<Item: Real>: KNNMetric {
  @inlinable
  public init() {}

  @inlinable
  public func distance(lhs: Matrix<Item>, rhs: Matrix<Item>) -> Item {
    try! .sqrt((lhs - rhs).reduce(.zero) { $0 + .pow($1, 2) })
  }
}
