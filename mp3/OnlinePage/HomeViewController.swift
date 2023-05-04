//
//  HomeViewController.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import UIKit
struct DATA {
    var album: [CategoryInfor]
    var music: [MusicInfor]
}

class HomeViewController: UIViewController {
    var object: DATA?
    var arrayCategory : Array<CategoryInfor> = []
    var arrMusic: Array<MusicInfor> = []
    var domainName:String!
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        domainName = "http://localhost:3000/"
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
        tableview.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: AlbumTableViewCell.description())
        
        getCategory()
        getMusic()
    }
    override func viewWillAppear(_ animated: Bool) {
        getCategory()
        getMusic()
    }
    
    func getCategory(){
        let url = URL(string: domainName + "category/list")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data,
                  let _ = response as?  HTTPURLResponse,
                  error == nil else{
                print("Error from server", error ?? "Error is underfind")
                return
            }
            let jsonDecoder = JSONDecoder()
            let dataInfo = try? jsonDecoder.decode(Category_Result.self, from: data)
            if(dataInfo?.result == 1){
                self.arrayCategory = dataInfo!.data
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            }
        }
        task.resume()
    }
    
    func getMusic(){
        let url = URL(string: domainName + "music")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
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
                    self.tableview.reloadData()
                }
            }
        }.resume()
    }
}


extension HomeViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return arrMusic.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.description(), for: indexPath) as! AlbumTableViewCell
            cell.labelTitle.text = "Album"
            cell.album = arrayCategory
            cell.CollectionView.reloadData()
            cell.handleAlbum = { [weak self] id in
                let listmusicVC = ListMusicViewController()
                listmusicVC._id = id
                self?.navigationController?.pushViewController(listmusicVC, animated: true)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.description(), for: indexPath) as! AlbumTableViewCell
            cell.labelTitle.text = "New Tracks"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:  ListMusicTableViewCell.description(), for: indexPath) as! ListMusicTableViewCell
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 250
        case 1:
            return 33
        default:
            return 150
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        default:
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
    @objc func btnPostBy(sender: UIButton){
        guard tableview.indexPathForRow(at: sender.convert(sender.frame.origin, to: tableview)) != nil else {
            return
        }
        let musicOfAccVC = MusicOfAccountViewController()
        musicOfAccVC.idAccount = arrMusic[sender.tag].idAccount
        self.navigationController?.pushViewController(musicOfAccVC, animated: false)
    }


}
