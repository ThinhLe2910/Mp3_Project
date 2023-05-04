//
//  PlayMusicViewController.swift
//  mp3
//
//  Created by Thinh on 31/03/2023.
//

import UIKit
import AVFoundation
import AVFAudio

class PlayMusicViewController: UIViewController {
    var timer : Timer!
    var i : Int = 0
    var indexPlay : Int = 0
    var n : Int = 1
    var arrayRecent :Array<Int> = []
    var music : MusicInfor!
    var arrayMusic:Array<MusicInfor> = []
    var arrayMore:Array<String> = ["Information"]
    var player : AVPlayer?
    var domainName:String!
    var statusRepeat:Bool = false
    @IBOutlet weak var lbInfor: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var playedTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    
    @IBOutlet weak var btnRepeatOne: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        domainName = "http://localhost:3000/"
        getMusic()
        getArrayMusic()
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        slider.isContinuous = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        btnPlay.setImage(UIImage(named: "play"), for: .normal)
        player?.pause()
    }
    @IBAction func playButtonTapped(_ sender: Any) {
        if player!.rate == 0 {
            player?.play()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { tm in
                self.i += 5
                self.imgview.transform = CGAffineTransform(rotationAngle: CGFloat(Double(self.i) * Double.pi/180))
            })
            btnPlay.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player?.pause()
            timer.invalidate()
            timer = nil
            btnPlay.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
    @IBAction func controlTime(_ sender: UISlider) {
        let seconds : Int64 = Int64(sender.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { tm in
                self.i += 5
                self.imgview.transform = CGAffineTransform(rotationAngle: CGFloat(Double(self.i) * Double.pi/180))
            })
            btnPlay.setImage(UIImage(named: "pause"), for: .normal)
            player?.play()
        }
    }
    @IBAction func btnNextSong(_ sender: Any) {
        currentTime.text = "00:00"
        if(player?.rate != 0 ){
            indexPlay += 1
            if indexPlay == arrayRecent.count{
                indexPlay = 0
            }
            let index = arrayRecent[indexPlay]
            let ex = (domainName + "upload/music/" + arrayMusic[index].file!)
            let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            lbInfor.text = arrayMusic[index].nameAlbum + " - " + arrayMusic[index].nameSinger!
            let url1 = URL(string: newString)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            player = AVPlayer(url: url1!)
            getDuarationAndCurrent(player: player!)
            player?.play()
        }else{
            indexPlay += 1
            if indexPlay == arrayRecent.count{
                indexPlay = 0
            }
            let index = arrayRecent[indexPlay]
            let ex = (domainName + "upload/music/" + arrayMusic[index].file!)
            let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            lbInfor.text = arrayMusic[index].nameAlbum + " - " + arrayMusic[index].nameSinger!
            let url1 = URL(string: newString)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            player = AVPlayer(url: url1!)
            getDuarationAndCurrent(player: player!)
            player?.pause()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    
    @IBAction func btnBackMusic(_ sender: Any) {
        currentTime.text = "00:00"
        if(player?.rate == 0 ){
            indexPlay -= 1
            if indexPlay < 0{
                indexPlay = arrayRecent.count - 1
            }
            let index = arrayRecent[indexPlay]
            let ex = (domainName + "upload/music/" + arrayMusic[index].file!)
            let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            lbInfor.text = arrayMusic[index].nameAlbum + " - " + arrayMusic[index].nameSinger!
            let url = URL(string: newString)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            player = AVPlayer(url: url!)
            getDuarationAndCurrent(player: player!)
            player?.play()
        }else{
            indexPlay -= 1
            if indexPlay < 0{
                indexPlay = arrayRecent.count - 1
            }
            let index = arrayRecent[indexPlay]
            let ex = (domainName + "upload/music/" + arrayMusic[index].file!)
            let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            lbInfor.text = arrayMusic[index].nameAlbum + " - " + arrayMusic[index].nameSinger!
            let url = URL(string: newString)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            player = AVPlayer(url: url!)
            getDuarationAndCurrent(player: player!)
            player?.pause()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    @objc func itemDidPlayToEndTime(notification: Notification) {
        print("itemDidPlayToEndTime - run")
        if (notification.object as? AVPlayerItem) == self.player?.currentItem {
            if !statusRepeat {
                indexPlay += 1
                let index = arrayRecent[indexPlay]
                let ex = (domainName + "upload/music/" + arrayMusic[index].file!)
                let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                lbInfor.text = arrayMusic[index].nameAlbum + " - " + arrayMusic[index].nameSinger!
                let url1 = URL(string: newString)
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
                player = AVPlayer(url: url1!)
                getDuarationAndCurrent(player: player!)
                player?.play()
            }else{
                player?.seek(to: .zero)
                player?.play()
            }
        }
        }
        @objc func updateSlider() {
            if player != nil {
                let currentTimeBySecond = CMTimeGetSeconds((player!.currentTime()))
                slider.value = Float(currentTimeBySecond)
            }
        }
        func getArrayMusic(){
            let url = URL(string: domainName + "music/categoryId")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let paramString = "categoryId=" + music.idCategory
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
                let dataInfo = try? jsonDecoder.decode(Music_Result.self, from: data)
                if(dataInfo?.result == 1){
                    self.arrayMusic = dataInfo!.data
                    let indexOfMusic = self.arrayMusic.firstIndex(where: { $0._id == self.music._id })
                    self.arrayRecent.append(indexOfMusic!)
                    for _ in 1...20 {
                        let index = Int.random(in: 0..<self.arrayMusic.count)
                        self.arrayRecent.append(index)
                    }
                }
            }.resume()
        }
        
        func getMusic(){
            let ex = (domainName + "upload/music/" + music.file! )
            let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            lbInfor.text = music.nameAlbum + " - " + music.nameSinger!
            arrayMusic.append(music)
            let url = URL(string: newString)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            player = AVPlayer(url: url!)
            
            getDuarationAndCurrent(player: player!)
            player?.play()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { tm in
                self.i += 5
                self.imgview.transform = CGAffineTransform(rotationAngle: CGFloat(Double(self.i) * Double.pi/180))
            })
            btnPlay.setImage(UIImage(named: "pause"), for: .normal)
            player?.play()
            
        }
        
        func getDuarationAndCurrent(player : AVPlayer){
            guard let duration = player.currentItem?.asset.duration else {
                return
            }
            //duration time
            let durationBySecond = CMTimeGetSeconds(duration)
            let min = Int(durationBySecond) / 60
            let second = Int(durationBySecond) % 60
            if min <= 9{
                if second <= 9{
                    self.playedTime.text = "0\(min):0\(second)"
                }else{
                    self.playedTime.text = "0\(min):\(second)"
                }
            }else if (second <= 9 && min > 9){
                self.playedTime.text = "\(min):0\(second)"
            }
            self.slider.maximumValue = Float(durationBySecond)
            
            //current Time
            player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay {
                    let currentTime = CMTimeGetSeconds(self.player!.currentTime());
                    let min = Int(currentTime) / 60
                    let second = Int(currentTime) % 60
                    if min <= 9{
                        if second <= 9{
                            self.currentTime.text = "0\(min):0\(second)"
                        }else{
                            self.currentTime.text = "0\(min):\(second)"
                        }
                    }else if (second <= 9 && min > 9){
                        self.currentTime.text = "\(min):0\(second)"
                    }
                    
                }
            }
        }
        
        @IBAction func btnRepeatOne(_ sender: UIButton) {
            n += 1
            if(n % 2 == 0){
                statusRepeat = true
                btnRepeatOne.setImage(UIImage(named: "repeat-on"), for: .normal)
            }else{
                statusRepeat = false
                btnRepeatOne.setImage(UIImage(named: "repeat-off"), for: .normal)
            }
        }
    }
    
