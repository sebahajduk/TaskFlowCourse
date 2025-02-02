import Foundation

struct Task: Identifiable, Equatable, Codable {
  let id: UUID
  let name: String
  let dateCreated: Date

  init(
    id: UUID,
    name: String,
    dateCreated: Date)
  {
    self.id = id
    self.name = name
    self.dateCreated = dateCreated
  }
}
