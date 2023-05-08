//
//  HomeViewController.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import UIKit
import SDWebImage
struct DATA {
    var album: [CategoryInfor]
    var music: [MusicInfor]
}

class HomeViewController: UIViewController {
   
    @IBOutlet weak var searchBar : UISearchBar!
    var currentDataSource : [MusicInfor] = []
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tableview: UITableView!
    let refreshControl = UIRefreshControl()
    var object: DATA?
    var arrayCategory : Array<CategoryInfor> = []
    var arrMusic: Array<MusicInfor> = []
    
    var categoryAPI:CategoryApiService
    let musicAPI:MusicApiService
    init(musicApi: MusicApiService,categoryAPI: CategoryApiService) {
        self.categoryAPI = categoryAPI
        self.musicAPI = musicApi
        super.init(nibName: "HomeViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        print("homeview deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadDataApi), for: .valueChanged)
        tableview.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
        tableview.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: AlbumTableViewCell.description())
        addingSearchController()
        getCategory()
        getMusic()
        
    }
    
    @objc func loadDataApi(){
        DispatchQueue.main.async {
            self.getCategory()
            self.getMusic()
            self.refreshControl.endRefreshing()
        }
    }
    
    func addingSearchController(){
        searchBar.delegate = self
        searchBar.placeholder = "Search Song's Name..."
    }
    
    func filterCurrentDataSource(searchTerm: String){
        if(searchTerm.count > 0){
            let filterResults = arrMusic.filter { $0.nameAlbum.replacingOccurrences(of: " ", with: "").lowercased().contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())}
            currentDataSource = filterResults
            tableview.reloadData()
        }else{
            currentDataSource = arrMusic
            tableview.reloadData()
        }
    }
    
 
    func getCategory(){
        categoryAPI.getListCategory() { [weak self] value in
            guard let self = self else{
                return
            }
            self.arrayCategory = value.data
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
    }
    
    func getMusic(){
        musicAPI.getListMusic { [weak self] value in
            guard let self = self else{
                return
            }
            self.arrMusic = value.data
            self.currentDataSource = self.arrMusic
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
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
            return currentDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.description(), for: indexPath) as! AlbumTableViewCell
            cell.labelTitle.text = "Album"
            cell.album = arrayCategory
            cell.handleAlbum = { [weak self] id in
                guard let self = self else{
                    return
                }
                let listmusicVC = ListMusicViewController(musicApi: self.musicAPI)
                listmusicVC.id = id
                self.navigationController?.pushViewController(listmusicVC, animated: true)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.description(), for: indexPath) as! AlbumTableViewCell
            cell.labelTitle.text = "New Tracks"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:  ListMusicTableViewCell.description(), for: indexPath) as! ListMusicTableViewCell
            cell.buttonPostBy.setTitle("Post By : " + currentDataSource[indexPath.row].accountUpload![0].name, for: .normal)
            cell.buttonPostBy.addTarget(self, action: #selector(btnPostBy(sender:)), for: .touchUpInside)
            cell.buttonPostBy.tag = indexPath.row
            
            cell.labelNameSinger.text = currentDataSource[indexPath.row].nameSinger
            cell.labelNameMusic.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.labelNameMusic.numberOfLines = 0
            cell.labelNameSinger.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.labelNameSinger.numberOfLines = 0
            cell.labelNameMusic.text = currentDataSource[indexPath.row].nameAlbum
            cell.images.sd_setImage(with: URL(string: currentDataSource[indexPath.row].image), placeholderImage: UIImage(named: "placeholder.png"))
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
            let playMusic = PlayMusicViewController(musicAPI: musicAPI)
            playMusic.music = currentDataSource[indexPath.row]
            if let token = UserDefaults.standard.string(forKey: "token") {
                let id = currentDataSource[indexPath.row]._id
                musicAPI.addRecent(token: token, id: id, completionHandler: { [weak self] value in
                    guard let self = self else{
                        return
                    }
                    DispatchQueue.main.async {
                        self.present(playMusic, animated: true)
                    }
                })
                
            }else{
                self.present(playMusic, animated: true)
            }
        }
        
    }
    @objc func btnPostBy(sender: UIButton){
        print(currentDataSource[sender.tag].idAccount)
        guard tableview.indexPathForRow(at: sender.convert(sender.frame.origin, to: tableview)) != nil else {
            return
        }
        let musicOfAccVC = MusicOfAccountViewController(musicAPI: musicAPI)
        musicOfAccVC.idAccount = currentDataSource[sender.tag].idAccount
        self.navigationController?.pushViewController(musicOfAccVC, animated: false)
    }


}
//extension HomeViewController : UISearchResultsUpdating{
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text{
//            filterCurrentDataSource(searchTerm: searchText)
//        }
//    }
//}
extension HomeViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            filterCurrentDataSource(searchTerm: searchText)
            tableview.reloadData()
        } else {
            currentDataSource = arrMusic
            tableview.reloadData()
        }
    }
   
}
