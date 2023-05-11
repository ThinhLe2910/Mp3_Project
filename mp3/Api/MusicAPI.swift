//
//  MusicAPI.swift
//  mp3
//
//  Created by Thinh on 21/04/2023.
//

import Foundation
import Alamofire

protocol MusicApiService{
    func getListMusic(completionHandler: @escaping (Music_Result) -> Void)
    func getMusicByCategoryId(categoryId:String,completionHandler: @escaping (Music_Result) -> Void)
    func getMusicByToken(token:String,completionHandler: @escaping (Music_Result) -> Void)
    func updateStatusMusic(token :String,id:String,status:String)
    func deleteMusic(id:String,token:String,completionHandler : @escaping ((Result)->Void))
    func addMusic(token:String,image:String,idCategory:String,nameSong:String,nameSinger:String,newMusic:String,completionHandler: @escaping((Result)->Void))
    func updateMusic(token:String,image:String,id:String,idCategory:String,nameSong:String,nameSinger:String,music:String,completionHandler: @escaping((Result)->Void))
    func findListMusicByAccountId(id:String,completionHandler:@escaping (Music_Result)->Void)
    func uploadMusic(urls:[URL],completionHanlder: @escaping((Result)->Void))
    func uploadMusicImage(url:URL,completionHandler: @escaping(Result)->Void)
}

class MusicApi : MusicApiService{
    func getListMusic(completionHandler: @escaping (Music_Result) -> Void){
        AF.request("http://localhost:3000/music",method: .post).response{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Music_Result.self, from: data)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
    func getMusicByCategoryId(categoryId:String,completionHandler: @escaping (Music_Result) -> Void){
        let parameters: Parameters=[
            "categoryId":categoryId,
        ]
        AF.request("http://localhost:3000/music/categoryId",method: .post,parameters: parameters).response{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Music_Result.self, from: data)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
    func getMusicByToken(token:String,completionHandler: @escaping (Music_Result) -> Void){
        let parameters: Parameters=[
            "token":token,
        ]
        AF.request("http://localhost:3000/music/accountId",method: .post,parameters: parameters).response{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Music_Result.self, from: data)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
    func updateStatusMusic(token :String,id:String,status:String){
        let parameters: Parameters=[
            "token":token,
            "id" : id,
            "status" : status
        ]
        AF.request("http://localhost:3000/music/updateStatus",method: .post,parameters: parameters).response{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let _ = try decoder.decode(Result.self, from: data)
            } catch let error {
                print(error)
            }
        }
    }
    func deleteMusic(id:String,token:String,completionHandler : @escaping ((Result)->Void)){
        let parameters: Parameters=[
            "token":token,
            "_id":id
        ]
        AF.request("http://localhost:3000/music/delete",method: .post,parameters: parameters).response{
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
    func addMusic(token:String,image:String,idCategory:String,nameSong:String,nameSinger:String,newMusic:String,completionHandler: @escaping((Result)->Void)){
        let parameters: Parameters=[
            "token":token,
            "idCategory":idCategory,
            "nameAlbum" : nameSong,
            "nameSinger":nameSinger,
            "file":newMusic,
            "image":image
        ]
        AF.request("http://localhost:3000/music/add",method: .post,parameters: parameters).response{
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
    func updateMusic(token:String,image:String,id:String,idCategory:String,nameSong:String,nameSinger:String,music:String,completionHandler: @escaping((Result)->Void)){
        let parameters: Parameters=[
            "token":token,
            "idCategory":idCategory,
            "nameAlbum" : nameSong,
            "nameSinger":nameSinger,
            "file":music,
            "_id":id,
            "image":image
        ]
        AF.request("http://localhost:3000/music/update",method: .post,parameters: parameters).response{
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
    func uploadMusic(urls:[URL],completionHanlder: @escaping((Result)->Void)){
        if let url = urls.first {
            AF.upload(multipartFormData: { part in
                part.append(url, withName: "music")
            }, to: "http://localhost:3000/uploadMusic" ).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let res = try JSONDecoder().decode(Result.self, from: data!)
                        completionHanlder(res)
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func findListMusicByAccountId(id:String,completionHandler:@escaping (Music_Result)->Void){
        let parameters: Parameters=[
            "_id":id
        ]
        AF.request("http://localhost:3000/music/findByAcc",method: .post,parameters: parameters).response{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Music_Result.self, from: data)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
    func uploadMusicImage(url:URL,completionHandler: @escaping(Result)->Void){
        AF.upload(multipartFormData: { part in
            part.append(url, withName: "music")
        }, to: "http://localhost:3000/music/uploadImage" ).response { response in
            switch response.result {
            case .success(let data):
                do {
                    let res = try JSONDecoder().decode(Result.self, from: data!)
                    completionHandler(res)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
