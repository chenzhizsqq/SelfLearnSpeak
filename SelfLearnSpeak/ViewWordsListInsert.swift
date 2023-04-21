//
//  ViewWordsListInsert.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/20.
//

import SwiftUI
import RealmSwift
import AVFoundation
import Alamofire
import CryptoSwift

import Foundation
import CommonCrypto

extension String {

    /// MD5加密类型
    enum MD5EncryptType {
        /// 32位小写
        case lowercase32
        /// 32位大写
        case uppercase32
        /// 16位小写
        case lowercase16
        /// 16位大写
        case uppercase16
    }
    
    /// MD5加密 默认是32位小写加密
    /// - Parameter type: 加密类型
    /// - Returns: 加密字符串
    func DDMD5Encrypt(_ md5Type: MD5EncryptType = .lowercase32) -> String {
        guard self.count > 0 else {
            print("⚠️⚠️⚠️md5加密无效的字符串⚠️⚠️⚠️")
            return ""
        }
        /// 1.把待加密的字符串转成char类型数据 因为MD5加密是C语言加密
        let cCharArray = self.cString(using: .utf8)
        /// 2.创建一个字符串数组接受MD5的值
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        /// 3.计算MD5的值
        /*
         第一个参数:要加密的字符串
         第二个参数: 获取要加密字符串的长度
         第三个参数: 接收结果的数组
         */
        CC_MD5(cCharArray, CC_LONG(cCharArray!.count - 1), &uint8Array)
        
        switch md5Type {
        /// 32位小写
        case .lowercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
        /// 32位大写
        case .uppercase32:
            return uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
        /// 16位小写
        /*
        case .lowercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02x", $1)}
            return tempStr.getString(startIndex: 8, endIndex: 24)
        /// 16位大写
        case .uppercase16:
            let tempStr = uint8Array.reduce("") { $0 + String(format: "%02X", $1)}
            return tempStr.getString(startIndex: 8, endIndex: 24)
         */
        case .lowercase16:
            return  "待修复Bug"
        case .uppercase16:
            return  "待修复Bug"
        }
    }
}

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
            
            
            HStack{
                Text("原文")
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding(.horizontal)
                Button("翻译") {
                    if(!input_text.isEmpty){
                        getfanyi(你的APPID: "20211218001031744", 你的密钥: "sciKrOsAy6QmASY4fC1g",from: "jp" ,to: "zh", 被翻译内容: input_text)
                    }
                }
                .padding(.horizontal)
            }
            
            TextEditor(text: $input_text)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
            
            HStack{
                Text("原文")
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding(.horizontal)
                Button("翻译") {
                    if(!input_text.isEmpty){
                        getfanyi2(你的APPID: "20211218001031744", 你的密钥: "sciKrOsAy6QmASY4fC1g",from: "zh" ,to: "jp", 被翻译内容: description_text)
                    }
                }
                .padding(.horizontal)
            }
            
            TextEditor(text: $description_text)
                .autocapitalization(.none)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.gray, lineWidth: 1))
                .border(.gray)
                .background(.cyan)
                .padding()
        }.padding()
    }
    
    func getfanyi(你的APPID:String,你的密钥:String,from:String,to:String,被翻译内容:String) {
        
        //let 随机数 = "1435660288"
        let 随机数 = String(UInt64.random(in: 1000000000...9999999999))
        
        //加密方法在另一个文件
        let 加密 = "\(你的APPID)\(被翻译内容)\(随机数)\(你的密钥)".DDMD5Encrypt(.lowercase32)
        
        let 编码 = 被翻译内容.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
        let 网址 = "https://fanyi-api.baidu.com/api/trans/vip/translate?"+"q=\(编码!)&from=\(from)&to=\(to)&appid=\(你的APPID)&salt=\(随机数)&sign=\(加密)"
        
        //发送请求
        AF.request(网址).responseDecodable(of: TranslationResponse.self) { response in
            switch response.result {
            case .success(let data):
                debugPrint("!!! response.request success")
                print(data.from)
                print(data.to)
                print(data.transResult)
                
                if let src = data.transResult.first?.src as? String {
                    print(src)
                }
                if let dst = data.transResult.first?.dst as? String {
                    print(dst)
                    description_text = dst
                }
            case .failure(let error):
                debugPrint("!!! response.request failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getfanyi2(你的APPID:String,你的密钥:String,from:String,to:String,被翻译内容:String) {
        
        //let 随机数 = "1435660288"
        let 随机数 = String(UInt64.random(in: 1000000000...9999999999))
        
        //加密方法在另一个文件
        let 加密 = "\(你的APPID)\(被翻译内容)\(随机数)\(你的密钥)".DDMD5Encrypt(.lowercase32)
        
        let 编码 = 被翻译内容.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
        let 网址 = "https://fanyi-api.baidu.com/api/trans/vip/translate?"+"q=\(编码!)&from=\(from)&to=\(to)&appid=\(你的APPID)&salt=\(随机数)&sign=\(加密)"
        
        //发送请求
        AF.request(网址).responseDecodable(of: TranslationResponse.self) { response in
            switch response.result {
            case .success(let data):
                debugPrint("!!! response.request success")
                print(data.from)
                print(data.to)
                print(data.transResult)
                
                if let src = data.transResult.first?.src as? String {
                    print(src)
                }
                if let dst = data.transResult.first?.dst as? String {
                    print(dst)
                    input_text = dst
                }
            case .failure(let error):
                debugPrint("!!! response.request failed: \(error.localizedDescription)")
            }
        }
    }

}



struct TranslationResponse: Codable {
    let from: String
    let to: String
    let transResult: [TranslationResult]
    
    enum CodingKeys: String, CodingKey {
        case from, to
        case transResult = "trans_result"
    }
}

struct TranslationResult: Codable {
    let dst: String
    let src: String
}

//struct ViewWordsListInsert_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewWordsListInsert()
//    }
//}
