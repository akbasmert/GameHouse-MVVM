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


//    func saveAudioData(_ game: Game) {
//        DispatchQueue.main.async {
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let context = appDelegate.persistentContainer.viewContext
//            let newWord = NSEntityDescription.insertNewObject(forEntityName: "GameEntity", into: context)
//            newWord.setValue(game.id, forKey: "id")
//            newWord.setValue(game.name, forKey: "name")
//            newWord.setValue(game.released, forKey: "released")
//            newWord.setValue(game.backgroundImage, forKey: "backgroundImage")
//            newWord.setValue(game.rating, forKey: "rating")
//
//            do {
//                try context.save()
//                print("kaydedildi")
//            } catch let error as NSError {
//                print("Failed to save audio data: \(error), \(error.userInfo)")
//            }
//        }
//    }
//
//
//
//    func fetchAudioData() -> [GameEntity] {
//        var gameEntities: [GameEntity] = []
//
//
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return gameEntities
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//
//        let fetchRequest: NSFetchRequest<GameEntity> = GameEntity.fetchRequest()
//
//        do {
//            gameEntities = try context.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Failed to fetch audio data: \(error), \(error.userInfo)")
//        }
//
//        return gameEntities
//    }

    func saveAudioData(_ gameid: Int64) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "FavoriGame", into: context)
        newWord.setValue(gameid, forKey: "gameid")
        do {
            try context.save()
        } catch {
            print("Kayıt başarısız")
        }
    }
    
    func fetchAudioData() -> [Int] {
        var trackIds: [Int] = []

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return trackIds }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriGame")

        do {
            let results = try context.fetch(fetchRequest)
            if let favoriAudios = results as? [NSManagedObject] {
                for favoriAudio in favoriAudios {
                    if let trackId = favoriAudio.value(forKey: "gameid") as? Int {
                        trackIds.append(trackId)
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }

        return trackIds
    }



    func deleteAudioData(withTrackId gameId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriGame")
        fetchRequest.predicate = NSPredicate(format: "gameid == %d", gameId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let favoriGames = results as? [NSManagedObject], let favoriGame = favoriGames.first {
                context.delete(favoriGame)
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }


}
