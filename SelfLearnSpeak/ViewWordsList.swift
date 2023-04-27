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
/// Represents a collection of items.
final class TableGroup: Object, ObjectKeyIdentifiable {
    /// The unique ID of the ItemGroup. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var tableName = ""
    /// The collection of Items in this group.
    @Persisted var tables = RealmSwift.List<ItemGroup>()
    
}
extension Item {
    static let item1 = Item(value: ["name": "fluffy coasters", "isFavorite": false, "ownerId": "previewRealm"])
    static let item2 = Item(value: ["name": "sudden cinder block", "isFavorite": true, "ownerId": "previewRealm"])
    static let item3 = Item(value: ["name": "classy mouse pad", "isFavorite": false, "ownerId": "previewRealm"])
}
extension ItemGroup {
    static let group = ItemGroup(value: ["items": [Item.item1, Item.item2, Item.item3],"tableName": "previewRealm"])
}

extension TableGroup {
    static let tableGroup = TableGroup(value:["ownerId": "tableRealm"] )
    
    static var tableRealm: Realm {
        var realm: Realm
        let identifier = "tableRealm"
        let config = Realm.Configuration(inMemoryIdentifier: identifier)
        do {
            realm = try Realm(configuration: config)
            // Check to see whether the in-memory realm already contains an ItemGroup.
            // If it does, we'll just return the existing realm.
            // If it doesn't, we'll add an ItemGroup and append the Items.
            let realmObjects = realm.objects(TableGroup.self)
            if realmObjects.count == 1 {
                return realm
            } else {
                try realm.write {
                    realm.add(tableGroup)
                    tableGroup.tables.append(objectsIn: [ItemGroup.group])
                    tableGroup.tableName.append("previewRealm")
                }
                return realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
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
    @ObservedResults(TableGroup.self) var tableGroups
    
    init() {
        debugPrint("ViewWordsList !!!")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if(tableGroups.count>0){
            
            let realm = try! Realm()

            let tableGroup = realm.objects(TableGroup.self)

            try! realm.write {
                realm.delete(tableGroup)
            }
        }else{
            //$tableGroups.append(TableGroup())
            
        }
        //$tableGroups.append(TableGroup())
        
        print(itemGroups)
        print(tableGroups)
        
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
                    envModel.text2speech(all_text)
                    
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
                    envModel.text2speech(item.name)
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
