//
//  Account_Recent.swift
//  mp3
//
//  Created by Thinh on 05/04/2023.
//

import Foundation
struct Account_Recent:Decodable{
    var result:Int
    var message:String
    var data : [DataRecent]
}
struct DataRecent:Decodable{
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
