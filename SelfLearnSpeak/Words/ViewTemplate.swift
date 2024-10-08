//
//  ViewTemplate.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/25.
//

import SwiftUI
import RealmSwift
import Speech

struct ViewTemplate: View {
    @EnvironmentObject var envModel: EnvironmentModel
    @Binding var isFavorite: Bool
    @Binding var showSecondView: Bool
    @Binding var input_text : String
    @Binding var description_text: String
    @StateObject var transViewModel = TransViewModel()
    
    @State var text: String = ""
    var body: some View {
        ScrollView {
            
            HStack{
                HStack{
                    Toggle(isOn: $isFavorite) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                    }
                }.frame(width: 50)
                Text("日文")
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding(.horizontal)
                Button("翻译") {
                    if(!input_text.isEmpty){
                        BaiduFanyiAPI.getfanyi(from: "jp" ,to: "zh", text: input_text, type: "jp2zh", mvvm: transViewModel)
                        hideKeyboard()
                    }else{
                        debugPrint("!!! input_text.isEmpty")
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    envModel.text2speech(input_text,language: AppEnvironment.dataArray["ja-JP"]?.VoiceLanguag)
                }) { Image(systemName: "speaker.wave.3") }
                    .buttonStyle(CustomButtonStyle(padding: 5))
            }.frame(height: 50)
            
            // Accept a new name
            TextEditor(text: $input_text)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
            
            HStack{
                TextField("练习发音", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                Button("清除") {
                    text = ""
                }
            }
            
            HStack{
                Text("中文")
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding(.horizontal)
                Button("翻译") {
                    if(!description_text.isEmpty){
                        BaiduFanyiAPI.getfanyi(from: "zh" ,to: "jp", text: description_text, type: "zh2jp", mvvm: transViewModel)
                        hideKeyboard()
                    }else{
                        debugPrint("!!! description_text.isEmpty")
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    envModel.text2speech(description_text,language: AppEnvironment.dataArray["zh-CN"]?.VoiceLanguag)
                }) { Image(systemName: "speaker.wave.3") }
                    .buttonStyle(CustomButtonStyle(padding: 5))
            }
            
            
            TextEditor(text: $description_text)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
        }.padding(10)
//        .onTapGesture {
//            hideKeyboard()
//        }
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

//struct ViewTemplate_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewTemplate()
//    }
//}
