//
//  YourMusicViewController.swift
//  mp3
//
//  Created by Thinh on 03/04/2023.
//

import UIKit
import SDWebImage
class YourMusicViewController: UIViewController {
    var arrMusic: Array<MusicInfor> = []
    var clickSw = UISwitch(frame: .zero)
    var token:String!
    @IBOutlet weak var tableView: UITableView!
    var musicAPI: MusicApiService
    init(musicAPI: MusicApiService) {
        self.musicAPI = musicAPI
        super.init(nibName: "YourMusicViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("your music deinint")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.images.sd_setImage(with: URL(string: self.arrMusic[indexPath.row].image), placeholderImage: UIImage(named: "placeholder.png"))
        
        
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
        let id = arrMusic[sender.tag]._id
        var status = ""
        if sender.isOn{
            status = "true"
        }else{
            status = "false"
        }
        musicAPI.updateStatusMusic(token: token, id: id, status: status)
    }
}
