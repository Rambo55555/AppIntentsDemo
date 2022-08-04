//
//  HelloWorldIntent.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/1.
//

import Foundation
import AppIntents
import SwiftUI

struct Intent_viewStringOption: AppIntent {

    static var title: LocalizedStringResource = "In-app Intent viewStringOption"

    static var description =
        IntentDescription("viewStringOption")

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

struct Intent_dialogAndSnippetView: AppIntent {

    static var title: LocalizedStringResource = "In-app Intent dialogAndSnippetView"

    static var description =
        IntentDescription("dialogAndSnippetView")

    static var openAppWhenRun: Bool = false

    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {

        return .result(
            dialog: "This is a dialog",
            view: StringView(viewStr: "This is a new view")
        )
    }

}

