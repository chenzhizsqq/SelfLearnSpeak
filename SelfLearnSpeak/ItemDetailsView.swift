//
//  ItemDetailsView.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/21.
//

import SwiftUI
import RealmSwift
import AVFoundation


/// Represents a screen where you can edit the item's name.
struct ItemDetailsView: View {
    @ObservedRealmObject var item: Item
    @StateObject var transViewModel = TransViewModel()
    var body: some View {
        ScrollView{
            VStack {
                HStack{
                    Text("日文")
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding(.horizontal)
                    Button("翻译") {
                        if(!item.name.isEmpty){
                            BaiduFanyiAPI.getfanyi(from: "jp" ,to: "zh", text: item.name, type: "jp2zh", mvvm: transViewModel)
                        }else{
                            debugPrint("!!! input_text.isEmpty")
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Accept a new name
                TextEditor(text: $item.name)
                    .autocapitalization(.none)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                    .border(.gray)
                    .background(.cyan)
                    .padding()
                
                HStack{
                    Text("中文")
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding(.horizontal)
                    Button("翻译") {
                        if(!item.itemDescription.isEmpty){
                            BaiduFanyiAPI.getfanyi(from: "zh" ,to: "jp", text: item.itemDescription, type: "zh2jp", mvvm: transViewModel)
                        }else{
                            debugPrint("!!! description_text.isEmpty")
                        }
                    }
                    .padding(.horizontal)
                }
                
                
                TextEditor(text: $item.itemDescription)
                    .autocapitalization(.none)
                    .frame(height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                    .border(.gray)
                    .background(.cyan)
                    .padding()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: transViewModel.jp) { newValue in
            // 这里可以响应myValue变化时的操作
            debugPrint("transViewModel.jp")
            item.name = newValue
            debugPrint(newValue)
        }
        .onChange(of: transViewModel.zh) { newValue in
            // 这里可以响应myValue变化时的操作
            debugPrint("transViewModel.zh")
            item.itemDescription = newValue
            debugPrint(newValue)
        }
        .padding()
            .navigationBarItems(trailing: Toggle(isOn: $item.isFavorite) {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
            })
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
