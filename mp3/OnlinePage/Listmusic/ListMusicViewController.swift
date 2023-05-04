//
//  ListMusicViewController.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit

class ListMusicViewController: UIViewController {
    var _id :String = ""
    var domainName:String!
    var arrMusic: Array<MusicInfor> = []
    @IBOutlet weak var tableListMusicView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        domainName = "http://localhost:3000/"
        getMusicOfCategory()
        tableListMusicView.dataSource = self
        tableListMusicView.delegate = self
        tableListMusicView.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
    }
    override func viewWillAppear(_ animated: Bool) {
        getMusicOfCategory()
    }
    func getMusicOfCategory(){
        let url = URL(string: domainName + "music/categoryId")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "categoryId=" + _id
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
            if(dataInfo?.result == 1){
                self.arrMusic = dataInfo!.data
                DispatchQueue.main.async {
                    self.tableListMusicView.reloadData()
                }
            }
        }.resume()
    }
}
extension ListMusicViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableListMusicView.dequeueReusableCell(withIdentifier: ListMusicTableViewCell.description(), for: indexPath) as! ListMusicTableViewCell
        cell.buttonPostBy.setTitle("Post By : " + arrMusic[indexPath.row].accountUpload![0].name, for: .normal)
        cell.buttonPostBy.addTarget(self, action: #selector(btnPostBy(sender:)), for: .touchUpInside)
        cell.buttonPostBy.tag = indexPath.row
        cell.labelNameSinger.text = arrMusic[indexPath.row].nameSinger
        cell.labelNameMusic.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.labelNameMusic.numberOfLines = 0
        cell.labelNameSinger.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.labelNameSinger.numberOfLines = 0
        cell.labelNameMusic.text = arrMusic[indexPath.row].nameAlbum
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
                guard let data = data,
                      let _ = response as?  HTTPURLResponse,
                      error == nil else{
                    print("Error from server", error ?? "Error is underfind")
                    return
                }
                let jsonDecoder = JSONDecoder()
                let dataInfo = try? jsonDecoder.decode(Result.self, from: data)
                DispatchQueue.main.async {
                    if dataInfo?.result == 1{
                        self.navigationController?.pushViewController(playMusic, animated: true)
                    }
                }
            }.resume()
        }else{
            self.navigationController?.pushViewController(playMusic, animated: true)
        }
    }
    @objc func btnPostBy(sender: UIButton){
        guard tableListMusicView.indexPathForRow(at: sender.convert(sender.frame.origin, to: tableListMusicView)) != nil else {
            return
        }
        let musicOfAccVC = MusicOfAccountViewController()
        musicOfAccVC.idAccount = arrMusic[sender.tag].idAccount
        self.navigationController?.pushViewController(musicOfAccVC, animated: false)
    }
}
