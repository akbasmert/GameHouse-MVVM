//
//  CoreDataManager.swift
//  GameHouse
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import CoreData
import UIKit
import GameHouseAPI

class CoreDataManager {
    static let shared = CoreDataManager()


    func saveAudioData(_ game: Game) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let newWord = NSEntityDescription.insertNewObject(forEntityName: "GameEntity", into: context)
            newWord.setValue(game.id, forKey: "id")
            newWord.setValue(game.name, forKey: "name")
            newWord.setValue(game.released, forKey: "released")
            newWord.setValue(game.backgroundImage, forKey: "backgroundImage")
            newWord.setValue(game.rating, forKey: "rating")

            do {
                try context.save()
                print("kaydedildi")
            } catch let error as NSError {
                print("Failed to save audio data: \(error), \(error.userInfo)")
            }
        }
    }



    func fetchAudioData() -> [GameEntity] {
        var gameEntities: [GameEntity] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return gameEntities
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
        
        do {
            gameEntities = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Failed to fetch audio data: \(error), \(error.userInfo)")
        }
        
        return gameEntities
    }


//    func deleteAudioData() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = GameEntity.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try managedContext.execute(deleteRequest)
//        } catch let error as NSError {
//            print("Failed to delete audio data: \(error), \(error.userInfo)")
//        }
//    }
}
