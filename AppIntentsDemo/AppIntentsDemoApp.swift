//
//  AppIntentsDemoApp.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/1.
//

import SwiftUI

@main
struct AppIntentsDemoApp: App {
    
    @AppStorage("isFirstRun")
    var isFirstRun = false
    
    @StateObject
    var viewModel = SongViewModel.shared
    
    let context = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            SongListView()
                .environment(\.managedObjectContext, context)
                .environmentObject(viewModel)
                .onAppear {
                    if isFirstRun {
                        do {
                            try SongManager.shared.addDefaultSongs(context: context)
                            isFirstRun = false
                        } catch {
                            print("Default songs weren't added")
                        }
                    }
                }
        }
    }
}
