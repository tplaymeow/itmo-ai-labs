import Foundation
import Matrix

public struct StandardScaler<Number: FloatingPoint> {
  @usableFromInline
  internal let mean: [Number]

  @usableFromInline
  internal let std: [Number]

  @usableFromInline
  internal init(mean: [Number], std: [Number]) {
    self.mean = mean
    self.std = std
  }
}

extension StandardScaler {
  @inlinable
  public static func fit(_ data: Matrix<Number>) -> Self {
    var mean: [Number] = []
    mean.reserveCapacity(data.columnsCount)
    for column in 0..<data.columnsCount {
      var sum: Number = .zero
      for row in 0..<data.rowsCount {
        sum += data[row, column]
      }
      mean.append(sum / Number(data.rowsCount))
    }

    var std: [Number] = []
    std.reserveCapacity(data.columnsCount)
    for column in 0..<data.columnsCount {
      var squareDiffSum: Number = .zero
      for row in 0..<data.rowsCount {
        let diff = data[row, column] - mean[column]
        squareDiffSum += diff * diff
      }
      std.append(sqrt(squareDiffSum / Number(data.rowsCount)))
    }

    return .init(mean: mean, std: std)
  }
}

extension StandardScaler {
  @inlinable
  public func transform(_ data: Matrix<Number>) -> Matrix<Number> {
    var rows: [[Number]] = []
    rows.reserveCapacity(data.rowsCount)

    for rowIndex in 0..<data.rowsCount {
      var row: [Number] = []
      row.reserveCapacity(data.columnsCount)

      for columnIndex in 0..<data.columnsCount {
        let data = data[rowIndex, columnIndex]
        let mean = self.mean[columnIndex]
        let std = self.std[columnIndex]
        row.append((data - mean) / std)
      }

      rows.append(row)
    }

    return try! Matrix(rows: rows)
  }
}
