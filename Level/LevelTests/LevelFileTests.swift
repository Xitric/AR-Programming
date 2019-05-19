//
//  LevelFileTests.swift
//  Level
//  
//  Created by Kasper Schultz Davidsen on 11/05/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import XCTest
@testable import Level

class LevelFileTests: XCTestCase {

    private var urls: [URL]!

    override func setUp() {
        if let optUrls = Bundle(for: Level.self).urls(forResourcesWithExtension: "json", subdirectory: "Levels") {
            urls = optUrls
        }

        if urls == nil {
            XCTFail("Error reading level files")
        }
    }

    // MARK: Correct ids
    func testCorrectLevelIds() {
        for url in urls {
            let levelName = url.lastPathComponent

            let id = extractLevelId(fromUrl: url)
            let expectedLevelName = "Level\(id).json"

            XCTAssertEqual(levelName, expectedLevelName)
        }
    }

    // MARK: Correct unlocks
    func testCorrectUnlockOrder() {
        var maxId = -1
        var nilUnlockId = -1

        for url in urls {
            let id = extractLevelId(fromUrl: url)
            let unlocks = extractLevelUnlocks(fromUrl: url)

            //Skip the empty level and the item level
            if id == 0 || id == 9000 {
                continue
            }

            //Ensure that only the last level does not unlock anything
            if unlocks == nil {
                if nilUnlockId != -1 {
                    XCTFail("Multiple levels detected that do not unlock anything")
                    return
                }

                nilUnlockId = id
            } else {
                //Assert that this level unlocks the one immediately after itself
                XCTAssertEqual(unlocks, id + 1)
            }

            if id > maxId {
                maxId = id
            }
        }

        //Only the last level does not unlock other levels
        XCTAssertEqual(nilUnlockId, maxId)
    }

    // MARK: Helper methods
    private func extractLevelId(fromUrl url: URL) -> Int {
        if let jsonLevel = toJsonLevel(url: url),
            let id = jsonLevel["number"] as? Int {
            return id
        }

        XCTFail("Error extracting level id")
        return -1
    }

    private func extractLevelUnlocks(fromUrl url: URL) -> Int? {
        if let jsonLevel = toJsonLevel(url: url),
            let unlockOpt = jsonLevel["unlocks"] {
            return unlockOpt as? Int
        }

        XCTFail("Error extracting unlocks id")
        return -1
    }

    private func toJsonLevel(url: URL) -> [String: Any]? {
        if let data = try? Data(contentsOf: url),
            let jsonLevel = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] {
            return jsonLevel
        }

        XCTFail("Error reading level data for url \(url)")
        return nil
    }
}
