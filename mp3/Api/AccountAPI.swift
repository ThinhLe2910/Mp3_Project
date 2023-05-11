//
//  AccountAPI.swift
//  mp3
//
//  Created by Thinh on 21/04/2023.
//

import Foundation
import UIKit
import Alamofire
protocol AccountAPIService{
    func login(username:String,password:String,completionHandler: @escaping(Result)->Void)
    func register(username:String,password:String,email:String,name:String,confirmPassword:String,completionHandler: @escaping(Result)->Void)
    func getAccount(token:String,completionHandler:@escaping(Account_Result)->Void)
    func updateAccount(token:String,username:String,email:String,name:String,completionHandler: @escaping(Result)->Void)
    func uploadImg(url:URL,completionHandler: @escaping(Result)->Void)
    func saveImg(token: String,avatarImage: String)
    func logout(token: String,completionHandler: @escaping(Result)->Void)
    func changePassword(token:String,newpass:String,current:String,comfirm:String,completionHandler: @escaping(Result)->Void)
}
class AccountApi:AccountAPIService{
    func login(username:String,password:String,completionHandler: @escaping(Result)->Void){
        let parameters: Parameters=[
                    "username":username,
                    "password" : password,
                ]
        AF.request("http://localhost:3000/login",method: .post,parameters: parameters).response{
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
    func register(username:String,password:String,email:String,name:String,confirmPassword:String,completionHandler: @escaping(Result)->Void){
        let parameters: Parameters=[
                    "username":username,
                    "name" : name,
                    "password" : password,
                    "email" : email,
                    "confirmPassword" : confirmPassword
                ]
        AF.request("http://localhost:3000/register",method: .post,parameters: parameters).response{
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
    func getAccount(token:String,completionHandler:@escaping(Account_Result)->Void){
        let parameters: Parameters=[
                    "token":token,
                ]
        AF.request("http://localhost:3000/account",method: .post,parameters: parameters).response{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let dataInfo = try decoder.decode(Account_Result.self, from: data)
                completionHandler(dataInfo)
            } catch let error {
                print(error)
            }
        }
    }
    func updateAccount(token:String,username:String,email:String,name:String,completionHandler: @escaping(Result)->Void){
        let parameters: Parameters=[
                    "token":token,
                    "name" : name,
                    "username" : username,
                    "email" : email
                ]
        AF.request("http://localhost:3000/account/update",method: .post,parameters: parameters).response{
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
    func uploadImg(url:URL,completionHandler: @escaping(Result)->Void){
            AF.upload(multipartFormData: { part in
                part.append(url, withName: "avatar")
            }, to: "http://localhost:3000/uploadAvatar" ).response { response in
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
    func saveImg(token: String,avatarImage: String){
        let parameters: Parameters=[
                    "token":token,
                    "avatarImage" : avatarImage,
                ]
        AF.request("http://localhost:3000/account/updateAvatar",method: .post,parameters: parameters).response{
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
    func logout(token: String,completionHandler: @escaping(Result)->Void){
        let parameters: Parameters=[
                    "token":token,
                ]
        AF.request("http://localhost:3000/logout",method: .post,parameters: parameters).response{
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
    func changePassword(token:String,newpass:String,current:String,comfirm:String,completionHandler: @escaping(Result)->Void){
        let parameters: Parameters=[
                    "token":token,
                    "password" : newpass,
                    "currentPassword" : current,
                    "comfirmPassword" : comfirm
                ]
        AF.request("http://localhost:3000/account/change-password",method: .post,parameters: parameters).response{
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
