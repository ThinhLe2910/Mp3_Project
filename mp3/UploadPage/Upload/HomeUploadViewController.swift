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
    var domainName  = "http://localhost:3000/"
    var nameFile :String!
    let dropDown = DropDown()
    var newMusic :String!
    var indexInarrayCate :Int?
    var arrayCate : Array<CategoryInfor> = []
    @IBOutlet weak var clickUpload: UIButton!
    var arr: Array<String> = []
    var choose:String!
    var statusUpload:Bool = true
    var statusUpdate:Bool = true
    var delegate:Update_Res_delegate?
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lbMP3: UIButton!
    @IBOutlet weak var txtKindOfMusic: UITextField!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var txtNameSinger: UITextField!
    @IBOutlet weak var txtNameSong: UITextField!
    var file:String=""
    var token:String!
    var music : MusicInfor?
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")!
        btnUpdate.isHidden = statusUpdate
        clickUpload.isHidden = statusUpload
        getCategory()
        
        let cateogory = music?.Category
        lbTitle.text = cateogory?[0].name ??  "Choose kind of music"
        txtNameSinger.text = music?.nameSinger
        txtNameSong.text = music?.nameAlbum
        btnUpload.setTitle(music?.file, for: .normal)
        newMusic = music?.file

        
        dropDown.anchorView = viewdropDown
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.topOffset = CGPoint(x: 0, y:-((dropDown.anchorView?.plainView.bounds.height)!))
        dropDown.direction = .bottom
        
    }
    @IBAction func btnUpload(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to create new music ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default,handler: { action in
            if(self.indexInarrayCate == nil){
                let aleart = UIAlertController(title: "Notification", message: "Please choose kind of music!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                aleart.addAction(ok)
                self.present(aleart,animated: true)
            }else{
                let url = URL(string: self.domainName + "music/add")
                let nameSong = self.txtNameSong.text!
                let nameSinger = self.txtNameSinger.text!
                let idCategory = self.arrayCate[self.indexInarrayCate!]._id
                let newMusic = self.newMusic!
                var request = URLRequest(url: url!)
                let paramString = "token=" + self.token! + "&idCategory=" + idCategory + "&nameAlbum=" + nameSong + "&nameSinger=" + nameSinger + "&file=" + newMusic
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
                        if(dataInfo?.result == 1){
                            self.notiSuccessfully(a:dataInfo?.message ?? "")
                        }else{
                            let aleart = UIAlertController(title: "Notification", message: dataInfo?.message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default)
                            aleart.addAction(ok)
                            self.present(aleart,animated: true)
                        }
                    }
                }.resume()
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
        let url = URL(string: domainName + "category/list")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = response as?  HTTPURLResponse,
                  error == nil else{
                print("Error from server", error ?? "Error is underfind")
                return
            }
            let jsonDecoder = JSONDecoder()
            let dataInfo = try? jsonDecoder.decode(Category_Result.self, from: data)
            if dataInfo?.result == 1{
                self.arrayCate = dataInfo!.data
                for e in dataInfo!.data{
                    self.arr.append(e.name)
                }
                self.dropDown.dataSource  = self.arr
            }
        }.resume()
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
        alert.addAction(UIAlertAction(title: "Update", style: .default,handler: { action in
            let url = URL(string: self.domainName + "music/update")
            if(self.indexInarrayCate == nil){
                self.indexInarrayCate = self.arr.firstIndex(of: (self.music?.Category![0].name)!)
            }
            let nameSong = self.txtNameSong.text!
            let nameSinger = self.txtNameSinger.text!
            let idCategory = self.arrayCate[self.indexInarrayCate!]._id
            let _id = self.music!._id
            let music = self.newMusic!
            var request = URLRequest(url: url!)
            let paramString = "token=" + self.token! + "&idCategory=" + idCategory + "&nameAlbum=" + nameSong + "&nameSinger=" + nameSinger + "&file=" + music + "&_id=" + _id
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
                    if(dataInfo?.result == 1){
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.message(a: dataInfo?.message ?? "")
                    }else{
                        let aleart = UIAlertController(title: "Notification", message: dataInfo?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        aleart.addAction(ok)
                        self.present(aleart,animated: true)
                    }
                    
                }
            }.resume()
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
        if let url = urls.first {
            AF.upload(multipartFormData: { part in
                part.append(url, withName: "music")
            }, to: domainName + "uploadMusic" ).response { response in
                switch response.result {
                case .success(let data):
                    do {
                        let res = try JSONDecoder().decode(Result.self, from: data!)
                        self.newMusic = res.data
                        self.lbMP3.setTitle(res.data, for: .normal)
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
}
