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
    @State private var showAllDeleteAlert = false
    @State var sheetText = ""
    var realm : Realm
    //@State var res: String
    
    init(){
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        realm = try! Realm(configuration: config)

    }
    
    @ObservedResults(ItemGroup.self) var itemGroupData
    @ObservedResults(Item.self) var itemData
    
    var body: some View {
        VStack {
            Group{
                Divider().padding()
                Button("properties 结构 \n选择后，点击查看") {
                    if let selectedTable = selectedTable {
                        let objectSchema = realm.schema.objectSchema.first(where: { $0.className == selectedTable })
                        let propertyList = objectSchema?.properties.map({ $0.name })
                        debugPrint("\(String(describing: propertyList))")
                        let combinedString = propertyList!.joined(separator: " , ")
                        debugPrint(combinedString)
                        
                        isPresentingSheet = true
                        sheetText = combinedString
                        
                    }
                }
                Divider().padding()
                Button("description 属性 \n选择后，点击查看") {
                    if let selectedTable = selectedTable {
                        let objectSchema = realm.schema.objectSchema.first(where: { $0.className == selectedTable })
                        let propertyList = objectSchema?.description.map({ $0.description })
                        
                        let combinedString = propertyList!.joined(separator: "")
                        debugPrint(combinedString)
                        isPresentingSheet = true
                        sheetText = combinedString
                        
                    }
                }
                Divider().padding()
                Button("table的数据 \n选择后，点击查看") {
                    if let selectedTable = selectedTable {
                        switch selectedTable {
                        case "Item":
                            sheetText = observedResultsToString(itemData)
                        case "ItemGroup":
                            sheetText = observedResultsToString(itemGroupData)
                        default:
                            sheetText = ""
                        }
                        isPresentingSheet = true
                        
                    }
                }
                List(viewModel.tables, id: \.self, selection: $selectedTable) { table in
                    Text(table)
                }
            }
            
            
            Group{
                Button("log") {
                    //添加条件
                    let people = realm.objects(Item.self).filter("isFavorite == true")
                    debugPrint(people)
                    
                    debugPrint("viewModel.realm.configuration.inMemoryIdentifier")
                    debugPrint(String(describing: viewModel.realm.configuration.inMemoryIdentifier))
                    
                    debugPrint("itemData")
                    debugPrint(itemData)
                    
                    debugPrint("itemGroupData")
                    debugPrint(itemGroupData)
                }.padding()
                
                
                Button("Delete All Tables") {
                    showAllDeleteAlert.toggle()
                }.padding()
                Button("自我紹介的默认数据") {
                    viewModel.defaultTables()
                }.padding()
            }
            
        }
        .alert(isPresented: $showAllDeleteAlert) {
            Alert(title: Text("删除所有数据"),
                  message: Text("确认删除所有数据吗?"),
                  primaryButton: .destructive(Text("删除")) {
                        viewModel.deleteAllTables()
                  },
                  secondaryButton: .cancel(Text("取消")))
        }
        .sheet(isPresented: $isPresentingSheet, content: {
            NavigationView {
                ViewRealmCtrlSheet(input_text: $sheetText)
                    .navigationBarTitle(selectedTable!)
            }
        })
    }
    
    func deleteTable(tableType: Object.Type) {
        do {
            let realm = try! Realm()
            let tableToDelete = realm.objects(tableType)
            try realm.write {
                realm.delete(tableToDelete)
            }
        } catch let error as NSError {
            debugPrint("Error deleting table: \(error.localizedDescription)")
        }
    }
    
    
    func observedResultsToString<T: Object>(_ results: Results<T>) -> String {
        var resultString = ""
        results.forEach { result in
            resultString += result.description
        }
        return resultString
        
    }
}

class ViewModel: ObservableObject {
    let realm = try! Realm()
    var tables: [String] {
        return realm.schema.objectSchema.map { $0.className }
    }
    var tablesDescription: [String] {
        return realm.schema.objectSchema.map { $0.description }
    }
    
    func deleteAllTables() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func defaultTables() {
        try! realm.write {
            realm.deleteAll()
            
            let itemGroup = ItemGroup(value: ["ownerId": "previewRealm"])
            itemGroup.items.append(objectsIn: Item.IntroduceMyselfArray)
            realm.add(itemGroup)
            
            let themeTemp = ThemeGroup(value: ["ownerId": "previewRealm"])
            themeTemp.themes.append(objectsIn: [Theme.theme1])
            realm.add(themeTemp)
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
