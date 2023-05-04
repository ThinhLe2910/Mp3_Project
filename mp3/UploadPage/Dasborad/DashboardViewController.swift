//
//  DashboardViewController.swift
//  mp3
//
//  Created by Thinh on 04/04/2023.
//
import UIKit
struct ListRecent{
    var open :Bool
    var data: [MusicInfor]
}
class DashboardViewController: UIViewController {
    var newImage:String!
    var domainName:String!
    var list : [Section]!
    var arr : DataRecent!
    var recent:[MusicInfor]=[]
    var token : String!
    var listRecent : ListRecent?
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.listRecent = ListRecent(open: false, data:[])
        domainName = "http://localhost:3000/"
        token = UserDefaults.standard.string(forKey: "token")!
        avatarView.layer.cornerRadius = 100
        avatarView.clipsToBounds = true
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.lightGray.cgColor
        getMusic()
        
        list = [
            Section(
                open:false,
                data: [
                    CellData(title: "Private", img: UIImage(named: "privacy")!),
                    CellData(title: "Edit", img: UIImage(named: "write")!),
                    CellData(title: "Delete", img: UIImage(named: "delete")!),
                ]
            ),
            Section(
                open:false,
                data: [
                    CellData(title: "Upload", img: UIImage(named: "upload-3")!),
                ]
            ),
            Section(
                open:false,
                data: [
                    CellData(title: "Information", img: UIImage(named: "privacy")!),
                    CellData(title: "Changle Password", img: UIImage(named: "write")!),
                ]
            ),
            
        ]
        
        
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "UploadTableViewCell", bundle: nil), forCellReuseIdentifier: UploadTableViewCell.description())
        tableView.register(UINib(nibName: "ListMusicTableViewCell", bundle: nil), forCellReuseIdentifier: ListMusicTableViewCell.description())
        tableView.register(UINib(nibName: "ButtonLogOutTableViewCell", bundle: nil), forCellReuseIdentifier: ButtonLogOutTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getMusic()
    }
}
extension DashboardViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0 :
            if(!listRecent!.open)
            {
                return 0
            }else{
                return listRecent!.data.count
            }
        case 4:
            return 1
        default:
            if(!list[section - 1].open)
            {
                return 0
            }else{
                return list[section - 1].data.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: ListMusicTableViewCell.description(), for: indexPath) as! ListMusicTableViewCell
            cell.buttonPostBy.setTitle("Post By : " + arr.name,for: .normal)
            cell.labelNameSinger.text = recent[indexPath.row].nameSinger
            cell.labelNameMusic.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.labelNameMusic.numberOfLines = 0
            cell.labelNameSinger.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.labelNameSinger.numberOfLines = 0
            cell.labelNameMusic.text = recent[indexPath.row].nameAlbum
            cell.backgroundColor =
            #colorLiteral(red: 0.8884527683, green: 0.9174801707, blue: 0.9368647933, alpha: 1)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonLogOutTableViewCell.description(), for: indexPath) as! ButtonLogOutTableViewCell
            cell.btnLogout.tag = indexPath.row
            cell.btnLogout.addTarget(self, action: #selector(Logout(sender:)), for: .touchUpInside)
            return cell
        default :
            let cell = tableView.dequeueReusableCell(withIdentifier: UploadTableViewCell.description(), for: indexPath) as! UploadTableViewCell
            let celldata = list[indexPath.section - 1].data
            cell.lbTilte.text = celldata[indexPath.row].title
            cell.imgView.image = celldata[indexPath.row].img
            cell.backgroundColor =
            #colorLiteral(red: 0.8884527683, green: 0.9174801707, blue: 0.9368647933, alpha: 1)
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.tag = section
        button.addTarget(self, action: #selector(self.openSection), for: .touchUpInside)
        switch section {
        case 0:
            button.setImage(UIImage(named: "history"), for: .normal)
            button.setTitle("Recent", for: .normal)
            button.setTitleColor(.black, for: .normal)
            return button
        case 1:
            
            button.setImage(UIImage(named: "music-2"), for: .normal)
            button.setTitle("Your Music", for: .normal)
            button.setTitleColor(.black, for: .normal)
            return button
        case 2 :
            button.setImage(UIImage(named: "up"), for: .normal)
            button.setTitle("Upload", for: .normal)
            button.setTitleColor(.black, for: .normal)
            return button
        case 3:
            button.setImage(UIImage(named: "account"), for: .normal)
            button.setTitle("Account", for: .normal)
            button.setTitleColor(.black, for: .normal)
            return button
        default :
            let label = UILabel(frame: .zero)
            return label
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0 :
            return 150
        default:
            return 60
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    @objc func openSection(sender:UIButton){
        let section = sender.tag
        var indexPaths = [IndexPath]()
        switch section {
        case 0 :
            for row in listRecent!.data.indices{
                let indexPathtoDelete = IndexPath(row:row,section: section)
                indexPaths.append(indexPathtoDelete)
            }
            let isOpen = listRecent!.open
            listRecent?.open = !isOpen
            if(isOpen){
                self.tableView.deleteRows(at: indexPaths, with: .fade)
            }else{
                self.tableView.insertRows(at: indexPaths, with: .fade)
            }
        default:
            for row in list[section - 1].data.indices{
                let indexPathtoDelete = IndexPath(row:row,section: section)
                indexPaths.append(indexPathtoDelete)
            }
            let isOpen = list[section - 1].open
            list[section - 1].open = !isOpen
            if(isOpen){
                self.tableView.deleteRows(at: indexPaths, with: .fade)
            }else{
                self.tableView.insertRows(at: indexPaths, with: .fade)
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0 :
            let playmusicVC = PlayMusicViewController()
            playmusicVC.music = recent[indexPath.row]
            self.navigationController?.pushViewController(playmusicVC, animated: true)
        case 1:
            switch indexPath.row{
            case 0 :
                self.navigationController?.pushViewController(YourMusicViewController(), animated: true)
            case 1 :
                let yourMusicVC = ListUpdateViewController()
                self.navigationController?.pushViewController(yourMusicVC, animated: true)
            default :
                self.navigationController?.pushViewController(DeleteMusicViewController(), animated: true)
            }
        case 2:
            let uploadVC = HomeUploadViewController()
            uploadVC.statusUpload = false
            self.navigationController?.pushViewController(uploadVC, animated: true)
        case 3:
            switch indexPath.row{
            case 0 :
                self.navigationController?.pushViewController(InformationViewController(), animated: true)
            default:
                self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
            }
        default:
            print("Logout")
        }
    }
    
    func getMusic(){
        let url = URL(string: self.domainName + "get/recent")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "token=" + token
        let postDataString = paramString.data(using: .utf8)
        request.httpBody = postDataString
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data,
                  let _ = response as?  HTTPURLResponse,
                  error == nil else{
                print("Error from server", error ?? "Error is underfind")
                return
            }
            let jsonDecoder = JSONDecoder()
            let dataInfo = try? jsonDecoder.decode(Account_Recent.self, from: data)
            if(dataInfo?.result == 1){
                self.arr = dataInfo!.data[0]
                self.recent = (arr.listrecent)!
                self.listRecent?.data = (arr.listrecent)!
                let urlAvtar = URL(string: self.domainName + "upload/image/" + arr.avatarImage)!
                let getAvater = DispatchQueue(label: "avatar")
                getAvater.async {
                    do{
                        let data = try Data(contentsOf: urlAvtar)
                        DispatchQueue.main.async {
                            
                            self.avatarView.image = UIImage(data: data)
                            self.tableView.reloadData()
                        }
                    }catch{}
                }
            }
        }.resume()
    }
    
    @objc func Logout(sender: UIButton){
        guard tableView.indexPathForRow(at: sender.convert(sender.frame.origin, to: tableView)) != nil else {
            return
        }
        let url = URL(string: domainName + "logout")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "token=" + token
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
            let dataInfo = try? jsonDecoder.decode(Result.self, from: data)
            if(dataInfo?.result==1){
                DispatchQueue.main.async {
                    UserDefaults.standard.removeObject(forKey: "token")
//                    let window = UIApplication.shared.keyWindow
//                    let loginVC = LoginViewController()
//                    window?.rootViewController = loginVC
//                    window?.makeKeyAndVisible()
                    self.navigationController?.pushViewController(LoginViewController(), animated: false)
                }
            }
        }.resume()
    }
}

extension DashboardViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBAction func clickImage(_ sender: Any) {
        let action = UIAlertController(title: "Notification", message: "Choose Avatar", preferredStyle: .actionSheet)
        let choosePhoto = UIAlertAction(title: "Choose Photo In Library", style: .default) { e in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = .photoLibrary
            self.present(image, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        action.addAction(choosePhoto)
        action.addAction(cancel)
        present(action, animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage{
            avatarView.image = img
        }
        self.dismiss(animated: true)
        let action = UIAlertController(title: "Notification", message: "Do you want to save this?", preferredStyle: .actionSheet)
        let save = UIAlertAction(title: "Save", style: .default) { e in
            let url = URL(string: self.domainName + "uploadAvatar")
            let boundary = UUID().uuidString
            let session = URLSession.shared
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var data = Data()
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"Mp3-App.png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(self.avatarView.image!.pngData()!)
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
                if error == nil{
                    let jsonDecoder = JSONDecoder()
                    let dataInfo = try? jsonDecoder.decode(Result.self, from: responseData! )
                    if dataInfo?.result == 1{
                        self.newImage = dataInfo?.data
                        self.saveImage()
                    }
                    
                }
            }).resume()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        action.addAction(save)
        action.addAction(cancel)
        self.present(action, animated: true,completion: nil)
    }
    func saveImage(){
        let url = URL(string: domainName + "account/updateAvatar")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "token=" + token + "&avatarImage=" + newImage
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
            let _ = try? jsonDecoder.decode(Result.self, from: data)
        }.resume()
    }
}
extension DashboardViewController:Update_Res_delegate{
    func message(a: String) {
        let aleart = UIAlertController(title: "Notification", message: a, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        aleart.addAction(ok)
        present(aleart,animated: true)
    }
    
    
}

