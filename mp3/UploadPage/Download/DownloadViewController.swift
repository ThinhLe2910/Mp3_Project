//
//  DownloadViewController.swift
//  mp3
//
//  Created by Thinh on 04/05/2023.
//

import UIKit
import Foundation
import AVFoundation

struct Data{
    var path : String
    var size : Double
    var duration :String
    var created : String
}
class DownloadViewController: UIViewController {
    var dateFormatter:DateFormatter?
    @IBOutlet weak var tableView: UITableView!
    var listData:[Data] = []
    var date:String?
    deinit{
        print("Download deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter = DateFormatter()
        getListUrl()
        organizeArray()
        tableView.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: DownloadTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListUrl()
    }
    func getListUrl(){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var mp3Path = documentsDirectoryURL.appendingPathComponent("MP3_Project", isDirectory: true)

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: mp3Path, includingPropertiesForKeys: nil)
            fileURLs.forEach { file in
                do{
                    let resources = try file.resourceValues(forKeys: [.creationDateKey])
                    let creationDate = resources.creationDate!
                    dateFormatter?.dateFormat = "MM/dd/yyyy HH:mm"
                    date = dateFormatter!.string(from: creationDate )
                }catch{}
                guard let date = date else{
                    return
                }
                var duration:String = ""
                var sizeInMB :Double = 0
                
                getDurationTime(file: file) { value in
                    duration = value
                }
                
                getSizeFile(file: file) { value in
                    sizeInMB = value
                }
                
                listData.append(Data(path: file.lastPathComponent, size: sizeInMB, duration: String(duration), created: date))
            }
        } catch {
            print("Error while enumerating files \(mp3Path.path): \(error.localizedDescription)")
        }
    }
    func organizeArray(){
        var a:Data?
        for _ in 0..<listData.count {
            for j in 0..<listData.count-1{
                if listData[j].created < listData[j+1].created{
                    a = listData[j]
                    listData[j] = listData[j+1]
                    listData[j+1] = a!
                }
            }
        }
    }
    func getSizeFile(file:URL,completionHandler: @escaping(Double)->Void){
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: file.path)
            
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                let sizeInMB = size.doubleValue / 1000000.0
                completionHandler(sizeInMB)
            }
        }catch{}
    }
    
    func getDurationTime(file:URL,completionHandler: @escaping(String)->Void){
        var durationGet:String = ""
        let asset = AVAsset(url: file)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        let min = Int(durationTime) / 60
        let second = Int(durationTime) % 60
        if min <= 9{
            if second <= 9{
                durationGet = "0\(min):0\(second)"
            }else{
                durationGet = "0\(min):\(second)"
            }
        }else if (second <= 9 && min > 9){
            durationGet = "\(min):0\(second)"
        }
        completionHandler(durationGet)
    }
}
extension DownloadViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableViewCell.description(), for: indexPath) as! DownloadTableViewCell
        cell.lbSong.text = listData[indexPath.row].path
        cell.lbSong.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.lbSong.numberOfLines = 0
        cell.lbSize.text = String(format:"%.2f",listData[indexPath.row].size) + " MB"
        cell.lbDuration.text = listData[indexPath.row].duration
        cell.lbCreated.text = listData[indexPath.row].created
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
