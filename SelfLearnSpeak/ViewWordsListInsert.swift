//
//  ViewWordsListInsert.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/20.
//

import SwiftUI
import RealmSwift
import AVFoundation


struct ViewWordsListInsert: View {
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedRealmObject var itemGroup: ItemGroup
    @EnvironmentObject var envModel: EnvironmentModel
    @Binding var input_text : String
    @Binding var description_text: String
    var body: some View {
        
        VStack{
            
            HStack {
                Spacer()
                Button(action: {
                    // The bound collection automatically
                    // handles write transactions, so we can
                    // append directly to it.
                    let item = Item()
                    item.name = input_text
                    item.itemDescription = description_text
                    $itemGroup.items.append(item)
                    input_text = ""
                    description_text = ""
                }) { Image(systemName: "plus") }
                    .buttonStyle(CustomButtonStyle(padding: 10))
                Spacer()
                Button(action: {
                    
                    envModel.text2speech(input_text)
                }) { Image(systemName: "speaker.wave.3") }
                    .buttonStyle(CustomButtonStyle(padding: 10))
                Spacer()
                Button(action: {
                    
                }) { Image(systemName: "magnifyingglass") }
                    .buttonStyle(CustomButtonStyle(padding: 10))
                Spacer()
            }.padding(20)
            
            Text("原文")
                .textFieldStyle(DefaultTextFieldStyle())
                .padding(.horizontal)
            
            TextEditor(text: $input_text)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
            
            Text("翻译")
                .textFieldStyle(DefaultTextFieldStyle())
                .padding(.horizontal)
            
            TextEditor(text: $description_text)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
        }.padding()
    }
}

//struct ViewWordsListInsert_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWordsListInsert()
//    }
//}
