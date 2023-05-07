//
//  Category_Result.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import Foundation
struct Category_Result:Decodable{
    var result:Int
    var message:String
    var data : [CategoryInfor]
}
struct CategoryInfor:Decodable{
    var name:String
    var _id:String
    var image:String
}
