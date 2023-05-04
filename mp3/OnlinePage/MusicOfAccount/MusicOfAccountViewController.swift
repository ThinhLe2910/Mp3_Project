//
//  MusicOfAccountViewController.swift
//  mp3
//
//  Created by Thinh on 08/04/2023.
//

import UIKit

class MusicOfAccountViewController: UIViewController {
    var domainName:String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var idAccount:String = ""
    var arrMusic :[MusicInfor]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        domainName = "http://localhost:3000/"
        imgView.layer.cornerRadius = 75
        imgView.clipsToBounds = true
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        
        getMusic()
        
        tableView.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getMusic(){
        let url = URL(string: domainName + "music/findByAcc")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "_id=" + idAccount
        let postDataString = paramString.data(using: .utf8)
        request.httpBody = postDataString
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = response as?  HTTPURLResponse,
                  error == nil else{
                print("Error from server", error ?? "Error is underfind")
                return
            }
            let jsonDecoder = JSONDecoder()
            let dataInfo = try? jsonDecoder.decode(Music_Result.self, from: data)
            print(String(data: data, encoding: .utf8)!)
            if(dataInfo?.result == 1){
                self.arrMusic = dataInfo!.data
                let account = self.arrMusic[0].accountUpload
                
                let urlAvtar = URL(string: self.domainName + "upload/image/" + (account?[0].avatarImage)!)!
                let getAvater = DispatchQueue(label: "avatar")
                getAvater.async {
                    do{
                        let data = try Data(contentsOf: urlAvtar)
                        DispatchQueue.main.async {
                            
                            self.imgView.image = UIImage(data: data)
                            self.lbName.text = account?[0].name
                            self.tableView.reloadData()
                        }
                    }catch{}
                }
            }
        }.resume()
    }
}
extension MusicOfAccountViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListMusicTableViewCell.description(), for: indexPath) as! ListMusicTableViewCell
        cell.buttonPostBy.isHidden = true
        cell.labelNameMusic.text = arrMusic[indexPath.row].nameAlbum
        cell.labelNameSinger.text = arrMusic[indexPath.row].nameSinger
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playMusic = PlayMusicViewController()
        playMusic.music = arrMusic[indexPath.row]
        if let token = UserDefaults.standard.string(forKey: "token") {
            let url = URL(string: self.domainName + "account/recent")
            let _id = arrMusic[indexPath.row]._id
            var request = URLRequest(url: url!)
            let paramString = "token=" + token + "&_id=" + _id
            let postDataString = paramString.data(using: .utf8)
            request.httpMethod = "POST"
            request.httpBody = postDataString
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data,
                      let _ = response as?  HTTPURLResponse,
                      error == nil else{
                    print("Error from server", error ?? "Error is underfind")
                    return
                }
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(playMusic, animated: true)
                }
            }.resume()
        }else{
            self.navigationController?.pushViewController(playMusic, animated: true)
        }
    }
    
    
}
