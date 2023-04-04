//
//  firstSwifUIAppApp.swift
//  firstSwifUIApp
//
//  Created by Антон Шалимов on 31.03.2023.
//

import SwiftUI

@main
struct firstSwifUIAppApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
