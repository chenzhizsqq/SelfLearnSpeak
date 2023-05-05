//
//  BaiduFanyiAPI.swift
//  SelfLearnSpeak
//
//  Created by chenzhizs on 2023/04/21.
//

import SwiftUI
import RealmSwift
import AVFoundation
import Alamofire
import CryptoSwift

import Foundation
import CommonCrypto

class BaiduFanyiAPI {
    
    static let AppId = "20211218001031744"
    static let Key = "sciKrOsAy6QmASY4fC1g"
    
    static func getfanyi(from:String,to:String,text:String,type:String,mvvm:TransViewModel) {
        
        let 你的APPID = BaiduFanyiAPI.AppId
        let 你的密钥 = BaiduFanyiAPI.Key
        
        //let 随机数 = "1435660288"
        let 随机数 = String(UInt64.random(in: 1000000000...2000000000))
        
        //加密方法在另一个文件
        let 加密 = "\(你的APPID)\(text)\(随机数)\(你的密钥)".DDMD5Encrypt(.lowercase32)
        
        let 编码 = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
        let 网址 = "https://fanyi-api.baidu.com/api/trans/vip/translate?"+"q=\(编码!)&from=\(from)&to=\(to)&appid=\(你的APPID)&salt=\(随机数)&sign=\(加密)"
        
        //发送请求
        AF.request(网址).responseDecodable(of: TranslationResponse.self) { response in
            switch response.result {
            case .success(let data):
                debugPrint("!!! response.request success")
                debugPrint(data.from)
                debugPrint(data.to)
                debugPrint(data.transResult)
                
                if let src = data.transResult.first?.src as? String {
                    debugPrint(src)
                }
                if let dst = data.transResult.first?.dst as? String {
                    debugPrint(dst)
                    if(type=="jp2zh"){
                        mvvm.zh = dst
                    }
                    if(type=="zh2jp"){
                        mvvm.jp = dst
                    }
                }
            case .failure(let error):
                debugPrint("!!! response.request failed: \(error.localizedDescription)")
            }
        }
    }
}


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
            debugPrint("⚠️⚠️⚠️md5加密无效的字符串⚠️⚠️⚠️")
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


class TransViewModel: ObservableObject {
    @Published  var zh: String = ""
    @Published  var jp: String = ""
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
