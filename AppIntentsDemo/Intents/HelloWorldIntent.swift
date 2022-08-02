//
//  HelloWorldIntent.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/1.
//

import Foundation
import AppIntents
import SwiftUI

struct HelloWorldIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Export all Hello world"
    
    static var description =
        IntentDescription("Exports your transaction history as CSV data.")
    
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "View String", optionsProvider: ViewStringOptionsProvider())
    var viewStr: String?
    
    @MainActor
    func perform() async throws -> some IntentResult {
        
        let str: String = "Hello, Rambo."
        guard let viewStr = viewStr else {
            print("Exception")
            throw $viewStr.requestValue("What date would you like to use?")
        }
        print(str, viewStr)
        return .result() {
            StringView(viewStr: viewStr)
        }
    }
    
    private struct ViewStringOptionsProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            try await ["Option A", "Option B", "Option C"]
        }
    }
    
}

