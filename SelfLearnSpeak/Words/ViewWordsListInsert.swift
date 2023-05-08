//
//  ViewWordsListInsert.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/20.
//

import SwiftUI
import RealmSwift
import Speech
import Alamofire
import CryptoSwift

import Foundation
import CommonCrypto


struct ViewWordsListInsert: View {
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedRealmObject var itemGroup: ItemGroup
    @EnvironmentObject var envModel: EnvironmentModel
    @Binding var isFavorite: Bool
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
                    item.isFavorite = isFavorite
                    item.name = input_text
                    item.itemDescription = description_text
                    $itemGroup.items.append(item)
                    input_text = ""
                    description_text = ""
                    self.showSecondView = false
                    }
                .buttonStyle(CustomButtonStyle(padding: 10))
                .padding()
            
            
                ViewTemplate( isFavorite: $isFavorite,  showSecondView: $showSecondView, input_text: $input_text, description_text: $description_text, transViewModel: transViewModel)
            }
        }
    }

}


//struct ViewWordsListInsert_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWordsListInsert()
//    }
//}
