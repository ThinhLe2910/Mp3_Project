//
//  File.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import Foundation
struct Account_Result:Decodable{
    var result:Int
    var message:String
    var data : AccountInfor
}
struct AccountInfor:Decodable{
    let _id, username, email, name: String
    let password:String?
    let email_active: Bool
    let type, status: Int
    let dateCreated: String
    let recent: [String]
    let listrecent:[MusicInfor]?
    let __v:Int
    let avatarImage: String
}
