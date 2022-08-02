//
//  SongDetailView.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import SwiftUI

struct SongDetailView: View {
    
    var song: SongEntity
    
    var body: some View {
        ScrollView {
            SongView(song: song)
        }
        .navigationTitle(song.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SongView: View {
    
    var song: SongEntity
    var smallImage: Bool = false
    
    var body: some View {
        if let imageData = song.image, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(smallImage ? 10 : 0)
                .frame(width: smallImage ? 150 : nil)
        }
        Text("\(song.name)")
            .font(.title)
            .bold()
            .padding(.top)
        Spacer()
        Text("by \(song.singer)")
            .font(.headline)
            .foregroundColor(.secondary)
            .bold()
        Spacer()
        Text("Album: \(song.album)")
            .font(.headline)
            .foregroundColor(.secondary)
            .bold()
        Spacer()
        Text("Date: \(song.publishDate!.str())")
            .font(.headline)
            .foregroundColor(.secondary)
            .bold()

    }
}
