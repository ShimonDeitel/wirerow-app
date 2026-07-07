import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var showingPaywall = false
    @State private var editingEntry: Entry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.entries.isEmpty {
                    VStack(spacing: 12) {
                        Text("Log projects with wire gauge, metal, and stone used")
                            .font(Theme.body())
                            .foregroundStyle(Theme.ink.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(store.entries) { entry in
                            Button {
                                editingEntry = entry
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.title)
                                        .font(Theme.body(18))
                                        .foregroundStyle(Theme.ink)
                                    Text(entry.detail)
                                        .font(Theme.body(14))
                                        .foregroundStyle(Theme.ink.opacity(0.6))
                                    Text(entry.tag.uppercased())
                                        .font(Theme.label(11))
                                        .foregroundStyle(Theme.accent)
                                }
                                .padding(.vertical, 4)
                            }
                            .accessibilityIdentifier("entryRow_\(entry.title)")
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                        .listRowBackground(Theme.background)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Wire Row - Jewelry Wire Log")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                EntryEditorView(entry: nil) { newEntry in
                    store.add(newEntry)
                }
            }
            .sheet(item: $editingEntry) { entry in
                EntryEditorView(entry: entry) { updated in
                    store.update(updated)
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
        .tint(Theme.accent)
    }
}

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var detail: String
    @State private var tag: String
    @FocusState private var focusedField: Field?
    let onSave: (Entry) -> Void
    let existing: Entry?

    enum Field { case title, detail, tag }

    init(entry: Entry?, onSave: @escaping (Entry) -> Void) {
        self.existing = entry
        self._title = State(initialValue: entry?.title ?? "")
        self._detail = State(initialValue: entry?.detail ?? "")
        self._tag = State(initialValue: entry?.tag ?? "")
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 16) {
                    TextField("Title", text: $title)
                        .focused($focusedField, equals: .title)
                        .accessibilityIdentifier("titleField")
                        .textFieldStyle(.roundedBorder)
                    TextField("Detail", text: $detail)
                        .focused($focusedField, equals: .detail)
                        .accessibilityIdentifier("detailField")
                        .textFieldStyle(.roundedBorder)
                    TextField("Tag", text: $tag)
                        .focused($focusedField, equals: .tag)
                        .accessibilityIdentifier("tagField")
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .navigationTitle(existing == nil ? "New Entry" : "Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var entry = existing ?? Entry(title: "", detail: "", tag: "")
                        entry.title = title
                        entry.detail = detail
                        entry.tag = tag
                        onSave(entry)
                        dismiss()
                    }
                    .accessibilityIdentifier("saveButton")
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
