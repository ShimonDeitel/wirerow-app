import XCTest
@testable import wirerow

final class StoreTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddEntry() {
        let before = store.entries.count
        store.add(Entry(title: "Test", detail: "d", tag: "t"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteEntry() {
        let entry = Entry(title: "ToDelete", detail: "d", tag: "t")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(entry))
    }

    func testFreeLimitBlocksAdd() {
        for i in 0..<(Store.freeLimit + 5) {
            store.add(Entry(title: "E\(i)", detail: "d", tag: "t"))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCanAddMoreFalseAtLimit() {
        store.entries = Array(repeating: Entry(title: "x", detail: "d", tag: "t"), count: Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
    }

    func testProUnlockAllowsBeyondLimit() {
        store.entries = Array(repeating: Entry(title: "x", detail: "d", tag: "t"), count: Store.freeLimit)
        store.proUnlocked = true
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateEntry() {
        var entry = Entry(title: "Orig", detail: "d", tag: "t")
        store.add(entry)
        entry.title = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.title, "Updated")
    }
}
