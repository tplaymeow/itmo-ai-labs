import Foundation
import MetaCodable

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
