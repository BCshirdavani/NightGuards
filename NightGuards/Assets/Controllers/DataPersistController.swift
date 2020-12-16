//
//  DataPersistController.swift
//  NightGuards
//
//  Created by shiMac on 12/15/20.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

// TODO: find how to stop saving duplicate entries for the same hero in CoreData rows
class DataPersistController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedHeros = [HeroEntity]()
    
    // TODO: remove redundant collection, set or dict...
    var stagedUpdateDict = [String: HeroEntity]()
    var stagedUpdateSet = Set<HeroEntity>()
    
    init() {
        self.loadData()
        print(" - loaded CoreData, entity count:\t\(fetchedHeros.count)")
        print(" - first entry:\n\(fetchedHeros[0].debugDescription)")
        print(" - first name:\n\(fetchedHeros[0].heroName)")
    }
    
    func stageHeroUpdates(name: String, id: UUID, map: String?, unlocked: Bool?) {
        let newHero = HeroEntity(context: self.context)
        newHero.heroName = name
        if let newMapName = map {
            newHero.mapName = newMapName
        }
        if let unlockedStatus = unlocked {
            newHero.unlocked = unlockedStatus
        }
        stagedUpdateDict[name] = newHero
        stagedUpdateSet.insert(newHero)
        
        self.saveChanges()
    }
    
    func saveChanges() {
        print(" - calling saveChanges()")
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<HeroEntity> = HeroEntity.fetchRequest()
        do {
            fetchedHeros = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        
    }

}
