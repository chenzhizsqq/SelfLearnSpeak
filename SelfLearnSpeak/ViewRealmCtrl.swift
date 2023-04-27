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
    @State private var isPresentingSheet = false
    @State var sheetText = ""
    var realm : Realm
    //@State var res: String
    
    init(){
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        realm = try! Realm(configuration: config)

    }

    var body: some View {
        VStack {
            Button("properties 结构") {
                if let selectedTable = selectedTable {
                    let objectSchema = realm.schema.objectSchema.first(where: { $0.className == selectedTable })
                    let propertyList = objectSchema?.properties.map({ $0.name })
                    print(propertyList)
                    let combinedString = propertyList!.joined(separator: " , ")
                    print(combinedString)
                    
                    isPresentingSheet = true
                    sheetText = combinedString

                }
            }
            Button("description 属性") {
                if let selectedTable = selectedTable {
                    let objectSchema = realm.schema.objectSchema.first(where: { $0.className == selectedTable })
                    let propertyList = objectSchema?.description.map({ $0.description })
                    
                    let combinedString = propertyList!.joined(separator: "")
                    print(combinedString)
                    isPresentingSheet = true
                    sheetText = combinedString

                }
            }
            
            List(viewModel.tables, id: \.self, selection: $selectedTable) { table in
                Text(table)
            }
                //Text(res)
            
            Button("Delete All Tables") {
                viewModel.deleteAllTables()
            }
        }
        .sheet(isPresented: $isPresentingSheet, content: {
            NavigationView {
                ViewRealmCtrlSheet(input_text: $sheetText)
                    .navigationBarTitle(selectedTable!)
            }
        })
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


struct ViewRealmCtrlSheet: View {
    @Binding var input_text : String
    var body: some View {
        
        ScrollView{
            Text(input_text)
        }
    }
}
