//
//  ViewWordsList.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/19.
//

import SwiftUI
import RealmSwift
import AVFoundation

/// An individual item. Part of an `ItemGroup`.
final class Item: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The name of the Item, By default
    @Persisted var name = ""
    /// A flag indicating whether the user "favorited" the item.
    @Persisted var isFavorite = false
    /// Users can enter a description, which is an empty string by default
    @Persisted var itemDescription = ""
    
    /// 主标题
    @Persisted var Theme = ""
    
    /// The backlink to the `ItemGroup` this item is a part of.
    @Persisted(originProperty: "items") var group: LinkingObjects<ItemGroup>
    
}
/// Represents a collection of items.
final class ItemGroup: Object, ObjectKeyIdentifiable {
    /// The unique ID of the ItemGroup. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The collection of Items in this group.
    @Persisted var items = RealmSwift.List<Item>()
    
}

/// An individual item. Part of an `ThemeGroup`.
final class Theme: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Item. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The name of the Item, By default
    @Persisted var name = ""
    @Persisted var isFavorite = false
    @Persisted var aboveTxt = ""
    @Persisted var belowTxt = ""
    
    /// The backlink to the `HeadingGroup` this item is a part of.
    @Persisted(originProperty: "themes") var group: LinkingObjects<ThemeGroup>
}
/// Represents a collection of items.
final class ThemeGroup: Object, ObjectKeyIdentifiable {
    /// The unique ID of the ItemGroup. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    /// The collection of Items in this group.
    @Persisted var themes = RealmSwift.List<Theme>()
}

extension Item {
    static let item1 = Item(value: ["name": "fluffy coasters", "isFavorite": false, "ownerId": "previewRealm"])
    static let item2 = Item(value: ["name": "sudden cinder block", "isFavorite": true, "ownerId": "previewRealm"])
    static let item3 = Item(value: ["name": "classy mouse pad", "isFavorite": false, "ownerId": "previewRealm"])
    
    //自我紹介的默认数据
    static let IntroduceMyselfArray = [
        Item(value: ["name": "2007年に中国電子科学技術大学を卒業しました。",
                     "itemDescription":"毕业于中国大学。　"]),
        Item(value: ["name": "中国では、私は6年間IT開発をしました。",
                     "itemDescription":""]),
        Item(value: [
            "name": "2013年から、日本に来て、IT開発をしました。"]
            ),
        Item(value: [
            "name": "今まで、日本で　すでに 9年間 IT開発をしました。"]
            ),
        Item(value: [
            "name": "今、私は北池袋に、住んでいます。"]
            ),
        Item(value: [
            "name": "日本語能力検定は二級です。"]
            ),
        Item(value: [
            "name": "日本語の読み書き，と一般会話，は大丈夫です。"]
            ),
        Item(value: [
            "name": "だから、基本設計と詳細設計には、問題もありません。"]
            ),
        Item(value: [
            "name": "私の開発能力について。"]
            ),
        Item(value: [
            "name": "得意な開発能力はモバイルソフトウェア開発です。"]
            ),
        Item(value: [
            "name": "モバイルソフトウェア開発の経験の中で、JAVA三年、kotlin三年、swift二年、JS 一年。"]
            ),
        Item(value: [
            "name": "ここ5年間、主に　モバイルソフトウェア開発をしています。"]
            ),
        Item(value: [
            "name": "今から、私のモバイルのプロジェクトを紹介します。"]
            ),
        Item(value: ["name": "履歴書の１０番目のプロジェクト。主な内容はモバイル開発です。"]),
        Item(value: ["name": "以上、私の自己紹介です。ありがとうございます。"]),
        ]
}

extension ItemGroup {
    static let itemGroup = ItemGroup(value: ["ownerId": "previewRealm"])
    
    static var previewRealm: Realm {
        var realm: Realm
        let identifier = "previewRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            // Check to see whether the in-memory realm already contains an ItemGroup.
            // If it does, we'll just return the existing realm.
            // If it doesn't, we'll add an ItemGroup and append the Items.
            let realmObjects = realm.objects(ItemGroup.self)
            if realmObjects.count == 1 {
                return realm
            } else {
                try realm.write {
                    realm.add(itemGroup)
                    itemGroup.items.append(objectsIn: [Item.item1, Item.item2, Item.item3])
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}


/// The main content view if not using Sync.
struct ViewWordsList: View {
    // Implicitly use the default realm's objects(ItemGroup.self)
    @ObservedResults(ItemGroup.self) var itemGroups
    
    init() {
        debugPrint("ViewWordsList !!!")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        print(itemGroups)
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let realmURL = documentsDirectory.appendingPathComponent("default.realm")
        print("Realm file path: \(realmURL.path)")
    }
    var body: some View {
        if let itemGroup = itemGroups.first {
            // Pass the ItemGroup objects to a view further
            // down the hierarchy
            ItemsView(itemGroup: itemGroup)
        } else {
            // For this small app, we only want one itemGroup in the realm.
            // You can expand this app to support multiple itemGroups.
            // For now, if there is no itemGroup, add one here.
            ProgressView().onAppear {
                $itemGroups.append(ItemGroup())
            }
        }
    }
}

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
            print("Sheet onDismiss")
        }, content: {
            ItemDetailsView(isFavorite:$item.isFavorite,input_text:$item.name,description_text:$item.itemDescription, showSecondView: $showSecondItemRowView)
        })
    }
}


// MARK: - 选择按钮的模板
struct CustomButtonStyle: ButtonStyle {
    
    var padding: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all,padding)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

//struct ViewWordsList_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWordsList()
//    }
//}
