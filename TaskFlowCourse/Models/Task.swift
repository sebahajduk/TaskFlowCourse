import Foundation

struct Task: Identifiable, Equatable, Codable {
  let id: UUID = .init()
  let name: String
  let dateCreated: Date
}
