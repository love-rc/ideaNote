//
//  ideaNoteApp.swift
//  ideaNote
//
//  Created by kwh on 2022/10/12.
//

import SwiftUI

@main
struct ideaNoteApp: App {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
