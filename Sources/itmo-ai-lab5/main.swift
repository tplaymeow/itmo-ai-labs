import CodableCSV
import Foundation
import KNearestNeighbors
import Matrix
import MetaCodable
import StandardScaler
import Utils

@Codable
struct Item {
  enum Outcome: String, Hashable, Codable {
    case yes = "1"
    case no = "0"
  }

  @CodedAt("Pregnancies")
  let pregnancies: Double

  @CodedAt("Glucose")
  let glucose: Double

  @CodedAt("BloodPressure")
  let bloodPressure: Double

  @CodedAt("SkinThickness")
  let skinThickness: Double

  @CodedAt("Insulin")
  let insulin: Double

  @CodedAt("BMI")
  let bmi: Double

  @CodedAt("Pedigree")
  let pedigree: Double

  @CodedAt("Age")
  let age: Double

  @CodedAt("Outcome")
  let outcome: Outcome
}

func reportResult(
  title: String,
  actual: Matrix<Item.Outcome>,
  predicted: Matrix<Item.Outcome>
) {
  var tp = 0
  var fp = 0
  var fn = 0
  var tn = 0
  for (actual, predicted) in zip(actual.flattenArray, predicted.flattenArray) {
    switch (actual, predicted) {
    case (.yes, .yes): tp += 1
    case (.yes, .no): fn += 1
    case (.no, .yes): fp += 1
    case (.no, .no): tn += 1
    }
  }

  let tpString = tp.formatted().padding(toLength: 3, withPad: " ", startingAt: 0)
  let fpString = fp.formatted().padding(toLength: 3, withPad: " ", startingAt: 0)
  let fnString = fn.formatted().padding(toLength: 3, withPad: " ", startingAt: 0)
  let tnString = tn.formatted().padding(toLength: 3, withPad: " ", startingAt: 0)
  print(
    """
    \(title):
    +------------+-----------+
    |            |  Act val  |
    |            +-----+-----+
    |            | Pos | Neg |
    +------+-----+-----+-----+
    | Pred | Pos | \(tpString) | \(fpString) |
    |      +-----+-----+-----+
    | vals | Neg | \(fnString) | \(tnString) |
    +------+-----+-----+-----+
    Accuracy: \(Double(tp + tn) / Double(tp + tn + fp + fn))

    """)
}

let url = URL(
  fileURLWithPath:
    "/Users/tplaymeow/Desktop/itmo-ai-labs/Datasets/DiabetesPrediction/diabetes.csv")
let data = try Data(contentsOf: url)
let items = try CSVDecoder { $0.headerStrategy = .firstLine }
  .decode([Item].self, from: data)

let (trainItems, testItems) = trainTestSplit(items, by: 0.8)

func run(
  trainX: Matrix<Double>,
  trainY: Matrix<Item.Outcome>,
  testX: Matrix<Double>,
  testY: Matrix<Item.Outcome>
) throws {
  let standardScaler = StandardScaler.fit(trainX)
  let scaledTrainX = standardScaler.transform(trainX)
  let scaledTestX = standardScaler.transform(testX)

  func run(count: Int) throws {
    let knn = try KNearestNeighbors.fit(
      items: scaledTrainX,
      labels: trainY,
      metric: EuclideanDistance<Double>(),
      configuration: Configuration(count: count)
    )
    try reportResult(
      title: "Test, K=\(count)",
      actual: testY,
      predicted: knn.predict(items: scaledTestX)
    )
    try reportResult(
      title: "Train, K=\(count)",
      actual: trainY,
      predicted: knn.predict(items: scaledTrainX)
    )
  }

  try run(count: 3)
  try run(count: 5)
  try run(count: 10)
  try run(count: 20)
}

print("All parameters:")
try run(
  trainX: Matrix(
    rows: trainItems.map {
      [
        $0.pregnancies,
        $0.glucose,
        $0.bloodPressure,
        $0.skinThickness,
        $0.insulin,
        $0.bmi,
        $0.pedigree,
        $0.age,
      ]
    }),
  trainY: Matrix(column: trainItems.map(\.outcome)),
  testX: Matrix(
    rows: testItems.map {
      [
        $0.pregnancies,
        $0.glucose,
        $0.bloodPressure,
        $0.skinThickness,
        $0.insulin,
        $0.bmi,
        $0.pedigree,
        $0.age,
      ]
    }),
  testY: Matrix(column: testItems.map(\.outcome))
)

print("Random parameters:")
try run(
  trainX: Matrix(
    rows: trainItems.map {
      [
        $0.pregnancies,
        $0.bloodPressure,
        $0.insulin,
        $0.pedigree,
      ]
    }),
  trainY: Matrix(column: trainItems.map(\.outcome)),
  testX: Matrix(
    rows: testItems.map {
      [
        $0.pregnancies,
        $0.bloodPressure,
        $0.insulin,
        $0.pedigree,
      ]
    }),
  testY: Matrix(column: testItems.map(\.outcome))
)
