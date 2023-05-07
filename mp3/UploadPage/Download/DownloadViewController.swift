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
}
class DownloadViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listData:[Data] = []
    deinit{
        print("Download deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getListUrl()
        tableView.register(UINib(nibName: "DownloadTableViewCell", bundle: nil), forCellReuseIdentifier: DownloadTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getListUrl(){
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var mp3Path = documentsDirectoryURL.appendingPathComponent("MP3_Project", isDirectory: true)
        print(mp3Path)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: mp3Path, includingPropertiesForKeys: nil)
            fileURLs.forEach { file in
                
                var duration:String = ""
                var sizeInMB :Double = 0
                
                getDurationTime(file: file) { value in
                    duration = value
                }
                
                getSizeFile(file: file) { value in
                    sizeInMB = value
                }
                
                listData.append(Data(path: file.lastPathComponent, size: sizeInMB, duration: String(duration)))
            }
        } catch {
            print("Error while enumerating files \(mp3Path.path): \(error.localizedDescription)")
        }
    }
    
    func getSizeFile(file:URL,completionHandler: @escaping(Double)->Void){
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: file.path)
            
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                let sizeInMB = size.doubleValue / 1000000
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
        return cell
    }
    
    
}
