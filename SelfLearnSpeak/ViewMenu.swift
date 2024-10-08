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
    
    //各种主题的数据
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
    
    ///是否显示第二个页面
    @State private var showSecondView = false
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                VStack {
                    
                    Divider().padding()
                    NavigationLink(destination:
                                    ViewWordsList()) {
                        Text("全部")
                    }
                    
                    if let themeGroup = themeGroups.first {
                        ViewTheme(themeGroup: themeGroup).frame(height: 400)
                    }
                    
                    Divider().padding()
                    NavigationLink(destination:
                                    ViewRealmCtrl()) {
                        Text("数据库查询")
                    }
                    
                    if let themeGroup = themeGroups.first {
                        Divider().padding()
                        NavigationLink(destination:
                                        ViewTestMain(themeGroup: themeGroup)) {
                            Text("ViewTestMain")
                        }
                    }
                    Divider().padding()
                    Button("添加主题", action: {
                        showSecondView = true
                    })
                }
            }
        }
        .sheet(isPresented: $showSecondView){
            if let themeGroup = themeGroups.first {
                ViewThemeInsert(themeGroup: themeGroup, input_text: "", showSecondView: $showSecondView)
            }
        }
    }
}

struct ViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        ViewMenu()
    }
}

