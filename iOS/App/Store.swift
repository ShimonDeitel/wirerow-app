import Foundation
import Combine

final class Store: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var proUnlocked: Bool = false

    static let freeLimit = 12

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("wirerow", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
        if entries.isEmpty {
            seed()
        }
    }

    var canAddMore: Bool {
        proUnlocked || entries.count < Store.freeLimit
    }

    func add(_ entry: Entry) {
        guard canAddMore else { return }
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: Entry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: Entry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func seed() {
        entries = [
            Entry(title: "First project", detail: "Log projects with wire gauge, metal, and stone used", tag: "starter"),
            Entry(title: "Second project", detail: "Sample entry", tag: "starter"),
            Entry(title: "Third project", detail: "Sample entry", tag: "starter")
        ]
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
