//
//  SongRowView.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import SwiftUI
import CoreData

struct SongListRowView: View {
    
    @ObservedObject var song: SongEntity
    
    var body: some View {
        HStack {
            Group {
                if let data = song.image, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 64, height: 64)
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.teal
                        .frame(width: 64, height: 64)
                        .overlay {
                            Image(systemName: "photo.artframe")
                                .foregroundColor(.white)
                        }
                }
            }
            .cornerRadius(4)
            .padding(5)
            VStack(alignment: .leading) {
                Text(song.name)
                    .bold()
                Text(song.singer)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            .lineLimit(1)
            Spacer()
            if !song.isFree {
                Image(systemName: "dollarsign")
                    .foregroundColor(.yellow)
            }
        }
        .contextMenu {
            Button {
                try? SongManager.shared.markSong(withId: song.id, as: song.isFree ? false : true)
            } label: {
                song.isFree ? Label("Mark as not free", systemImage: "x.circle") : Label("Mark as free", systemImage: "checkmark.circle")
            }
        }
    }
}
