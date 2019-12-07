
//
//  AudioViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/27/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import FirebaseCore
import FirebaseStorage
import FirebaseDatabase
import UserNotifications
import AudioToolbox
import AVFoundation
import Kingfisher
import MediaPlayer
import CoreMedia

var audiofiles = [String]()
var headlines = [String]()

var playerItem: AVPlayerItem?

var duration = Double()
var durationcmttime = CMTime()
var salesurl = String()
var audio = Bool()

class AudioViewController: UIViewController {
   
    var startTime: TimeInterval?

        static let sharedAudioPlayer = AudioViewController()

        public var book: Book?

        @IBOutlet weak var progressView: UIProgressView!
        @IBAction func tapRead(_ sender: Any) {
        }
        @IBOutlet weak var tapsnippettext: UILabel!

        var x2speed = Bool()

        @IBOutlet weak var tapspeed: UIButton!

        @IBAction func tapNewSpeed(_ sender: Any) {

            if x2speed {

                tapspeed.setTitle("1x", for: .normal)

                player?.rate = 1.0
                x2speed = false

            } else {

                tapspeed.setTitle("1.5x", for: .normal)

                player?.rate = 1.5
                x2speed = true

            }
        }

        @IBOutlet weak var backimage: UIImageView!

        @IBAction func tapPrevious(_ sender: Any) {

            player?.pause()

            tapplayorpause.setBackgroundImage(UIImage(named: "Pause"), for: .normal)

            updater?.invalidate()

            previouscount()

        }
        @IBAction func tapPlayOrPause(_ sender: Any) {

            if player?.rate == 0 {

                updater = CADisplayLink(target: self, selector: #selector(AudioViewController.trackAudio))
                updater?.frameInterval = 1
                updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

                player!.play()

                tapplayorpause.setBackgroundImage(UIImage(named: "Pause"), for: .normal)


            } else {

                player?.pause()
                tapplayorpause.setBackgroundImage(UIImage(named: "Play"), for: .normal)

                updater?.invalidate()

            }
        }

        @IBOutlet weak var currentTimeLabel: UILabel!

        @IBOutlet weak var durationlabel: UILabel!

        var doublect = Double()

        func setupRemoteTransportControls() {
            // Get the shared MPRemoteCommandCenter
            let commandCenter = MPRemoteCommandCenter.shared()

            // Add handler for Play Command
            commandCenter.playCommand.addTarget { [unowned self] _ in

    //            if player?.rate == 0.0 {
                    player?.play()
                    return .success
    //            }
    //            return .commandFailed
            }

            // Add handler for Pause Command
            commandCenter.pauseCommand.addTarget { [unowned self] _ in

    //            if player?.rate > 0 {

                    player?.pause()
                    return .success

    //            }
    //            return .commandFailed
            }

            commandCenter.nextTrackCommand.addTarget { [unowned self] _ in

             
                    //            let variantindex = 5

  
                return .success
            }

            commandCenter.previousTrackCommand.addTarget { [unowned self] _ in
                updater?.invalidate()

                    self.previouscount()
                    self.setupNowPlaying()

                    return .success
            }

            commandCenter.nextTrackCommand.isEnabled = true
            commandCenter.previousTrackCommand.isEnabled = true

            commandCenter.togglePlayPauseCommand.isEnabled = true
        }

    //    func setupNowPlaying(withPlaybackDuration playbackDuration: TimeInterval?, totalDuration: TimeInterval?) {
    //        // Define Now Playing Info
    //        var nowPlayingInfo = [String: Any]()
    //        nowPlayingInfo[MPMediaItemPropertyTitle] = self.trackInformation?.title
    //        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = self.trackInformation?.subtitle
    //
    //        if let image = UIImage(named: "lockscreen") {
    //            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in
    //                return image
    //            }
    //        }
    //
    //        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackDuration
    //        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = totalDuration
    //        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
    //
    //        // Set the metadata
    //        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    //    }

        func setupNowPlaying() {
            // Define Now Playing Info
            var nowPlayingInfo = [String: Any]()

            if headlines.count > 0 {
            nowPlayingInfo[MPMediaItemPropertyTitle] = headlines[counter]
            nowPlayingInfo[MPMediaItemPropertyArtist] = selectedauthor

            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = {

                if let elapsedTime = player?.currentTime().seconds {
                    return TimeInterval(exactly: elapsedTime)
                }

                return nil
            }()
            print("currenttime = \(nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime])")
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = {
                    return TimeInterval(exactly: duration)

            }()

            print("duratino = \(nowPlayingInfo[MPMediaItemPropertyPlaybackDuration])")

            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate

            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
        }

        func previouscount() {

            tapspeed.setTitle("1x", for: .normal)

            player?.rate = 1.0
            x2speed = false

            if counter == 0 {

            } else {
                counter -= 1

                UserDefaults.standard.setValue(counter, forKey: selectedbookid)

                if audiofiles.count > 0 {

                    if headlines[0].contains("Introduction:") {

                        if counter == 0 {

                            headlinelabel.text = headlines[counter]

                            if headlines[counter] == "Introduction:" {

                                headlinelabel.text = ""
                            }

                            chapterlabel.text = "Introduction"

                        } else {

                            headlinelabel.text = headlines[counter]
                            if headlines[counter] == "Introduction:" {

                                headlinelabel.text = ""
                            }

                            chapterlabel.text = "Note \(counter) / \(headlines.count-1)"

                        }

                    } else {

                        headlinelabel.text = headlines[counter]

                        chapterlabel.text = "Note \(counter+1) / \(headlines.count)"

                    }

                    progressView.progress = 0.0
                    loadselectedaudio()

                }

            }

        }

        var playtapped = Bool()

        @IBAction func tapBack(sender: AnyObject) {

            updater?.invalidate()

            player?.pause()
            
            self.dismiss(animated: true, completion: nil)
            
        }

        @IBAction func tapText(_ sender: Any) {

         

            self.performSegue(withIdentifier: "AudioToRead", sender: self)

        }

        override func viewDidDisappear(_ animated: Bool) {

            audio = false
            if player?.rate == 0 {

            } else {

            }
        }
        func nextcount() {

            tapspeed.setTitle("1x", for: .normal)

            player?.rate = 1.0
            x2speed = false

        

                if counter > audiofiles.count-2 {

                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()

                  

                    player?.pause()

                

                    self.performSegue(withIdentifier: "AudioToCompleted", sender: self)

                } else {

                    counter += 1

                    UserDefaults.standard.setValue(counter, forKey: selectedbookid)

               
                    if headlines[0].contains("Introduction:") {

                        if counter == 0 {

                            headlinelabel.text = headlines[counter]
                            if headlines[counter] == "Introduction:" {

                                headlinelabel.text = ""
                            }
                            chapterlabel.text = "Introduction"

                        } else {

                            headlinelabel.text = headlines[counter]
                            if headlines[counter] == "Introduction:" {

                                headlinelabel.text = ""
                            }
                            chapterlabel.text = "Note \(counter) / \(headlines.count-1)"

                        }

                    } else {

                        headlinelabel.text = headlines[counter]

                        chapterlabel.text = "Note \(counter+1) / \(headlines.count)"

                    }

                    progressView.progress = 0.0
                    loadselectedaudio()

                }

        }

    //    var player: AVAudioPlayer?

        var url = URL(string: "www.google.com")

        @objc func playerDidFinishPlaying() {

            if counter > audiofiles.count-2 {

                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()


                player?.pause()

         

                self.performSegue(withIdentifier: "AudioToCompleted", sender: self)

            } else {
             

                  
                    //            let variantindex = 5

             

                        updater?.invalidate()
                        self.setupNowPlaying()

                        nextcount()

                }

            }


        func loadselectedaudio() {


            url = URL(string: selectedurl)

    //

            playerItem = AVPlayerItem(url: url!)

    //        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
    //
            player!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)

            player?.automaticallyWaitsToMinimizeStalling = false

            player?.play()

            let playerLayer=AVPlayerLayer(player: player!)

            playerLayer.frame=CGRect(x: 0, y: 0, width: 10, height: 50)

            NotificationCenter.default.addObserver(self, selector: #selector(AudioViewController.playerDidFinishPlaying),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
          tapplayorpause.setBackgroundImage(UIImage(named: "Pause"), for: .normal)

        }

        @objc func trackAudio() {

            if player != nil {

            let dTotalSeconds = player?.currentTime()

            currentTimeLabel.text = dTotalSeconds?.durationText

            doublect = Double(CMTimeGetSeconds(dTotalSeconds!))

            print(doublect)

            print(duration)

            if doublect >= 1 {

                var normalizedTime = Float(doublect / duration )
                self.setupNowPlaying()

                self.progressView.progress = normalizedTime

                print(normalizedTime)

            } else {

            }

            }
        }

        @IBOutlet weak var tapplayorpause: UIButton!

        @IBOutlet weak var chapterlabel: UILabel!
        @IBOutlet weak var headlinelabel: UILabel!

        var playButton: UIButton?

        @IBOutlet var tapback: UIButton!
        override func viewDidAppear(_ animated: Bool) {

            if headlines.count > 0 {

                if headlines[0].contains("Introduction:") {

                    if counter == 0 {

                        headlinelabel.text = headlines[counter]

                        if headlines[counter] == "Introduction:" {

                            headlinelabel.text = ""
                        }
                        chapterlabel.text = "Introduction"

                    } else {

                        headlinelabel.text = headlines[counter]
                        if headlines[counter] == "Introduction:" {

                            headlinelabel.text = ""
                        }
                        chapterlabel.text = "Note \(counter) / \(headlines.count-1)"

                    }

                } else {

                    headlinelabel.text = headlines[counter]

                    chapterlabel.text = "Note \(counter+1) / \(headlines.count)"

                }

            }

            if player?.rate == 0 {

                tapplayorpause.setBackgroundImage(UIImage(named: "Play"), for: .normal)

            } else {

                tapplayorpause.setBackgroundImage(UIImage(named: "Pause"), for: .normal)

            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            ref = Database.database().reference()

            setupRemoteTransportControls()
            setupNowPlaying()
    //
    //        audiofiles.removeAll()
    //
    //        book = mostrecentlyselectedbook
    //
    //        print(book)
    //
    //        audiofiles = book?.summary.audio?.audioURLStrings ?? []
    //
    //        audiofiles.remove(at: 0)
    //
    //        audiofiles = audiofiles.filter { $0 != "x" }

            print(audiofiles)


            headlinelabel.text = selectedtitle

            var audioSession = AVAudioSession.sharedInstance()

            do {

                try audioSession.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])

            } catch {

                print(error)

            }

            self.startTime = Date().timeIntervalSince1970


                if player?.rate == 0 || player == nil {

                    loadselectedaudio()

                } else {

                        durationlabel.text = durationcmttime.durationText

                        updater = CADisplayLink(target: self, selector: #selector(AudioViewController.trackAudio))
                        updater?.frameInterval = 1
                        updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

                }


         
            var myurl = URL(string: selectedurl)


            playtapped = false
            x2speed = false

            // Do any additional setup after loading the view.
        }

        @objc func playButtonTapped(_ sender: UIButton) {

        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

            if keyPath == "status" {

                if player?.status == .readyToPlay {

                    print("ready to play")

                    let endTime = Date().timeIntervalSince1970
                    print(endTime - startTime!)

                    duration = {

                        if let asset = playerItem?.asset {

                            return CMTimeGetSeconds(asset.duration)

                        }

                        return 0.0
                    }()

                    durationcmttime  = playerItem?.asset.duration ?? CMTimeMake(value: 1, timescale: 10)

                    print(duration)

                    //
                    //                                        duration = CMTimeGetSeconds(audioDuration)
                    //

                    durationlabel.text = durationcmttime.durationText

    //                let dTotalSeconds = player?.currentTime()
    //
    //                currentTimeLabel.text = dTotalSeconds?.durationText

                    updater = CADisplayLink(target: self, selector: #selector(AudioViewController.trackAudio))
                    updater?.frameInterval = 1
                    updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

                    currentTimeLabel.text = "\(player?.currentTime)"


                }

            } else {

                print("not ready")

                player?.pause()

                tapplayorpause.setBackgroundImage(UIImage(named: "Pause"), for: .normal)

                updater?.invalidate()
            }

        }

        @IBOutlet weak var titlelabel: UILabel!

        @IBOutlet weak var authorlabel: UILabel!

        @IBOutlet weak var cover: UIImageView!
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

    }

    extension CMTime {
        var durationText: String {
            let totalSeconds = CMTimeGetSeconds(self)
            let hours: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 86400) / 3600)
            let minutes: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

            if hours > 0 {
                return String(format: "%i:%02i:%02i", hours, minutes, seconds)
            } else {
                return String(format: "%02i:%02i", minutes, seconds)
            }

        }
    }
