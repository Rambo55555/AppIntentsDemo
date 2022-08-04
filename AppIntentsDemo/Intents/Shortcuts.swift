//
//  Shortcuts.swift
//  AppIntentsDemo
//
//  Created by Rambo on 2022/8/4.
//

import AppIntents

// Only one struct can implement the AppShortcutProvider!!!
struct Shortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: Intent_viewStringOption(),
            phrases: [
                "\(.applicationName) view string option",
            ]
        )
        AppShortcut(
            intent: Intent_dialogAndSnippetView(),
            phrases: [
                "\(.applicationName) dialogAndSnippetView",
            ]
        )
    }
}
