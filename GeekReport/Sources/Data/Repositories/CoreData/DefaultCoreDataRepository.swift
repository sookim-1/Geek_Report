//
//  DefaultCoreDataRepository.swift
//  GeekReport
//
//  Created by sookim on 5/22/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

final class DefaultCoreDataRepository: CoreDataRepository {

    let container: NSPersistentContainer

    init(){
        container = NSPersistentContainer(name: "Main")
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }

    func getAnimes() -> [DomainAnimeDataModel] {
        let request = AnimeEntities.fetchRequest()

        let returnData = try! container.viewContext.fetch(request).map({ animeCoreDataEntity in
            DomainAnimeDataModel(animeID: Int(animeCoreDataEntity.malID),
                                 title: animeCoreDataEntity.title!,
                                 episodes: Int(animeCoreDataEntity.episodes),
                                 imageURLString: animeCoreDataEntity.imageURL!)
        })

            
        return returnData
    }

    func getAnime(id: UUID) -> Observable<DomainAnimeDataModel> {
        let animeCoreDataEntity = getEntityById(id)!

        let animeData = DomainAnimeDataModel(animeID: Int(animeCoreDataEntity.malID),
                                             title: animeCoreDataEntity.title!,
                                             episodes: Int(animeCoreDataEntity.episodes),
                                             imageURLString: animeCoreDataEntity.imageURL!)

        return Observable.just(animeData)
    }

    func deleteAnime(_ id: UUID) -> Observable<Bool> {
        let animeCoreDataEntity = getEntityById(id)!
        let context = container.viewContext

        context.delete(animeCoreDataEntity)
        
        do {
            try context.save()
            return Observable.just(true)
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func createAnime(selectEpisode: Int, _ model: DomainAnimeDataModel) -> Observable<Bool> {
        let entity = NSEntityDescription.entity(forEntityName: "AnimeEntities", in: self.container.viewContext)!

        let item = NSManagedObject(entity: entity, insertInto: self.container.viewContext)

        item.setValue("\(model.title)", forKey: "title")
        item.setValue("\(model.imageURLString)", forKey: "imageURL")
        item.setValue(Int64(selectEpisode), forKey: "episodes")
        item.setValue(Int64(model.animeID), forKey: "malID")

        saveContext()

        return Observable.just(true)
    }

    func updateAnime(_ id: UUID, _ model: DomainAnimeDataModel) -> Observable<Bool> {
        let animeCoreDataEntity = getEntityById(id)!
        animeCoreDataEntity.malID = Int64(model.animeID)
        animeCoreDataEntity.episodes = Int64(model.episodes ?? 0)
        animeCoreDataEntity.imageURL = model.imageURLString
        animeCoreDataEntity.title = model.title

        saveContext()

        return Observable.just(true)
    }

    private func getEntityById(_ id: UUID) -> AnimeEntities? {
        let request = AnimeEntities.fetchRequest()

        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)

        let context =  container.viewContext
        let animeCoreDataEntity = try! context.fetch(request)[0]
        return animeCoreDataEntity

    }

    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

}
