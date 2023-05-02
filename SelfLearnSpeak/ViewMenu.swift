//
//  ViewMenu.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/26.
//

import SwiftUI
import RealmSwift

struct ViewMenu: View {
    
    //对应环境变量
    @EnvironmentObject var envModel: EnvironmentModel
    @ObservedResults(ThemeGroup.self) var themeGroups
    
    init() {
        RealmClassUpdate(CurrentSchemaVersion: 7 )
        debugPrint(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    ///如果要追加数据库的结构时
    func RealmClassUpdate( CurrentSchemaVersion:Int){
        let config = Realm.Configuration(schemaVersion: UInt64(CurrentSchemaVersion), migrationBlock: { migration, oldSchemaVersion in
        })
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                VStack {
                    
                    Divider().padding()
                    NavigationLink(destination:
                                    ViewWordsList()) {
                        Text("ViewWordsList")
                    }
                    
                    Divider().padding()
                    NavigationLink(destination:
                                    ViewRealmCtrl()) {
                        Text("数据库查询")
                    }
                    
                    Divider().padding()
                    NavigationLink(destination:
                                    ViewTestMain()) {
                        Text("ViewTestMain")
                    }
                    
                    if let themeGroup = themeGroups.first {
                        Divider().padding()
                        ThemeView(themeGroup: themeGroup)
                    }
                }
            }
        }
    }
}

struct ViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        ViewMenu()
    }
}

struct ThemeView: View {
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
