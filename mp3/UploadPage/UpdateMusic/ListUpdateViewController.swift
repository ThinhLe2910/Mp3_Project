//
//  ListUpdateViewController.swift
//  mp3
//
//  Created by Thinh on 04/04/2023.
//

import UIKit
import SDWebImage
class ListUpdateViewController: UIViewController {
    var arrMusic: Array<MusicInfor> = []
    let clickSw = UISwitch(frame: .zero)
    @IBOutlet weak var tableView: UITableView!
    var token:String!
    
    var musicAPI:MusicApiService
    
    init(musicAPI: MusicApiService) {
        self.musicAPI = musicAPI
        super.init(nibName: "ListUpdateViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("list update deinit")
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
extension ListUpdateViewController : UITableViewDelegate,UITableViewDataSource{
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
        cell.images.sd_setImage(with: URL(string: arrMusic[indexPath.row].image), placeholderImage: UIImage(named: "placeholder.png"))
   
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryApi : CategoryApiService = CategoryApi()
        let updateVC = HomeUploadViewController(categoryAPI: categoryApi, musicAPI: musicAPI)
        updateVC.statusUpdate = false
        updateVC.music = arrMusic[indexPath.row]
        self.navigationController?.pushViewController(updateVC, animated: true)
        
    }
}

