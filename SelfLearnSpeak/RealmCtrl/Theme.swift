//
//  Theme.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import Foundation
import RealmSwift
import Speech

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
    
    /// The backlink to the `ThemeGroup` this item is a part of.
    @Persisted(originProperty: "themes") var group: LinkingObjects<ThemeGroup>
}
extension Theme {
    static let theme1 = Theme(value: ["name": "temp", "ownerId": "previewRealm"])
}
