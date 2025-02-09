import Foundation

struct Task: Identifiable, Equatable, Codable {
  let id: UUID
  let name: String
  let dateCreated: Date
  var finishDate: Date?

  init(
    id: UUID,
    name: String,
    dateCreated: Date,
    finishDate: Date? = nil
  ) {
    self.id = id
    self.name = name
    self.dateCreated = dateCreated
    self.finishDate = finishDate
  }
}
