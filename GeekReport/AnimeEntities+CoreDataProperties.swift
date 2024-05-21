//
//  AnimeEntities+CoreDataProperties.swift
//  GeekReport
//
//  Created by sookim on 5/7/24.
//
//

import Foundation
import CoreData


extension AnimeEntities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnimeEntities> {
        return NSFetchRequest<AnimeEntities>(entityName: "AnimeEntities")
    }

    @NSManaged public var episodes: Int64
    @NSManaged public var malID: Int64
    @NSManaged public var title: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var id: UUID?

}

extension AnimeEntities : Identifiable {

}
