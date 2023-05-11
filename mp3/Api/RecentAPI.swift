//
//  RecentAPI.swift
//  mp3
//
//  Created by Thinh on 11/05/2023.
//

import Foundation
import Alamofire

protocol RecentApiService{
    func getRecentAccount(token: String,completionHandler: @escaping(Recent_Result)->Void)
    func addRecent(token:String,idMusic:String,completionHandler: @escaping(Result)->Void)
}
class RecentAPI:RecentApiService{
    func getRecentAccount(token: String,completionHandler: @escaping(Recent_Result)->Void){
        let parameters: Parameters=[
                    "token":token,
                ]
        AF.request("http://localhost:3000/get/recent",method: .post,parameters: parameters).response{
            response in
            
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Recent_Result.self, from: data)
//                print(dataInfo)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
    func addRecent(token:String,idMusic:String,completionHandler: @escaping(Result)->Void){
        let parameters: Parameters=[
            "token":token,
            "idMusic":idMusic
        ]
        AF.request("http://localhost:3000/recent",method: .post,parameters: parameters).response{
            response in
            
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Result.self, from: data)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
}
