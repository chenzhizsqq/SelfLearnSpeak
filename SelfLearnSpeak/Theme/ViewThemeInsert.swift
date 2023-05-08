//
//  ViewThemeInsert.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import SwiftUI
import RealmSwift


struct ViewThemeInsert: View {
    
    @ObservedRealmObject var themeGroup: ThemeGroup
    @State var input_text : String
    @Binding var showSecondView: Bool
    @State private var showAlert = false
    var body: some View {
        VStack {
            Button(action: {
                let realm = try! Realm()
                let input = realm.objects(Theme.self).filter("name == %@", input_text).first
                
                if let input = input {
                    print("\(input.name) is \(input.isFavorite) isFavorite.")
                    showAlert = true
                } else {
                    print("data \(input) not found.")
                    let theme = Theme()
                    theme.name = input_text
                    $themeGroup.themes.append(theme)
                    self.showSecondView = false
                }
            }) { Text("添加").padding(10) }
            
            TextField("请输入主题", text: $input_text)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("提示"), message: Text("数据中已经有了"), dismissButton: .default(Text("OK")))
        }
    }
}

//struct ViewThemeInsert_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewThemeInsert()
//    }
//}
