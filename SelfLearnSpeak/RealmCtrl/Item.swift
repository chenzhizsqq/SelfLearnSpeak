//
//  Item.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/05/04.
//

import Foundation
import SwiftUI
import RealmSwift


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
