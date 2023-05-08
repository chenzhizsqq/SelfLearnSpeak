//
//  ViewWordsList.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/19.
//

import SwiftUI
import RealmSwift
import Speech


/// The main content view if not using Sync.
struct ViewWordsList: View {
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedResults(ItemGroup.self) var itemGroups
    
    init() {
        debugPrint("ViewWordsList !!!")
        debugPrint(Realm.Configuration.defaultConfiguration.fileURL!)
        
        debugPrint(itemGroups)
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmURL = documentsDirectory.appendingPathComponent("default.realm")
        debugPrint("Realm file path: \(realmURL.path)")
    }
    var body: some View {
        if let itemGroup = itemGroups.first {
            // Pass the ItemGroup objects to a view further
            // down the hierarchy
            ItemsView(itemGroup: itemGroup)
        } else {
            // For this small app, we only want one itemGroup in the realm.
            // You can expand this app to support multiple itemGroups.
            // For now, if there is no itemGroup, add one here.
            ProgressView().onAppear {
                $itemGroups.append(ItemGroup())
            }
        }
    }
}

//struct ViewWordsList_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWordsList()
//    }
//}
