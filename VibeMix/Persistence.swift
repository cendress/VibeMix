//
//  Persistence.swift
//  VibeMix
//
//  Created by Christopher Endress on 3/23/24.
//

import CoreData

class PersistenceController {
  static let shared = PersistenceController()
  
  let container: NSPersistentContainer
  
  init() {
    container = NSPersistentContainer(name: "VibeMix")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
  
  var viewContext: NSManagedObjectContext {
    return container.viewContext
  }
}
