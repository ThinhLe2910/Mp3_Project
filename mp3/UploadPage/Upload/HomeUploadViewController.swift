//
//  HomeUploadViewController.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import UIKit
import Alamofire
import MobileCoreServices
import UniformTypeIdentifiers
import DropDown
protocol Update_Res_delegate{
    func message(a:String)
}
class HomeUploadViewController: UIViewController {
    @IBOutlet weak var viewdropDown: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    var nameFile :String!
    let dropDown = DropDown()
    var newImageMusic:String!
    var newMusic :String!
    var indexInarrayCate :Int?
    var arrayCate : Array<CategoryInfor> = []
    @IBOutlet weak var clickUpload: UIButton!
    var arr: Array<String> = []
    var choose:String!
    var statusUpload:Bool = true
    var statusUpdate:Bool = true
    var delegate:Update_Res_delegate?
    var musicAPI:MusicApiService
    
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lbMP3: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var txtNameSinger: UITextField!
    @IBOutlet weak var imgMusic: UIImageView!
    @IBOutlet weak var txtNameSong: UITextField!
    var file:String=""
    var token:String!
    var music : MusicInfor?
    
    var categoryAPI:CategoryApiService
    
    init(categoryAPI: CategoryApiService, musicAPI : MusicApiService) {
        self.musicAPI = musicAPI
        self.categoryAPI = categoryAPI
        super.init(nibName: "HomeUploadViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("upload/update deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")!
        btnUpdate.isHidden = statusUpdate
        clickUpload.isHidden = statusUpload
        getCategory()
        getCurrentMusic()
        buttonDropDown()
    }
    
    func buttonDropDown(){
        btnDropDown.setTitle("", for: .normal)
        dropDown.anchorView = viewdropDown
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-((dropDown.anchorView?.plainView.bounds.height)!))
        dropDown.direction = .bottom
    }
    
    func getCurrentMusic(){
        if (music != nil) {
            let cateogory = music?.Category
            lbTitle.text = cateogory?[0].name ??  "Choose kind of music"
            txtNameSinger.text = music?.nameSinger
            txtNameSong.text = music?.nameAlbum
            btnUpload.setTitle(music?.nameAlbum, for: .normal)
            newImageMusic = music?.image
            newMusic = music?.file
            self.imgMusic.sd_setImage(with: URL(string: newImageMusic), placeholderImage: UIImage(named: "placeholder.png"))
            self.imgMusic.contentMode = .scaleAspectFit
        }
    }
    @IBAction func btnUpload(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to create new music ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: { [weak self] action in
            guard let self = self, let newMusic = self.newMusic else{
                return
            }
            if(self.indexInarrayCate == nil){
                let aleart = UIAlertController(title: "Notification", message: "Please choose kind of music!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                aleart.addAction(ok)
                self.present(aleart,animated: true)
            }else{
                let nameSong = self.txtNameSong.text!
                let nameSinger = self.txtNameSinger.text!
                let idCategory = self.arrayCate[self.indexInarrayCate!]._id
                self.musicAPI.addMusic(token: self.token,image : self.newImageMusic,idCategory: idCategory, nameSong: nameSong, nameSinger: nameSinger, newMusic: newMusic, completionHandler: { [weak self] value in
                    guard let self = self else{
                        return
                    }
                    DispatchQueue.main.async {
                        if(value.result == 1){
                            self.notiSuccessfully(a:value.message)
                        }else{
                            let aleart = UIAlertController(title: "Notification", message: value.message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default)
                            aleart.addAction(ok)
                            self.present(aleart,animated: true)
                        }
                    }
                })
            }
        }))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func upload(_ sender: Any) {
        let types = [kUTTypeAudio]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    func getCategory(){
        categoryAPI.getListCategory(completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            if value.result == 1{
                self.arrayCate = value.data
                for e in value.data{
                    self.arr.append(e.name)
                }
                self.dropDown.dataSource  = self.arr
            }
        })
    }
    
    @IBAction func clickDropdown(_ sender: Any) {
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            lbTitle.text = arr[index]
            choose = arr[index]
            indexInarrayCate = index
        }
        dropDown.show()
    }
    
    @IBAction func clickUpdate(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to update music ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Update", style: .default,handler: { [weak self] action in
            guard let self = self ,let music = self.music,let newMusic = self.newMusic ,let Category = music.Category else{
                return
            }
            if(self.indexInarrayCate == nil){
                self.indexInarrayCate = self.arr.firstIndex(of: Category[0].name)
            }
            let nameSong = self.txtNameSong.text!
            let nameSinger = self.txtNameSinger.text!
            let idCategory = self.arrayCate[self.indexInarrayCate!]._id
            let id = music._id
            self.musicAPI.updateMusic(token: self.token,image:self.newImageMusic,id: id, idCategory: idCategory, nameSong: nameSong, nameSinger: nameSinger, music: newMusic, completionHandler: { [weak self] value in
                guard let self = self else{
                    return
                }
                DispatchQueue.main.async {
                    if(value.result == 1){
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.message(a: value.message)
                    }else{
                        let aleart = UIAlertController(title: "Notification", message: value.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        aleart.addAction(ok)
                        self.present(aleart,animated: true)
                    }
                }
            })
        }))
        self.present(alert, animated: true)
    }
    func notiSuccessfully(a:String){
        let alert = UIAlertController(title: "Message", message: a, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
extension  HomeUploadViewController : UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        musicAPI.uploadMusic(urls: urls, completionHanlder: { [weak self] value in
            guard let self = self else{
                return
            }
            DispatchQueue.main.async {
                self.newMusic = value.data
                self.lbMP3.setTitle(value.data, for: .normal)
            }
        })
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
}
extension HomeUploadViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBAction func clickImage(_ sender: Any){
        let action = UIAlertController(title: "Notification", message: "Choose Avatar", preferredStyle: .actionSheet)
        let choosePhoto = UIAlertAction(title: "Choose Photo In Library", style: .default) {[weak self] e in
            guard let self = self else{
                return
            }
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
        if let img = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.imageURL.rawValue)] as? URL{
            imgMusic.image = UIImage(contentsOfFile: img.path)
            imgMusic.contentMode = .scaleAspectFit
            self.musicAPI.uploadMusicImage(url: img, completionHandler: { [weak self] value in
                guard let self = self else{
                    return
                }
                DispatchQueue.main.async {
                    if value.result == 1{
                        self.newImageMusic = value.data
                    }
                }
            })
        }
        self.dismiss(animated: true)
    }
}
