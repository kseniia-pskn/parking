//
//  JSONLoaderTests.swift
//  Parking
//
//  Created by Kseniia Piskun on 20.08.2024.
//

import Foundation
import XCTest

@testable import Parking

class JSONLoaderTests: XCTestCase {
    
    var jsonLoader: JSONLoader!

    override func setUp() {
        super.setUp()
        jsonLoader = JSONLoader()
    }

    override func tearDown() {
        jsonLoader = nil
        super.tearDown()
    }

    func testLoadJSONData() {
        // Test loading the JSON data from a file
        let data = jsonLoader.loadJSONData(from: "data")
        XCTAssertNotNil(data, "Data should not be nil")
    }

    func testParseJSON() {
        // Test parsing the loaded JSON data
        if let data = jsonLoader.loadJSONData(from: "data") {
            let rootData = jsonLoader.parseJSON(jsonData: data)
            XCTAssertNotNil(rootData, "RootData should not be nil")
            XCTAssertEqual(rootData?.locationData.zones.count, 6, "Should parse 6 zones")
        }
    }

    func testZoneParsing() {
        // Test that the zones are parsed correctly
        if let data = jsonLoader.loadJSONData(from: "data") {
            let rootData = jsonLoader.parseJSON(jsonData: data)
            XCTAssertNotNil(rootData, "RootData should not be nil")
            XCTAssertEqual(rootData?.locationData.zones.count, 6, "Should parse 6 zones")
            
            let firstZone = rootData?.locationData.zones.first
            XCTAssertNotNil(firstZone, "First zone should not be nil")
            XCTAssertEqual(firstZone?.id, "157", "First zone ID should be '157'")
            XCTAssertEqual(firstZone?.name, "Tampere Rautatientori", "First zone name should be 'Tampere Rautatientori'")
            XCTAssertEqual(firstZone?.paymentIsAllowed, "0", "First zone paymentIsAllowed should be '0'")
            XCTAssertEqual(firstZone?.servicePrice, "0.49", "First zone service price should be '0.49'")
        }
    }
    
    func testBoundsParsing() {
        // Test that the bounds are parsed correctly
        if let data = jsonLoader.loadJSONData(from: "data") {
            let rootData = jsonLoader.parseJSON(jsonData: data)
            XCTAssertNotNil(rootData, "RootData should not be nil")
            
            guard let bounds = rootData?.locationData.bounds else { return             XCTAssertNotNil(rootData?.locationData.bounds, "Bounds should not be nil") }
            XCTAssertEqual(bounds.north, 60.178341169153, accuracy: 0.000001, "North bound should match expected value")
            XCTAssertEqual(bounds.south, 60.161369987325, accuracy: 0.000001, "South bound should match expected value")
            XCTAssertEqual(bounds.west, 24.909604261688, accuracy: 0.000001, "West bound should match expected value")
            XCTAssertEqual(bounds.east, 24.967153738312, accuracy: 0.000001, "East bound should match expected value")
        }
    }
}
