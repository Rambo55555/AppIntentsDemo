//
//  SongManager.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import Foundation
import CoreData
import UIKit

class SongManager {
    static let shared = SongManager()
    
    let context = PersistenceController.shared.container.viewContext
    
    func saveContext() throws {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error {
            print("Couldn't save CoreData context: \(error.localizedDescription)")
            throw Error.coreDataSave
        }
    }
    
    func getAllSongs() -> [SongEntity] {
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        do {
            return try context.fetch(request).sorted(by: { $0.name < $1.name })
        } catch let error {
            print("Couldn't fetch all songs: \(error.localizedDescription)")
            return []
        }
    }
    
    func addSong(name: String, singer: String, album: String, publishDate: Date, image: UIImage?, isFree: Bool = false) throws -> SongEntity {

        let newSong = SongEntity(context: context)
        newSong.id = UUID()
        newSong.name = name
        newSong.singer = singer
        newSong.album = album
        newSong.publishDate = publishDate
        newSong.image = image?.jpegData(compressionQuality: 1)
        newSong.isFree = isFree

        do {
            try saveContext()
            return newSong
        } catch {
            throw Error.addFailed(songName: name)
        }
    }

    func findSong(withId id: UUID) throws -> SongEntity {
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)

        do {
            guard let foundSong = try context.fetch(request).first else {
                throw Error.notFound
            }
            return foundSong
        } catch {
            throw Error.notFound
        }
    }
    
    func deleteSong(withId id: UUID) throws {
        do {
            let matchingSong = try Self.shared.findSong(withId: id)
            context.delete(matchingSong)
            try saveContext()
        } catch let error {
            print("Couldn't delete song with ID: \(id.uuidString): \(error.localizedDescription)")
            throw Error.deletionFailed
        }
    }


    // Mark a song as free or notfree
    func markSong(withId id: UUID, as status: Bool) throws {
        do {
            let matchingSong = try Self.shared.findSong(withId: id)
            matchingSong.isFree = status
            try saveContext()
        } catch let error {
            throw error
        }
    }


}

extension SongManager {
    func addDefaultSongs(context: NSManagedObjectContext) throws {
        
        let cal = Calendar.current
        
        let song1 = SongEntity(context: context)
        song1.id = UUID()
        song1.name = "七里香"
        song1.singer = "周杰伦"
        song1.album = "七里香"
        song1.publishDate = DateComponents(calendar: cal, year: 2004, month: 08, day: 3).date
        song1.isFree = true
        song1.image = UIImage(named: "七里香")?.jpegData(compressionQuality: 1)
        
        let song2 = SongEntity(context: context)
        song2.id = UUID()
        song2.name = "Mojito"
        song2.singer = "周杰伦"
        song2.album = "最伟大的作品"
        song2.publishDate = DateComponents(calendar: cal, year: 2022, month: 06, day: 12).date
        song2.isFree = true
        song2.image = UIImage(named: "Mojito")?.jpegData(compressionQuality: 1)
        
        let song3 = SongEntity(context: context)
        song3.id = UUID()
        song3.name = "一路向北"
        song3.singer = "周杰伦"
        song3.album = "十一月的肖邦"
        song3.publishDate = DateComponents(calendar: cal, year: 2005, month: 06, day: 24).date
        song3.isFree = true
        song3.image = UIImage(named: "一路向北")?.jpegData(compressionQuality: 1)
        
        do {
            try saveContext()
        } catch let error {
            print("Couldn't add deault songs: \(error.localizedDescription)")
            throw error
        }
    }
}
