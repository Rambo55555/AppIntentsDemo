//
//  IntentsSongEntity.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/4.
//

import Foundation
import AppIntents
import CoreData

struct IntentsSongEntity: Identifiable, Hashable, Equatable, AppEntity {
  
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Song")
//    typealias DefaultQueryType = IntentsBookQuery
    static var defaultQuery: IntentsSongQuery = IntentsSongQuery()
    
    var id: UUID
    
    @Property(title: "Name")
    var name: String
    
    @Property(title: "Singer")
    var singer: String
    
    @Property(title: "Album")
    var album: String
    
    //@Property(title: "Cover Image")
    var image: IntentFile?
    
    @Property(title: "Is Free")
    var isFree: Bool
    
    @Property(title: "Date Published")
    var publishDate: Date
    
    init(id: UUID, name: String?, singer: String?, album: String?, image: Data?, isFree: Bool, publishDate: Date?) {
        
        self.id = id
        self.name = name ?? "Unknown Name"
        self.singer = singer ?? "Unknown Singer"
        self.album = album ?? "Unknown Album"
        self.isFree = isFree
        self.publishDate = publishDate ?? Date()

        if let image {
            self.image = IntentFile(data: image, filename: "\(self.name) by \(self.singer).jpg")
        }
        
    }
    
    var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(name)",
            subtitle: "\(singer)",
            image: image == nil ? .init(systemName: "music.note") : .init(data: image!.data)
        )
    }
}

extension IntentsSongEntity {
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equtable conformance
    static func ==(lhs: IntentsSongEntity, rhs: IntentsSongEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct IntentsSongQuery: EntityPropertyQuery {
    
    static var sortingOptions = SortingOptions {
        SortableBy(\IntentsSongEntity.$name)
        SortableBy(\IntentsSongEntity.$singer)
        //SortableBy(\IntentssSongEntity.$datePublished)
    }
    
    static var properties = EntityQueryProperties<IntentsSongEntity, NSPredicate> {
        Property(\IntentsSongEntity.$name) {
            EqualToComparator { NSPredicate(format: "name = %@", $0) }
            ContainsComparator { NSPredicate(format: "name CONTAINS %@", $0) }

        }
        Property(\IntentsSongEntity.$singer) {
            EqualToComparator { NSPredicate(format: "singer = %@", $0) }
            ContainsComparator { NSPredicate(format: "singer CONTAINS %@", $0) }
        }
        Property(\IntentsSongEntity.$publishDate) {
            LessThanComparator { NSPredicate(format: "pulishDate < %@", $0 as NSDate) }
            GreaterThanComparator { NSPredicate(format: "pulishDate > %@", $0 as NSDate) }
        }
    }
    
    // Find books by ID
    // For example a user may have chosen a book from a list when tapping on a parameter that accepts Books. The ID of that book is now hardcoded into the Shortcut. When the shortcut is run, the ID will be matched against the database in Booky
    func entities(for identifiers: [UUID]) async throws -> [IntentsSongEntity] {
        return identifiers.compactMap { identifier in
                if let match = try? SongManager.shared.findSong(withId: identifier) {
                    return IntentsSongEntity(
                        id: match.id,
                        name: match.name,
                        singer: match.singer,
                        album: match.album,
                        image: match.image,
                        isFree: match.isFree,
                        publishDate: match.publishDate
                    )
                } else {
                    return nil
                }
        }
    }
    
    func entities(
        matching comparators: [NSPredicate],
        mode: ComparatorMode,
        sortedBy: [Sort<IntentsSongEntity>],
        limit: Int?
    ) async throws -> [IntentsSongEntity] {
        print("Fetching songs")
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<SongEntity> = SongEntity.fetchRequest()
        let predicate = NSCompoundPredicate(type: mode == .and ? .and : .or, subpredicates: comparators)
        request.fetchLimit = limit ?? 30000
        request.predicate = predicate
//        request.sortDescriptors = sortedBy.map({
//            NSSortDescriptor(key: $0.by, ascending: $0.order == .ascending)
//        })
        let matchSongs = try context.fetch(request)
        return matchSongs.map {
            IntentsSongEntity(id: $0.id, name: $0.name, singer: $0.singer, album: $0.album, image: $0.image, isFree: $0.isFree, publishDate: $0.publishDate)
        }
    }
    
//    // Returns all Books in the Booky database. This is what populates the list when you tap on a parameter that accepts a Book
//    func suggestedEntities() async throws -> [ShortcutsBookEntity] {
//        let allBooks = BookManager.shared.getAllBooks()
//        return allBooks.map {
//            ShortcutsBookEntity(
//                id: $0.id,
//                title: $0.title,
//                author: $0.author,
//                coverImageData: $0.coverImage,
//                isRead: $0.isRead,
//                datePublished: $0.datePublished)
//        }
//    }
//
    // Find songs matching the given query.
    func entities(matching query: String) async throws -> [IntentsSongEntity] {

        // Allows the user to filter the list of songs by name or singer or album when tapping on a param that accepts a 'Song'
        let allSongs = SongManager.shared.getAllSongs()
        let matchingSongs = allSongs.filter {
            return (
                $0.name.localizedCaseInsensitiveContains(query)
                || $0.singer.localizedCaseInsensitiveContains(query)
                || $0.album.localizedCaseInsensitiveContains(query)
            )
        }

        return matchingSongs.map {
            IntentsSongEntity(id: $0.id, name: $0.name, singer: $0.singer, album: $0.album, image: $0.image, isFree: $0.isFree, publishDate: $0.publishDate)
        }
    }

    
}
