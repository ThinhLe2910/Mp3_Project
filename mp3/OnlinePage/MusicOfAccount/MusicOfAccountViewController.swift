//
//  MusicOfAccountViewController.swift
//  mp3
//
//  Created by Thinh on 08/04/2023.
//

import UIKit
import SDWebImage
class MusicOfAccountViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var musicAPI:MusicApiService
    init(musicAPI: MusicApiService) {
        self.musicAPI = musicAPI
        super.init(nibName: "MusicOfAccountViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var idAccount:String = ""
    var arrMusic :[MusicInfor]=[]
    deinit{
        print("music of account deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        musicAPI.findListMusicByAccountId(id: idAccount, completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            if(value.result == 1){
                self.arrMusic = value.data
                let account = self.arrMusic[0].accountUpload
                self.imgView.sd_setImage(with: URL(string: (account?[0].avatarImage)!), placeholderImage: UIImage(named: "placeholder.png"))
                self.lbName.text = account?[0].name
                self.tableView.reloadData()
            }
        })
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
        cell.images.sd_setImage(with: URL(string: arrMusic[indexPath.row].image), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playMusic = PlayMusicViewController(musicAPI: musicAPI)
        playMusic.music = arrMusic[indexPath.row]
        if let token = UserDefaults.standard.string(forKey: "token") {
            let id = arrMusic[indexPath.row]._id
            musicAPI.addRecent(token: token, id: id, completionHandler: { [weak self] value in
                guard let self = self else{
                    return
                }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(playMusic, animated: true)
                }
            })
        }else{
            self.navigationController?.pushViewController(playMusic, animated: true)
        }
    }
    
    
}
