//
//  Score.swift
//  ARProgramming
//  
//  Created by Emil Nielsen on 11/04/2019.
//  Copyright © 2019 Emil Nielsen and Kasper Schultz Davidsen. All rights reserved.
//

import Foundation
import CoreData
class ScoreManager: ScoreProtocol{
    
    private var cardsUsed = 0
    private let context: CoreDataRepository
    
    private var minCardsForMaxScoreInLevel = [Int:Int]()
    
    init(context: CoreDataRepository) {
        self.context = context
        loadScoreConfigurations()
    }
    
    private func loadScoreConfigurations(){
        let data = Config.read(configFile: "CardsForMaxScore", toType: CardsForMaxScore.self)!
        minCardsForMaxScoreInLevel = data.cardsForMaxScore
    }
    
    public func incrementCardCount(){
        cardsUsed += 1
    }
    
    public func resetScore(){
        cardsUsed = 0
    }
    
    public func computeScore(level: Int){
        var score = 1
        if let minCardsInLevel = minCardsForMaxScoreInLevel[level] {
            if cardsUsed <= minCardsInLevel {
                score = 3
            } else if cardsUsed <= minCardsInLevel*2 {
                score = 2
            }
        }
        save(score: score, forLevel: level)
    }
    
    public func getScore(forLevel: Int) -> Int {
        let managedObjectContext = context.persistentContainer.viewContext
        let request = NSFetchRequest<ScoreEntity>(entityName: "ScoreEntity")
        request.predicate = NSPredicate(format: "levelNumber = %d", forLevel)
        
        if let result = try? managedObjectContext.fetch(request){
            if result.count != 0 {
                return Int(result[0].score)
            }
        }
        return 0
    }
    
    private func save(score: Int, forLevel: Int){
        if getScore(forLevel: forLevel) < score {
            let managedObjectContext = context.persistentContainer.viewContext
            managedObjectContext.perform {
                let request = NSFetchRequest<ScoreEntity>(entityName: "ScoreEntity")
                request.predicate = NSPredicate(format: "levelNumber = %d", forLevel)
                if let result = try? managedObjectContext.fetch(request) {
                    if result.count == 0 {
                        let scoreEntity = NSEntityDescription.entity(forEntityName: "ScoreEntity", in: managedObjectContext)
                        let newScoreEntity = ScoreEntity(entity: scoreEntity!, insertInto: managedObjectContext)
                        newScoreEntity.setValue(forLevel, forKey: "levelNumber")
                        newScoreEntity.setValue(score, forKey: "score")
                    } else {
                        result[0].setValue(score, forKey: "score")
                    }
                    self.context.saveContext()
                }
            }
        }
    }
    
}

protocol ScoreProtocol {
    func incrementCardCount()
    func resetScore()
    func computeScore(level: Int)
    func getScore(forLevel: Int) -> Int
}

struct CardsForMaxScore: Decodable {
    let cardsForMaxScore: [Int:Int]
}
