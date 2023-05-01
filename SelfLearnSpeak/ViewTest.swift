//
//  ViewTest.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/01.
//

import SwiftUI
import Speech

struct ViewTest: View {
    let synthesizer = AVSpeechSynthesizer()
    @Binding var inputText: String 
    var body: some View {
        
            Button(inputText) {
                //添加条件
                //speak(text: "test")
                speak(text: inputText, language: "ja-JP")
            }.padding()
    }
    
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        synthesizer.speak(utterance)
    }
    
    func speak(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        synthesizer.speak(utterance)
    }
}

struct ViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ViewTest(inputText: .constant("テスト"))
    }
}
