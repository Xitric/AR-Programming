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
    
    private var minCardsForMaxScore = [Int:Int]()
    
    init(context: CoreDataRepository) {
        self.context = context
        minCardsForMaxScore[1] = 2
        minCardsForMaxScore[2] = 3
        minCardsForMaxScore[3] = 4
        minCardsForMaxScore[4] = 5
        minCardsForMaxScore[5] = 6
        minCardsForMaxScore[6] = 7
        minCardsForMaxScore[7] = 8
        minCardsForMaxScore[8] = 9
    }
    
    public func incrementCardCount(){
        cardsUsed += 1
    }
    
    public func resetScore(){
        cardsUsed = 0
    }
    
    public func computeScore(level: Int){
        print("card used \(cardsUsed)")
        var score = 1
        if let minCardsInLevel = minCardsForMaxScore[level] {
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
                        result[0].setValue(score, forKey: "levelNumber")
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

