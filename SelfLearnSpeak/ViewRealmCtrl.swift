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
    
    init(){
        Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }

    var body: some View {
        VStack {
            List(viewModel.tables, id: \.self) { table in
                Text(table)
            }
            List(viewModel.tablesDescription, id: \.self) { table in
                Text(table)
            }
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

    func deleteAllTables() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
