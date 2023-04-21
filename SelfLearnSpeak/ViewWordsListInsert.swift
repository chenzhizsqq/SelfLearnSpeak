//
//  ViewWordsListInsert.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/20.
//

import SwiftUI
import RealmSwift
import AVFoundation
import Alamofire
import CryptoSwift

import Foundation
import CommonCrypto


struct ViewWordsListInsert: View {
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedRealmObject var itemGroup: ItemGroup
    @EnvironmentObject var envModel: EnvironmentModel
    @Binding var input_text : String
    @Binding var description_text: String
    @Binding var showSecondView: Bool
    @StateObject var transViewModel = TransViewModel()
    var body: some View {
        
        ScrollView{
            VStack{
                
            
                Button("添加") {
                    // The bound collection automatically
                    // handles write transactions, so we can
                    // append directly to it.
                    let item = Item()
                    item.name = input_text
                    item.itemDescription = description_text
                    $itemGroup.items.append(item)
                    input_text = ""
                    description_text = ""
                    self.showSecondView = false
                    }
                .buttonStyle(CustomButtonStyle(padding: 10))
                .padding()
                
                HStack{
                    Text("日文")
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding(.horizontal)
                    Button("翻译") {
                        if(!input_text.isEmpty){
                            BaiduFanyiAPI.getfanyi(from: "jp" ,to: "zh", text: input_text, type: "jp2zh", mvvm: transViewModel)
                        }else{
                            debugPrint("!!! input_text.isEmpty")
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                TextEditor(text: $input_text)
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
                        if(!description_text.isEmpty){
                            BaiduFanyiAPI.getfanyi(from: "zh" ,to: "jp", text: description_text, type: "zh2jp", mvvm: transViewModel)
                        }else{
                            debugPrint("!!! description_text.isEmpty")
                        }
                    }
                    .padding(.horizontal)
                }
                
                TextEditor(text: $description_text)
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
            input_text = newValue
            debugPrint(newValue)
        }
        .onChange(of: transViewModel.zh) { newValue in
            // 这里可以响应myValue变化时的操作
            debugPrint("transViewModel.zh")
            description_text = newValue
            debugPrint(newValue)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    

}


//struct ViewWordsListInsert_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWordsListInsert()
//    }
//}
