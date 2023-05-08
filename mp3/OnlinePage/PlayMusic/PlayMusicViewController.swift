//
//  PlayMusicViewController.swift
//  mp3
//
//  Created by Thinh on 31/03/2023.
//

import UIKit
import AVFoundation
import AVFAudio
import SDWebImage
class PlayMusicViewController: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbSinger: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var download = false;
    var timer : Timer? {
        didSet{
            oldValue?.invalidate()
        }
    }
    var i : Int = 0
    var indexPlay : Int = 0
    var n : Int = 1
    var arrayRecent :Array<Int> = []
    var music : MusicInfor!
    var musicAPI:MusicApiService?
    init( musicAPI: MusicApiService) {
        self.musicAPI = musicAPI
        super.init(nibName: "PlayMusicViewController", bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var arrayMusic:Array<MusicInfor> = []
    var player : AVPlayer?
    var statusRepeat:Bool = false
    var timerSlider:Timer? {
        didSet{
            oldValue?.invalidate()
        }
    }
    @IBOutlet weak var buttonDownload: UIButton!
    @IBOutlet weak var lbInfor: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var playedTime: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var imgview: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var btnRepeatOne: UIButton!
    deinit{
        print("play music deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getMusic()
        getArrayMusic()
        buttonPlayMusic()
        imgMusic()
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        slider.isContinuous = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        music = nil
        musicAPI = nil
        timerSlider = nil
        timer = nil
        btnPlay.setImage(UIImage(named: "play"), for: .normal)
        player?.pause()
        NotificationCenter.default.removeObserver(self)
    }
    func buttonPlayMusic(){
        buttonDownload.setImage(UIImage(named: "download-4"), for: .normal)
        buttonDownload.setTitle("", for: .normal)
        btnPlay.setTitle("", for: .normal)
        btnBack.setTitle("", for: .normal)
        btnNext.setTitle("", for: .normal)
    }
    func imgMusic(){
        imgview.layer.borderWidth = 1
        imgview.layer.borderColor = UIColor.black.cgColor
        imgview.layer.cornerRadius = imgview.frame.size.width/2
        imgview.clipsToBounds = true
    }
    @IBAction func playButtonTapped(_ sender: Any) {
        if player!.rate == 0 {
            player?.play()
            timerImage()
            btnPlay.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player?.pause()
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
            timerImage()
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
            getMusicInfor(music: arrayMusic[index])
            player?.play()
        }else{
            indexPlay += 1
            if indexPlay == arrayRecent.count{
                indexPlay = 0
            }
            let index = arrayRecent[indexPlay]
            getMusicInfor(music: arrayMusic[index])
            player?.pause()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    @IBAction func btnBackMusic(_ sender: Any) {
        currentTime.text = "00:00"
        if(player?.rate != 0 ){
            indexPlay -= 1
            if indexPlay < 0{
                indexPlay = arrayRecent.count - 1
            }
            let index = arrayRecent[indexPlay]
            getMusicInfor(music: arrayMusic[index])
            player?.play()
        }else{
            indexPlay -= 1
            if indexPlay < 0{
                indexPlay = arrayRecent.count - 1
            }
            let index = arrayRecent[indexPlay]
            getMusicInfor(music: arrayMusic[index])
            player?.pause()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc func itemDidPlayToEndTime(notification: Notification) {
        if (notification.object as? AVPlayerItem) == self.player?.currentItem {
            if !statusRepeat {
                indexPlay += 1
                let index = arrayRecent[indexPlay]
                getMusicInfor(music: arrayMusic[index])
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
        musicAPI?.getMusicByCategoryId(categoryId: music.idCategory, completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            self.arrayMusic = value.data
            let indexOfMusic = self.arrayMusic.firstIndex(where: { $0._id == self.music._id })
            self.arrayRecent.append(indexOfMusic!)
            for index in 0...self.arrayMusic.count - 1 {
                self.arrayRecent.append(index)
            }
        })
    }
    
    func getMusic(){
        getMusicInfor(music: music)
        player?.play()
        timerImage()
        btnPlay.setImage(UIImage(named: "pause"), for: .normal)
        player?.play()
        
    }
    func getMusicInfor(music : MusicInfor){
        getImage(music: music)
        let ex = (music.file!)
        let newString = ex.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        lbInfor.text = music.nameAlbum
        lbSinger.text = music.nameSinger!
        let url1 = URL(string: newString)
        
        timerSlider = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        player = AVPlayer(url: url1!)
        getDuarationAndCurrent(player: player!)
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
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            guard let self = self, let player = self.player else{
                return
            }
            if player.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(player.currentTime());
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
    
    
    @IBAction func btnDownLoad(_ sender: Any) {
        if !download {
            let action = UIAlertController(title: "Notification", message: "Do you want to download?", preferredStyle: .actionSheet)
            let download = UIAlertAction(title: "Download File", style: .default) { e in
                let newString = self.music.file!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                if let audioUrl = URL(string: "http://localhost:3000/upload/music/" + newString){
                    // then lets create your document folder url
                    let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    // lets create your destination file url
                    
                    let mp3Path = documentsDirectoryURL.appendingPathComponent("MP3_Project", isDirectory: true)
                    let destinationUrl = mp3Path.appendingPathComponent(audioUrl.lastPathComponent)
                    
                    // to check if it exists before downloading it
                    if FileManager.default.fileExists(atPath: destinationUrl.path) {
                        print("The file already exists at path")
                        
                        // if the file doesn't exist
                    } else {
                        
                        // you can use NSURLSession.sharedSession to download the data asynchronously
                        URLSession.shared.downloadTask(with: audioUrl) {[weak self] location, response, error in
                            guard let location = location, error == nil else { return }
                            do {
                                // after downloading your file you need to move it to your destination url
                                try FileManager.default.moveItem(at: location, to: destinationUrl)
                                self?.download = true
                                print("File moved to documents folder")
                                DispatchQueue.main.async {
                                    self?.buttonDownload.setImage(UIImage(named: "download-3"), for: .normal)
                                }
                            } catch {
                                print(error)
                            }
                        }.resume()
                    }
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            action.addAction(cancel)
            action.addAction(download)
            self.present(action, animated: true)
            
        }
    }
    func timerImage(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { [weak self] tm in
            self?.i += 1
            self?.imgview.transform = CGAffineTransform(rotationAngle: CGFloat(Double(self!.i) * Double.pi/180))
        })
        
    }
    func getImage(music:MusicInfor){
        self.imgview.sd_setImage(with: URL(string: music.image), placeholderImage: UIImage(named: "placeholder.png"))
    }
}


