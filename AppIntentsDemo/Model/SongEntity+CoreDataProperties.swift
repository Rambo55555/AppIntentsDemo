//
//  SongEntity+CoreDataProperties.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import Foundation
import CoreData

extension SongEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongEntity> {
        return NSFetchRequest<SongEntity>(entityName: "SongEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var singer: String
    @NSManaged public var album: String
    @NSManaged public var image: Data?
    @NSManaged public var publishDate: Date?
    @NSManaged public var id: UUID
    @NSManaged public var isFree: Bool

}

extension SongEntity : Identifiable {

}
