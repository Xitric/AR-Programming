//
//  LevelManager.swift
//  AR Programming
//
//  Created by Kasper Schultz Davidsen on 08/11/2018.
//  Copyright © 2018 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LevelManager: LevelRepository {

    private let context: CoreDataRepository
    private let levelFactories: [LevelFactory]

    private var levelDirectoryUrl: URL? {
        return Bundle(for: type(of: self)).resourceURL?.appendingPathComponent("Levels", isDirectory: true)
    }

    init(context: CoreDataRepository, factories: [LevelFactory]) {
        self.context = context
        self.levelFactories = factories
    }

    // MARK: - Load levels
    func loadEmptyLevel(completion: @escaping (LevelProtocol) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            //This should absolutely never fail
            let level = try! self.loadLevelSync(withNumber: 0)
            completion(level)
        }
    }

    func loadItemLevel(completion: @escaping (LevelProtocol) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            //This should absolutely never fail
            let level = try! self.loadLevelSync(withNumber: 9000)
            completion(level)
        }
    }

    func loadLevel(withNumber id: Int, completion:  @escaping (LevelProtocol?, LevelLoadingError?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                let level = try self.loadLevelSync(withNumber: id)
                completion(level, nil)
            } catch let error as LevelLoadingError {
                completion(nil, error)
            } catch {
                completion(nil, LevelLoadingError.noSuchLevel(levelNumber: id))
            }
        }
    }

    private func loadLevelSync(withNumber id: Int) throws -> LevelProtocol {
        guard let levelDirectoryUrl = levelDirectoryUrl
            else { throw LevelLoadingError.noSuchLevel(levelNumber: id) }

        let url = levelDirectoryUrl.appendingPathComponent("Level\(id).json")
        do {
            let jsonData = try Data(contentsOf: url)
            return try loadLevel(fromData: jsonData)
        } catch let error as LevelLoadingError {
            throw error
        } catch {
            throw LevelLoadingError.noSuchLevel(levelNumber: id)
        }
    }

    private func loadLevel(fromData data: Data) throws -> Level {
        //Figure out the level type so that we can use the correct LevelFactory
        guard let jsonLevelUntyped = try? JSONSerialization.jsonObject(with: data, options: []),
            let jsonLevel = jsonLevelUntyped as? [String: Any],
            let levelType = jsonLevel["type"] as? String else {
                throw LevelLoadingError.badFormat()
        }

        for factory in levelFactories {
            if factory.canReadLevel(ofType: levelType) {
                do {
                    let level = try factory.initLevel(json: data)
                    level.unlocked = isLevelUnlocked(withNumber: level.levelNumber)
                    level.levelRepository = self
                    return level
                } catch {
                    throw LevelLoadingError.badFormat()
                }
            }
        }

        throw LevelLoadingError.unsupportedLevelType(type: levelType)
    }

    // MARK: - Load previews
    func loadPreviews(forLevels levelIds: [Int], completion: @escaping ([LevelInfoProtocol]?, LevelLoadingError?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                let levelPreviews = try self.loadPreviewsSync(forLevels: levelIds)
                completion(levelPreviews, nil)
            } catch {
                completion(nil, LevelLoadingError.badFormat())
            }
        }
    }

    private func loadPreviewsSync(forLevels levelIds: [Int]) throws -> [LevelInfoProtocol] {
        var levelPreviews = [LevelInfo]()

        guard let levelDirectoryUrl = levelDirectoryUrl
            else { return levelPreviews }

        for id in levelIds {
            let url = levelDirectoryUrl.appendingPathComponent("Level\(id).json")
            let jsonData = try Data(contentsOf: url)
            var levelInfo = try JSONDecoder().decode(LevelInfo.self, from: jsonData)
            levelInfo.unlocked = isLevelUnlocked(withNumber: levelInfo.levelNumber)

            levelPreviews.append(levelInfo)
        }

        levelPreviews.sort { a, b in
            return a.levelNumber < b.levelNumber
        }

        markLevel(withNumber: levelPreviews[0].levelNumber, asUnlocked: true, completion: nil)
        levelPreviews[0].unlocked = true

        return levelPreviews
    }

    // MARK: - Locked/unlocked state
    private func isLevelUnlocked(withNumber levelNumber: Int) -> Bool {
        let managedObjectContext = context.persistentContainer.viewContext
        let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
        request.predicate = NSPredicate(format: "level = %d", levelNumber)

        if let result = try? managedObjectContext.fetch(request) {
            if result.count != 0 {
                return result[0].unlocked
            }
        }
        return false
    }

    func markLevel(withNumber id: Int, asUnlocked unlocked: Bool, completion: (() -> Void)?) {
        let managedObjectContext = context.persistentContainer.viewContext

        managedObjectContext.perform {
            let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
            request.predicate = NSPredicate(format: "level = %d", id)
            if let result = try? managedObjectContext.fetch(request) {
                if result.count == 0 {
                    let entity = NSEntityDescription.entity(forEntityName: "LevelEntity", in: managedObjectContext)
                    let levelEntity = LevelEntity(entity: entity!, insertInto: managedObjectContext)
                    levelEntity.setValue(id, forKey: "level")
                    levelEntity.setValue(unlocked, forKey: "unlocked")
                } else {
                    result[0].setValue(unlocked, forKey: "unlocked")
                }
                self.context.saveContext()
                completion?()
            }
        }
    }
}
