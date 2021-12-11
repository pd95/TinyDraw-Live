//
//  TinyDrawApp.swift
//  TinyDraw
//
//  Created by Philipp on 11.12.21.
//

import SwiftUI

@main
struct TinyDrawApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Drawing.init) { file in
            ContentView()
        }
    }
}
