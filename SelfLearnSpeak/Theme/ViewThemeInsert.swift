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
    var body: some View {
        VStack {
            Button(action: {
                
                if(!input_text.isEmpty){
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
    }
}

//struct ViewThemeInsert_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewThemeInsert()
//    }
//}
