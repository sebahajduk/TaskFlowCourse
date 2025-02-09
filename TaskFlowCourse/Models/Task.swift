import Foundation

struct Task: Identifiable, Equatable, Codable {
  let id: UUID
  let name: String
  let dateCreated: Date
  var finishDate: Date?
  var sessions: [Date: Double]

  init(
    id: UUID,
    name: String,
    dateCreated: Date,
    finishDate: Date? = nil,
    sessions: [Date: Double] = [:]
  ) {
    self.id = id
    self.name = name
    self.dateCreated = dateCreated
    self.finishDate = finishDate
    self.sessions = sessions
  }
}
