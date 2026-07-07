import XCTest

final class WirerowUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() throws {
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("New Entry")
        app.buttons["saveButton"].tap()
        XCTAssertTrue(app.staticTexts["New Entry"].waitForExistence(timeout: 2))
    }

    func testFreeLimitTriggersPaywall() throws {
        for i in 0..<20 {
            app.buttons["addButton"].tap()
            let titleField = app.textFields["titleField"]
            if titleField.waitForExistence(timeout: 1) {
                titleField.tap()
                titleField.typeText("Item \(i)")
                app.buttons["saveButton"].tap()
            } else {
                break
            }
        }
        XCTAssertTrue(app.buttons["subscribeButton"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() throws {
        app.buttons["addButton"].tap()
        let titleField = app.textFields["titleField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Dismiss test")
        app.otherElements.firstMatch.tap()
        XCTAssertFalse(titleField.isFocused)
    }

    func testSettingsOpens() throws {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
    }
}
