//
//  ViewThemeEdit.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import SwiftUI
import RealmSwift



struct ViewThemeEdit: View {
    @ObservedRealmObject var theme: Theme
    @Binding var input_text : String
    @Binding var showSecondView: Bool
    var body: some View {
        VStack {
            Button(action: {
                
                if(!input_text.isEmpty){
                    self.showSecondView = false
                }
            }) { Text("修改").padding(10) }
            
            TextField("请输入主题", text: $input_text)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
    }
}

//struct ViewThemeEdit_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewThemeEdit(theme: <#Theme#>, input_text: <#Binding<String>#>, showSecondView: <#Binding<Bool>#>)
//    }
//}
