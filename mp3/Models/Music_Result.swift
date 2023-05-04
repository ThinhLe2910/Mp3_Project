//
//  Music_Result.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import Foundation
struct Music_Result: Decodable {
    let result: Int
    let message:String
    let data: [MusicInfor]
}

struct MusicInfor: Decodable {
    let _id, idAccount, idCategory, nameAlbum: String
    let nameSinger, file: String?
    let status: Bool
    let Category: [CategoryInfor]?
    let accountUpload: [AccountInfor]?
}
