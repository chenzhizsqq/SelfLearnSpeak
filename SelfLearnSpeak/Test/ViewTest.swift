//
//  ViewTest.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/01.
//

import SwiftUI
import Speech

import RealmSwift
//struct ViewTest: View {
//    let synthesizer = AVSpeechSynthesizer()
//    @Binding var inputText: String
//    var body: some View {
//
//            Button(inputText) {
//                //添加条件
//                //speak(text: "test")
//                speak(text: inputText, language: "ja-JP")
//            }.padding()
//    }
//
//    func speak(text: String) {
//        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
//        synthesizer.speak(utterance)
//    }
//
//    func speak(text: String, language: String) {
//        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: language)
//        synthesizer.speak(utterance)
//    }
//}

struct ViewTest: View {
    
    @State var text = ""
    @FocusState var focus:Bool
    
    @State private var selectedOptionIndex = 0
    
    @ObservedRealmObject var themeGroup: ThemeGroup
    var themeGroupOptions: [String] {
        themeGroup.themes.map{ $0.name }
    }
    
    var body: some View {
        VStack {
            
            Form {
                TextEditor(text: self.$text)
                    .focused(self.$focus)
                    .toolbar{
                        ToolbarItem(placement: .keyboard){
                            HStack{
                                Spacer()
                                Button("Close"){
                                    self.focus = false
                                }
                            }
                        }
                    }
            }
            
            Picker("Options", selection: $selectedOptionIndex) {
                ForEach(0..<themeGroupOptions.count) { index in
                    Text(themeGroupOptions[index]).tag(index)
                }
            }
            Text("Selected option: \(themeGroupOptions[selectedOptionIndex])")
        }
        .onChange(of: selectedOptionIndex) { index in
            print("!!!")
            print(themeGroupOptions[index])
        }
    }
}


//struct ViewTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewTest(inputText: .constant("テスト"))
//    }
//}
