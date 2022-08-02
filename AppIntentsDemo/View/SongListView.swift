//
//  SongListView.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import SwiftUI
import CoreData

struct SongListView: View {
    
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var vm: SongViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SongEntity.name, ascending: true)],
        animation: .default)
    private var songs: FetchedResults<SongEntity>
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            List {
                if songs.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            try? SongManager.shared.addDefaultSongs(context: context)
                        } label: {
                            Text("Add Default Songs")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        Spacer()
                    }
                } else {
                    ForEach(songs) { song in
                        NavigationLink(value: song, label: {
                            SongListRowView(song: song)
                        })
                    }
                    .onDelete(perform: deleteSongs)
                }
            }
            .navigationDestination(for: SongEntity.self) { song in
                SongDetailView(song: song)
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem {
                    Button {
                        vm.showingAddSong = true
                    } label: {
                        Label("Add Song", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $vm.showingAddSong) {
                AddNewSongView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(vm)
            }
        }
    }
    
    private func deleteSongs(offsets: IndexSet) {
        withAnimation {
            offsets.map { songs[$0] }.forEach(context.delete)
            do {
                try context.save()
            } catch let error {
                print("Couldn't delete book: \(error.localizedDescription)")
            }
        }
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
