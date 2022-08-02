//
//  StringView.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/1.
//

import SwiftUI

struct StringView: View {
    
    var viewStr: String?
    
    init(viewStr: String) {
        self.viewStr = viewStr
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(viewStr!)
        }
    }
}

struct StringView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
