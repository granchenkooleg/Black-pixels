//
//  TCApp.swift
//  TC
//
//  Created by Oleg Granchenko on 22.04.2021.
//

import SwiftUI

@main
struct TCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ImageInfoViewModel())
        }
    }
}
