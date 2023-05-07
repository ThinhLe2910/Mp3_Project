//
//  ListMusicViewController.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit

class ListMusicViewController: UIViewController {
    
    var id :String = ""
    var arrMusic: Array<MusicInfor> = []
    @IBOutlet weak var tableListMusicView: UITableView!
    var musicApi:MusicApiService
    
    init(musicApi: MusicApiService) {
        self.musicApi = musicApi
        super.init(nibName: "ListMusicViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("list music deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMusicOfCategory()
        tableListMusicView.dataSource = self
        tableListMusicView.delegate = self
        tableListMusicView.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
    }
    override func viewWillAppear(_ animated: Bool) {
        getMusicOfCategory()
    }
    func getMusicOfCategory(){
        musicApi.getMusicByCategoryId(categoryId: id, completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            self.arrMusic = value.data
            DispatchQueue.main.async {
                self.tableListMusicView.reloadData()
            }
        })
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
        cell.images.sd_setImage(with: URL(string: arrMusic[indexPath.row].image), placeholderImage: UIImage(named: "placeholder.png"))
    return cell
}
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
}
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let playMusic = PlayMusicViewController(musicAPI: musicApi)
    playMusic.music = arrMusic[indexPath.row]
    if let token = UserDefaults.standard.string(forKey: "token") {
        let id = arrMusic[indexPath.row]._id
        musicApi.addRecent(token: token, id: id, completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            DispatchQueue.main.async {
                if value.result == 1{
                    self.navigationController?.pushViewController(playMusic, animated: true)
                }
            }
        })
    }else{
        self.navigationController?.pushViewController(playMusic, animated: true)
    }
}
@objc func btnPostBy(sender: UIButton){
    guard tableListMusicView.indexPathForRow(at: sender.convert(sender.frame.origin, to: tableListMusicView)) != nil else {
        return
    }
    let musicOfAccVC = MusicOfAccountViewController(musicAPI: musicApi)
    musicOfAccVC.idAccount = arrMusic[sender.tag].idAccount
    self.navigationController?.pushViewController(musicOfAccVC, animated: false)
}
}
