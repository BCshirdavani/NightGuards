//
//  DataPersistenceController.swift
//  NightGuards
//
//  Created by shiMac on 12/24/20.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class DataPersistController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedHeros = [HeroEntity]()
    
    init() {
        self.loadData()
    }
    
    func stageHeroUpdates(name: String, map: String?, unlocked: Bool?) {
        loadData()
        var heroExists: Bool = false
        var oldHero: HeroEntity = HeroEntity.init(context: self.context)
        fetchedHeros.makeIterator().forEach { (entity) in
            if entity.heroName == name {
                heroExists = true
                oldHero = entity
            }
        }
        if !heroExists {
            context.delete(oldHero)
            let newHero = HeroEntity.init(context: self.context)
            newHero.heroName = name
            if let newMapName = map {
                newHero.mapName = newMapName
            }
            if let unlockedStatus = unlocked {
                newHero.unlocked = unlockedStatus
            }
        } else {
            oldHero.heroName = name
            oldHero.mapName = map
            oldHero.unlocked = unlocked ?? true
        }
        self.saveChanges()
    }
    
    func saveChanges() {
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
            printLoadedData()
            let fetchedHeroesFiltered = fetchedHeros.filter { (entity) -> Bool in
                if entity.heroName == nil {
                    context.delete(entity)
                }
                return entity.heroName != nil
            }
            fetchedHeros = fetchedHeroesFiltered
        } catch {
            print("error fetching data from context \(error)")
        }
        
    }
    
    func printLoadedData() {
        if fetchedHeros.count > 0 {
            fetchedHeros.makeIterator().forEach { (entity) in
                print(" - name: \(entity.heroName), map: \(entity.mapName), unlocked: \(entity.unlocked)")
            }
            print("------------------------------")
        }
    }

}
