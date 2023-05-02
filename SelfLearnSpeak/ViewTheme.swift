//
//  ViewTheme.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/02.
//

import SwiftUI
import RealmSwift

struct ViewTheme: View {
    @ObservedRealmObject var themeGroup: ThemeGroup
    
    var body: some View {
        NavigationView {
            VStack {
                
                // The list shows the items in the realm.
                List {
                    ForEach(themeGroup.themes) { theme in
                        ThemeRow(theme: theme)
                    }.onDelete(perform: $themeGroup.themes.remove)
                        .onMove(perform: $themeGroup.themes.move)
                }
            }
        }
    }
}

//struct ViewTheme_Previews: PreviewProvider {
//
//    //各种主题的数据
//    @ObservedResults(ThemeGroup.self) var themeGroups
//
//    static var previews: some View {
//        if let themeGroup = themeGroups.first {
//            ViewTheme(themeGroup: themeGroup)
//        }
//    }
//}
