//
//  DeleteMusicViewController.swift
//  mp3
//
//  Created by Thinh on 04/04/2023.
//

import UIKit

class DeleteMusicViewController: UIViewController {
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
extension DeleteMusicViewController : UITableViewDelegate,UITableViewDataSource{
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Message", message: "Do you want to Delete music ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .default,handler: { action in
            let url = URL(string: self.domainName + "music/delete")
            let _id = self.arrMusic[indexPath.row]._id
            var request = URLRequest(url: url!)
            let paramString = "token=" + self.token + "&_id=" + _id
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
                        self.notiSuccessfully(a:dataInfo?.message ?? "")
                }
            }.resume()
        }))
        self.present(alert, animated: true)
    }
    func notiSuccessfully(a:String){
        let alert = UIAlertController(title: "Message", message: a, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            self.getMusic()
        }))
        self.present(alert, animated: true)
    }
}

