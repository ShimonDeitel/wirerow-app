import Foundation

struct Entry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var detail: String
    var tag: String
    var dateCreated: Date = Date()
    var notes: String = ""
    var isFavorite: Bool = false
}
