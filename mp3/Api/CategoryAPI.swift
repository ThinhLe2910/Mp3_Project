//
//  CategoryAPI.swift
//  mp3
//
//  Created by Thinh on 20/04/2023.
//

import Foundation
import Alamofire
protocol CategoryApiService{
    func getListCategory(completionHandler: @escaping (Category_Result) -> Void)
}
class CategoryApi:CategoryApiService{
    func getListCategory(completionHandler: @escaping (Category_Result) -> Void){
        AF.request("http://localhost:3000/category/list",method: .post).response
        {
                response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let dataInfo = try decoder.decode(Category_Result.self, from: data)
                    completionHandler(dataInfo)
                } catch let error {
                    print(error)
                }
            }
        }
    
}

