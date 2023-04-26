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
    
    init() {
        RealmClassUpdate(className: "tableRealm",CurrentSchemaVersion: 2 )
        RealmClassUpdate(className: "previewRealm",CurrentSchemaVersion: 2 )
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    ///如果要追加数据库的结构时
    func RealmClassUpdate(className: String , CurrentSchemaVersion:Int){
        
        let config = Realm.Configuration(schemaVersion: UInt64(CurrentSchemaVersion), migrationBlock: { migration, oldSchemaVersion in
        })
        
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView{
                VStack {
                        
                    NavigationLink(destination:
                                    ViewWordsList()) {
                        Text("ViewWordsList")
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
