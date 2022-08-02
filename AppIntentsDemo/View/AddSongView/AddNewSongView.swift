//
//  AddNewSongView.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/2.
//

import SwiftUI

import SwiftUI
import CoreData

struct AddNewSongView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var vm: SongViewModel
    
    @State private var name = ""
    @State private var singer = ""
    @State private var album = ""
    @State private var isFree = false
    @State private var publishDate = Date()
    @State private var image: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name, prompt: Text("Name"))
                TextField("Singer", text: $singer, prompt: Text("Singer"))
                TextField("Album", text: $album, prompt: Text("Album"))
                DatePicker("Published", selection: $publishDate, displayedComponents: .date)
                Toggle("isFree", isOn: $isFree)
                HStack {
                    Text("Image")
                    Spacer()
                    Button {
                        vm.showingImagePicker = true
                    } label: {
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        } else {
                            Image(systemName: "photo")
                                .foregroundColor(.secondary)
                        }
                    }

                }
            }
            .textInputAutocapitalization(.words)
            .sheet(isPresented: $vm.showingImagePicker) {
                ImagePicker(image: $image)
            }
            .navigationTitle("New Song")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel, action: {
                        dismiss()
                    }, label: {
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.red)
                    })
                }
                ToolbarItem {
                    Button(action: {
                        do {
                            _ = try SongManager.shared.addSong(name: name, singer: singer, album: album, publishDate: publishDate, image: image, isFree: isFree)
                            dismiss()
                        } catch let error {
                            print("Couldn't add book: \(error.localizedDescription)")
                        }
                    }, label: {
                        Text("Save")
                            .bold()
                    })
                    .disabled(name == "" || singer == "" || album == "")
                }
            }
        }
    }
}

struct AddNewSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewSongView()
    }
}
