import CodableCSV
import Foundation
import LinearRegression
import Matrix
import MetaCodable
import Plot
import StandardScaler
import Utils

@Codable
struct Item {
  enum ExtracurricularActivities: String, Codable {
    case yes = "Yes"
    case no = "No"
  }

  @CodedAt("Hours Studied")
  let hoursStudied: Double

  @CodedAt("Previous Scores")
  let previousScores: Double

  @CodedAt("Extracurricular Activities")
  let extracurricularActivities: ExtracurricularActivities

  @CodedAt("Sleep Hours")
  let sleepHours: Double

  @CodedAt("Sample Question Papers Practiced")
  let sampleQuestionPapersPracticed: Double

  @CodedAt("Performance Index")
  let performanceIndex: Double
}

let url = URL(
  fileURLWithPath:
    "/Users/tplaymeow/Desktop/itmo-ai-labs/Datasets/StudentPerformance/Student_Performance.csv")
let data = try Data(contentsOf: url)
let items = try CSVDecoder { $0.headerStrategy = .firstLine }
  .decode([Item].self, from: data)

let output = "/Users/tplaymeow/Desktop/itmo-ai-labs/Datasets/StudentPerformance/Output"

try boxplot(
  x: items.map(\.hoursStudied),
  output: "\(output)/BP_hoursStudied.png")
try boxplot(
  x: items.map(\.previousScores),
  output: "\(output)/BP_previousScores.png")
try boxplot(
  x: items.map { $0.extracurricularActivities == .yes ? 1.0 : 0.0 },
  output: "\(output)/BP_extracurricularActivities.png")
try boxplot(
  x: items.map(\.sleepHours),
  output: "\(output)/BP_sleepHours.png")
try boxplot(
  x: items.map(\.sampleQuestionPapersPracticed),
  output: "\(output)/BP_sampleQuestionPapersPracticed.png")
try boxplot(
  x: items.map(\.performanceIndex),
  output: "\(output)/BP_performanceIndex.png")

try scatter(
  x: items.map(\.hoursStudied),
  y: items.map(\.performanceIndex),
  output: "\(output)/SC_hoursStudied.png")
try scatter(
  x: items.map(\.previousScores),
  y: items.map(\.performanceIndex),
  output: "\(output)/SC_previousScores.png")
try scatter(
  x: items.map { $0.extracurricularActivities == .yes ? 1.0 : 0.0 },
  y: items.map(\.performanceIndex),
  output: "\(output)/SC_extracurricularActivities.png")
try scatter(
  x: items.map(\.sleepHours),
  y: items.map(\.performanceIndex),
  output: "\(output)/SC_sleepHours.png")
try scatter(
  x: items.map(\.sampleQuestionPapersPracticed),
  y: items.map(\.performanceIndex),
  output: "\(output)/SC_sampleQuestionPapersPracticed.png")

let (trainItems, testItems) = trainTestSplit(items, by: 0.8)

func run(
  trainX: Matrix<Double>,
  trainY: Matrix<Double>,
  testX: Matrix<Double>,
  testY: Matrix<Double>
) throws {
  let standardScaler = StandardScaler.fit(trainX)
  let scaledTrainX = standardScaler.transform(trainX)
  let scaledTestX = standardScaler.transform(testX)

  let linearRegression = try LinearRegression.fit(x: scaledTrainX, y: trainY)
  let predictedTestY = try linearRegression.predict(x: scaledTestX)

  let mae = meanAbsoluteError(actual: testY.flattenArray, predicted: predictedTestY.flattenArray)
  let mse = meanSquaredError(actual: testY.flattenArray, predicted: predictedTestY.flattenArray)
  let r2 = r2Score(actual: testY.flattenArray, predicted: predictedTestY.flattenArray)

  print("Mean absolute error: \(mae)")
  print("Mean squared error: \(mse)")
  print("R2 score: \(r2)")
  print("---------------------------")
}

try run(
  trainX: try Matrix(
    rows: trainItems.map {
      [
        $0.hoursStudied,
        $0.previousScores,
        $0.extracurricularActivities == .yes ? 1.0 : 0.0,
        $0.sleepHours,
        $0.sampleQuestionPapersPracticed,
      ]
    }),
  trainY: Matrix(column: trainItems.map(\.performanceIndex)),
  testX: try Matrix(
    rows: testItems.map {
      [
        $0.hoursStudied,
        $0.previousScores,
        $0.extracurricularActivities == .yes ? 1.0 : 0.0,
        $0.sleepHours,
        $0.sampleQuestionPapersPracticed,
      ]
    }),
  testY: Matrix(column: testItems.map(\.performanceIndex))
)

try run(
  trainX: try Matrix(
    rows: trainItems.map {
      [
        $0.previousScores,
        $0.extracurricularActivities == .yes ? 1.0 : 0.0,
        $0.sampleQuestionPapersPracticed,
      ]
    }),
  trainY: Matrix(column: trainItems.map(\.performanceIndex)),
  testX: try Matrix(
    rows: testItems.map {
      [
        $0.previousScores,
        $0.extracurricularActivities == .yes ? 1.0 : 0.0,
        $0.sampleQuestionPapersPracticed,
      ]
    }),
  testY: Matrix(column: testItems.map(\.performanceIndex))
)

try run(
  trainX: try Matrix(
    rows: trainItems.map {
      [
        $0.previousScores,
        $0.sleepHours,
      ]
    }),
  trainY: Matrix(column: trainItems.map(\.performanceIndex)),
  testX: try Matrix(
    rows: testItems.map {
      [
        $0.previousScores,
        $0.sleepHours,
      ]
    }),
  testY: Matrix(column: testItems.map(\.performanceIndex))
)
