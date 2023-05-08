//
//  ItemRow.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import Foundation
import SwiftUI
import RealmSwift
import Speech


/// Represents an Item in a list.
struct ItemRow: View {
    @ObservedRealmObject var item: Item
    
    ///是否显示第二个页面
    @State private var showSecondItemRowView = false
    
    @EnvironmentObject var envModel: EnvironmentModel
    
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
        VStack{
            HStack{
                
                Text(item.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if item.isFavorite {
                    // If the user "favorited" the item, display a heart icon
                    Image(systemName: "heart.fill")
                }
                Button(action: {
                    envModel.text2speech(item.name, language: "ja-JP")
                }) { Image(systemName: "speaker.wave.3") }
                    .buttonStyle(CustomButtonStyle(padding: 5))
            }
            Text(item.itemDescription)
                .foregroundColor(.brown)
                .font(.system(size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onTapGesture {
            showSecondItemRowView = true
        }
        .sheet(isPresented: $showSecondItemRowView, onDismiss: {
            // 在这里添加操作
        }, content: {
            ItemDetailsView(isFavorite:$item.isFavorite,input_text:$item.name,description_text:$item.itemDescription, showSecondView: $showSecondItemRowView)
        })
    }
}
