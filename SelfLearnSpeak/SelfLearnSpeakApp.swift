//
//  SelfLearnSpeakApp.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/19.
//

import SwiftUI

@main
struct SelfLearnSpeakApp: App {
    
    //环境变量
    @StateObject var envModel = EnvironmentModel.shared
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            ViewWordsList()
                .environmentObject(envModel)
        }
    }
}
