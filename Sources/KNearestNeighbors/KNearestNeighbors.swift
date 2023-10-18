import Algorithms
import Matrix

public enum KNearestNeighborsFitError: Error {
  case wrongSize
}

public struct KNearestNeighbors<Item, Label: Hashable, Metric: KNNMetric>
where Metric.Item == Item {
  @usableFromInline
  internal let trainItems: Matrix<Item>

  @usableFromInline
  internal let trainLabels: Matrix<Label>

  @usableFromInline
  internal let metric: Metric

  @usableFromInline
  internal let configuration: Configuration

  @usableFromInline
  internal init(
    trainItems: Matrix<Item>,
    trainLabels: Matrix<Label>,
    metric: Metric,
    configuration: Configuration
  ) {
    self.trainItems = trainItems
    self.trainLabels = trainLabels
    self.metric = metric
    self.configuration = configuration
  }
}

extension KNearestNeighbors {
  @inlinable
  public static func fit(
    items: Matrix<Item>,
    labels: Matrix<Label>,
    metric: Metric,
    configuration: Configuration
  ) throws -> Self {
    guard
      labels.rowsCount > 0,
      items.rowsCount > 0,
      labels.rowsCount == items.rowsCount,
      labels.columnsCount == 1
    else {
      throw KNearestNeighborsFitError.wrongSize
    }

    return .init(
      trainItems: items,
      trainLabels: labels,
      metric: metric,
      configuration: configuration
    )
  }
}

extension KNearestNeighbors {
  @inlinable
  public func predict(items: Matrix<Item>) throws -> Matrix<Label> {
    guard
      items.columnsCount == self.trainItems.columnsCount
    else {
      throw KNearestNeighborsFitError.wrongSize
    }

    var resultColumn: [Label] = []
    resultColumn.reserveCapacity(items.rowsCount)
    for itemRowIndex in (0..<items.rowsCount) {
      let item = items.rowAsMatrix(itemRowIndex)

      var distances: [(Metric.Distance, Label)] = []
      distances.reserveCapacity(self.trainItems.rowsCount)
      for trainItemRowIndex in (0..<self.trainItems.rowsCount) {
        let trainItem = self.trainItems.rowAsMatrix(trainItemRowIndex)
        let trainLabel = self.trainLabels[trainItemRowIndex, 0]
        let distance = self.metric.distance(lhs: item, rhs: trainItem)
        distances.append((distance, trainLabel))
      }

      let nearestNeighbors =
        distances
        .min(count: self.configuration.count) { $0.0 < $1.0 }

      var nearestNeighborsCounts: [Label: Int] = [:]
      for (_, label) in nearestNeighbors {
        nearestNeighborsCounts[label, default: 0] += 1
      }

      resultColumn.append(
        nearestNeighborsCounts
          .max { $0.value < $1.value }!.key)
    }

    return Matrix(column: resultColumn)
  }
}

extension Matrix {
  @inlinable
  internal func rowAsMatrix(_ row: Int) -> Matrix {
    .init(row: Array(self[row: row]))
  }
}
