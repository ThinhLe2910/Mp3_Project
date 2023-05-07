//
//  DeleteViewController.swift
//  mp3
//
//  Created by Thinh on 27/04/2023.
//

import UIKit

class DeleteViewController: UIViewController {
    var arrMusic: Array<MusicInfor> = []
    var token:String!
    @IBOutlet weak var tableView: UITableView!
    var musicAPI:MusicApiService
    init(musicAPI: MusicApiService) {
        self.musicAPI = musicAPI
        super.init(nibName: "DeleteViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("delete deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")!
        getMusic()
        tableView.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func getMusic(){
        musicAPI.getMusicByToken(token: token, completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            if value.result == 1{
                self.arrMusic = value.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
}
extension DeleteViewController : UITableViewDelegate,UITableViewDataSource{
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
        alert.addAction(UIAlertAction(title: "Delete", style: .default,handler: {[weak self] action in
            guard let self = self else{
                return
            }
            let id = self.arrMusic[indexPath.row]._id
            self.musicAPI.deleteMusic(id: id, token: self.token, completionHandler: { [weak self] value in
                guard let self = self else{
                    return
                }
                DispatchQueue.main.async {
                    self.notiSuccessfully(a:value.message )
                }
            })
        }))
        self.present(alert, animated: true)
    }
    func notiSuccessfully(a:String){
        let alert = UIAlertController(title: "Message", message: a, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak self] action in
            guard let self  = self else{
                return
            }
            self.getMusic()
        }))
        self.present(alert, animated: true)
    }
}
