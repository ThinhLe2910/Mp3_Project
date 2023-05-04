//
//  YourMusicViewController.swift
//  mp3
//
//  Created by Thinh on 03/04/2023.
//

import UIKit

class YourMusicViewController: UIViewController {
    var domainName:String!
    var arrMusic: Array<MusicInfor> = []
    let clickSw = UISwitch(frame: .zero)
    var token:String!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        domainName = "http://localhost:3000/"
        token = UserDefaults.standard.string(forKey: "token")!
        getMusic()
        tableView.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getMusic()
    }
    
    func getMusic(){
        let url = URL(string: domainName + "music/accountId")
        var request = URLRequest(url: url!)
        let paramString = "token=" + token
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
            let dataInfo = try? jsonDecoder.decode(Music_Result.self, from: data)
            if dataInfo?.result == 1{
                self.arrMusic = dataInfo!.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }.resume()
    }
}
extension YourMusicViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListMusicTableViewCell.description(), for: indexPath) as! ListMusicTableViewCell
        cell.buttonPostBy.isHidden = true
        cell.labelNameSinger.text = arrMusic[indexPath.row].nameSinger
        cell.labelNameMusic.text = arrMusic[indexPath.row].nameAlbum
        cell.labelNameMusic.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.labelNameMusic.numberOfLines = 0
        cell.labelNameSinger.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.labelNameSinger.numberOfLines = 0
        
        
        let clickSw = UISwitch(frame: .zero)
        if arrMusic[indexPath.row].status == true{
            clickSw.setOn(true, animated: true)
        }else{
            clickSw.setOn(false, animated: true)
        }
        clickSw.tag = indexPath.row
        clickSw.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
        cell.accessoryView = clickSw
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    @objc func didChangeSwitch(_ sender:UISwitch){
        let url = URL(string: domainName + "music/updateStatus")
        let id = arrMusic[sender.tag]._id
        var paramString = ""
        var request = URLRequest(url: url!)
        if sender.isOn{
            print("on")
            paramString = "token=" + token + "&id=" + id + "&status=true"
        }else{
            paramString = "token=" + token + "&id=" + id + "&status=false"
        }
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
            _ = try? jsonDecoder.decode(Result.self, from: data)
            print(String(data: data, encoding: .utf8)!)
        }.resume()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let playMusic = PlayMusicViewController()
        //        playMusic.music = self.arrMusic[indexPath.row]
        
    }
}
