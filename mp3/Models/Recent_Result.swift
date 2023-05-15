//
//  Recent_Result.swift
//  mp3
//
//  Created by Thinh on 10/05/2023.
//

import Foundation
struct Recent_Result:Decodable{
    var result:Int
    var message:String
    var data : [DataRecent]
}
struct DataRecent:Decodable{
    let _id: String
    let recent:String
    let listrecent:[MusicInfor]?
}
