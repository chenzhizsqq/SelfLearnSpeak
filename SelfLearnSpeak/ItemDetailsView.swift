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
    var body: some View {
        VStack(alignment: .leading) {
            Text("原文:")
            // Accept a new name
            TextEditor(text: $item.name)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
            
            
                Text("翻译后:")
            TextEditor(text: $item.itemDescription)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
        }.padding()
            .navigationBarTitle(item.name)
            .navigationBarItems(trailing: Toggle(isOn: $item.isFavorite) {
                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
            })
    }
}

//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
