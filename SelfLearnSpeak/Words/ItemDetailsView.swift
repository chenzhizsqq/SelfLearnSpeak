//
//  ItemDetailsView.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/21.
//

import SwiftUI
import RealmSwift
import Speech


/// Represents a screen where you can edit the item's name.
struct ItemDetailsView: View {
    @Binding var isFavorite : Bool
    @Binding var input_text : String
    @Binding var description_text: String
    @Binding var showSecondView: Bool
    @StateObject var transViewModel = TransViewModel()
    var body: some View {
        ScrollView{
            ViewTemplate( isFavorite: $isFavorite,  showSecondView: $showSecondView, input_text: $input_text, description_text: $description_text, transViewModel: transViewModel)
        }
    }
}

//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
