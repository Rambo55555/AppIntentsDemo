//
//  SongViewModel.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import Foundation

class SongViewModel: ObservableObject  {
    
    static let shared = SongViewModel()
    
    @Published var path: [SongEntity] = []
    @Published var showingAddSong = false
    @Published var showingImagePicker = false
    @Published var showingDeleteAllConfirmation = false
    
    // Opens a specific Book detail view
    func navigateTo(song: SongEntity) {
        path = [song]
    }
    
    // Clears the navigation stack and returns home
    func navigateToLibrary() {
        path = []
    }
}
