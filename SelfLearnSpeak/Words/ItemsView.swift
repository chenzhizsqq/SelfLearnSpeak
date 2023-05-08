//
//  ItemsView.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import Foundation

import SwiftUI
import RealmSwift
import Speech


// MARK: Item Views
/// The screen containing a list of items in an ItemGroup. Implements functionality for adding, rearranging,
/// and deleting items in the ItemGroup.
struct ItemsView: View {
    @ObservedRealmObject var itemGroup: ItemGroup
    @EnvironmentObject var envModel: EnvironmentModel
    
    
    ///是否显示第二个页面
    @State private var showSecondView = false
    
    @State var isFavorite = false
    @State var input_text = ""
    @State var description_text: String = ""
    //@State var all_text = ""
    
    /// The button to be displayed on the top left.
    var leadingBarButton: AnyView?
    var body: some View {
        NavigationView {
            VStack {
                
                // The list shows the items in the realm.
                List {
                    ForEach(itemGroup.items) { item in
                        ItemRow(item: item)
                    }.onDelete(perform: $itemGroup.items.remove)
                        .onMove(perform: $itemGroup.items.move)
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Items", displayMode: .large)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: EditButton(),
                    // Edit button on the right to enable rearranging items
                    trailing:Button("添加") {
                        showSecondView = true
                    }
                )
                Button("全部发音") {
                    var all_text = ""
                    itemGroup.items.forEach { Item in
                        all_text.append(Item.name)
                        all_text.append("。")
                    }
                    envModel.text2speech(all_text, language: "ja-JP")
                    
                }
                // Action bar at bottom contains Add button.
            }
        }
        .sheet(isPresented: $showSecondView){
            ViewWordsListInsert(itemGroup: itemGroup, isFavorite: $isFavorite, input_text: $input_text, description_text: $description_text, showSecondView: $showSecondView)
        }
    }
}
