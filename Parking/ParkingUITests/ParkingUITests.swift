//
//  ParkingUITests.swift
//  ParkingUITests
//
//  Created by Kseniia Piskun on 20.08.2024.
//

import XCTest

final class ParkingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.maps.element.exists)

        let parkingButton = app.buttons["parkingButton"]
        XCTAssertTrue(parkingButton.exists)
        XCTAssertEqual(parkingButton.label, "Parking Not Available")

        let map = app.maps.element
        map.tap()

        XCTAssertEqual(parkingButton.label, "Start Parking")

        parkingButton.tap()

        XCTAssertEqual(parkingButton.label, "End Parking")

        parkingButton.tap()

        XCTAssertEqual(parkingButton.label, "Parking Not Available")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testPinMovementAndZoneSelection() throws {
        let app = XCUIApplication()
        app.launch()

        let map = app.maps.element
        map.press(forDuration: 0.5, thenDragTo: app.buttons["zoomOutButton"])

        let parkingButton = app.buttons["parkingButton"]
        XCTAssertEqual(parkingButton.label, "Start Parking")
    }

    func testZoomInAndOut() throws {
        let app = XCUIApplication()
        app.launch()

        let zoomInButton = app.buttons["zoomInButton"]
        let zoomOutButton = app.buttons["zoomOutButton"]

        XCTAssertTrue(zoomInButton.exists)
        XCTAssertTrue(zoomOutButton.exists)

        zoomInButton.tap()

        zoomOutButton.tap()
    }
}
