//
//  CustomErrors.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import Foundation

enum Error: Swift.Error, CustomLocalizedStringResourceConvertible {
    case notFound,
         coreDataSave,
         unknownId(id: String),
         unknownError(message: String),
         deletionFailed,
         addFailed(songName: String)

    var localizedStringResource: LocalizedStringResource {
        switch self {
            case .addFailed(let title): return "An error occurred trying to add '\(title)'"
            case .deletionFailed: return "An error occured trying to delete the song"
            case .unknownError(let message): return "An unknown error occurred: \(message)"
            case .unknownId(let id): return "No songs with an ID matching: \(id)"
            case .notFound: return "Book not found"
            case .coreDataSave: return "Couldn't save to CoreData"
        }
    }
}
