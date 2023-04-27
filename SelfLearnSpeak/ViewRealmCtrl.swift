//
//  ViewRealmCtrl.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/27.
//

import SwiftUI
import RealmSwift

//struct ViewRealmCtrl: View {

struct ViewRealmCtrl: View {
    @StateObject var viewModel = ViewModel()
    @State var selectedTable: String?
    //@State var res: String
    
    init(){
        Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }

    var body: some View {
        VStack {
            List(viewModel.tables, id: \.self, selection: $selectedTable) { table in
                Text(table)
            }
            Button("结构") {
                if let selectedTable = selectedTable {
                    let realm = try! Realm()
                    let objectSchema = realm.schema.objectSchema.first(where: { $0.className == selectedTable })
                    let propertyList = objectSchema?.properties.map({ $0.name })
                    print(propertyList)
                    if let propertyList = propertyList as? [String] {
                        // `res` is now of type `[String]`
                        // Do something with `res` here...
                        //res = propertyList.joined(separator: ", ")
                    }

                }
            }
            Button("内容") {
                if let selectedTable = selectedTable {
                    let realm = try! Realm()
                    let objectSchema = realm.schema.objectSchema.first(where: { $0.className == selectedTable })
                    let propertyList = objectSchema?.description.map({ $0.description })
                    
                    let combinedString = propertyList!.joined(separator: "")
                    print(combinedString)

                }
            }
            List(viewModel.tablesDescription, id: \.self) { table in
                Text(table)
            }
            
                //Text(res)
            
            Button("Delete All Tables") {
                viewModel.deleteAllTables()
            }
        }
    }
}

class ViewModel: ObservableObject {
    private let realm = try! Realm()
    var tables: [String] {
        return realm.schema.objectSchema.map { $0.className }
    }
    var tablesDescription: [String] {
        return realm.schema.objectSchema.map { $0.description }
    }
    
    func printTableData(_ tableName: String) {
        guard let table = realm.objects(Object.self).filter("className = '\(tableName)'").first?.description else {
            return
        }
        print(table)
    }

    func deleteAllTables() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
