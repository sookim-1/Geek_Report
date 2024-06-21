//
//  CoreDataStorage.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStorage {

    static let shared = CoreDataStorage()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    private lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func saveData(selectEpisode: Int, item: DomainAnimeDetailDataModel) -> Bool {
        let animeData = NSEntityDescription.insertNewObject(forEntityName: "AnimeEntity", into: managedObjectContext) as! AnimeEntity

        animeData.animeID = Int64(item.animeID)
        animeData.createdAt = Date()
        animeData.episode = Int32(selectEpisode)
        animeData.title = item.title
        animeData.urlString = item.imageURLString

        do {
            try managedObjectContext.save()

            return true
        } catch {
            print("Failed to save user: \(error)")

            return false
        }
    }

    func fetchData() -> [DomainAnimeDataModel] {
        // NSFetchRequest를 사용하여 가져올 엔터티와 필터링, 정렬 또는 그룹화 옵션을 지정하는 역할
        let fetchRequest = NSFetchRequest<AnimeEntity>(entityName: "AnimeEntity")

        do {
            let animeDatas = try managedObjectContext.fetch(fetchRequest)

            return animeDatas.map {
                DomainAnimeDataModel(animeID: Int($0.animeID),
                                     title: $0.title ?? "",
                                     episodes: Int($0.episode),
                                     imageURLString: $0.urlString ?? "")
            }
        } catch {
            print("Failed to fetch users: \(error)")

            return []
        }
    }

    func updateData(selectEpisode: Int, item: DomainAnimeDetailDataModel) -> Bool {
        let fetchRequest = NSFetchRequest<AnimeEntity>(entityName: "AnimeEntity")
        fetchRequest.predicate = NSPredicate(format: "animeID == %@", NSNumber(value: item.animeID))

        do {
            let results = try managedObjectContext.fetch(fetchRequest)

            if let user = results.first {
                user.setValue(selectEpisode, forKeyPath: "episode")

                try managedObjectContext.save()

                return true
            }

            return false
        } catch let error as NSError {
            print("Could not update data. \(error), \(error.userInfo)")
            return false
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
