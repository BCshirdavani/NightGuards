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

class DataPersistController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedHeros = [HeroEntity]()
    
    var stagedUpdateDict = [String: HeroEntity]()
    var stagedUpdateSet = Set<HeroEntity>()
    
    init() {
        self.loadData()
        print(" - loaded CoreData, entity count:\t\(fetchedHeros.count)")
        printLoadedData()
    }
    
    func stageHeroUpdates(name: String, map: String?, unlocked: Bool?) {
        loadData()
        print(fetchedHeros)
        var heroExists: Bool = false
        var oldHero: HeroEntity = HeroEntity()
        fetchedHeros.makeIterator().forEach { (entity) in
            if entity.heroName == name {
                heroExists = true
                oldHero = entity
            }
        }
        if !heroExists {
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
        } else {
            oldHero.heroName = name
            oldHero.mapName = map
            oldHero.unlocked = unlocked ?? true
        }
        self.saveChanges()
    }
    
    func saveChanges() {
        print(" - calling saveChanges()")
        printLoadedData()
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
    }
    
    func loadData() {
        print(" - calling loadData()")
        let request: NSFetchRequest<HeroEntity> = HeroEntity.fetchRequest()
        do {
            fetchedHeros = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        
    }
    
    func printLoadedData() {
        if fetchedHeros.count > 0 {
            fetchedHeros.makeIterator().forEach { (entity) in
                print(" - name: \(entity.heroName), map: \(entity.mapName), unlocked: \(entity.unlocked)")
            }
        }
    }

}
