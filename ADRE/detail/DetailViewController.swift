//
//  DetailViewController.swift
//  ADRE
//
//  Created by youngwoo Choi on 08/05/2019.
//  Copyright © 2019 youngwoo Choi. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftGifOrigin
import Lottie

class DetailViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var detailMainView: UIView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var viewModal: UIView!
    @IBOutlet weak var viewModalSe: UIView!
    @IBOutlet weak var viewTitleModal: UIView!
    
    @IBOutlet weak var timePicerView: UIPickerView!
    @IBOutlet weak var timePicerViewSe: UIPickerView!
    
    @IBOutlet weak var currentTimer: UILabel!
    @IBOutlet weak var currentTimerSe: UILabel!

    @IBOutlet weak var settingBt: UIButton!
    @IBOutlet weak var settingBtSe: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewSe: UITextView!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerLabelSe: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelSe: UILabel!
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitleImageView: UIImageView!
    @IBOutlet weak var detailTitleImageView2: UIImageView!
    @IBOutlet weak var detailTitleImageView3: UIImageView!
    
    @IBOutlet weak var timerTitle: UILabel!
    @IBOutlet weak var timerTitleSe: UILabel!
    @IBOutlet weak var mainExitLabel: UILabel!
    @IBOutlet weak var mainExitLabelSe: UILabel!
    
    @IBOutlet weak var timeLIne: UIImageView!
    @IBOutlet weak var timerBt: UIImageView!
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var textViewLeft: NSLayoutConstraint!
    @IBOutlet weak var textViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var timerTitleTop: NSLayoutConstraint!
    @IBOutlet weak var timerTitleLeft: NSLayoutConstraint!
    @IBOutlet weak var pickerViewLeft: NSLayoutConstraint!
    @IBOutlet weak var timerLineLeft: NSLayoutConstraint!
    @IBOutlet weak var timerBtLeft: NSLayoutConstraint!
    @IBOutlet weak var settingBtLeft: NSLayoutConstraint!
    @IBOutlet weak var timerLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLeft: NSLayoutConstraint!
    @IBOutlet weak var exitButtonRight: NSLayoutConstraint!
    @IBOutlet weak var exitButtonTop: NSLayoutConstraint!
    @IBOutlet weak var exitIconTop: NSLayoutConstraint!
    @IBOutlet weak var textViewBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabelSeHeight: NSLayoutConstraint!
    @IBOutlet weak var mainExitLabelLeft: NSLayoutConstraint!
    
    // 1,5,10,20,30,45분 1,2,4,8 시간
    
    var timeArray = ["1 min", "5 min", "10 min", "30 min", "1 hour", "2 hour", "4 hour", "8 hour"]
    var musicNameArray = ["5.녹차밭(A)", "6.애월(A)", "8.공항(A)", "3.밤(A)", "9.사찰(A)", "7.사려니(A)", "2.우도(A)", "4.어판장(A)", "11.올레길(A)", "12.쇠소깍(A)", "10.폭포(A)"]
    var musicNameArrayStay = ["5.녹차밭(B)", "6.애월(B)", "8.공항(B)", "3.밤(B)", "9.사찰(B)", "7.사려니(B)", "2.우도(B)", "4.어판장(B)", "11.올레길(B)", "12.쇠소깍(B)", "10.폭포(B)"]

    var audioPlayer: AVAudioPlayer!
    var playerTimer: Timer!
    var mTimer : Timer!
    var time = 60
    var startTimer = false
    var settingB: String = "on"
    var audioState: String = "on"
    var backgoundState: String = "on"
    var checkMusic: Bool = true
    var musicStop = false
    var statePicker: Bool = true
    var preventButtonTouch = false
    var detailView3 = false
    var rowSelected = 3
    var detailData = ""
    var detailMusic = ""
    var buttonTi = ""
    var stayTour = ""
    var animationView = AnimationView()
    var detailImageView2 = UIImageView()
    var detailImageView3 = UIImageView()
    var count:Int = 0
    var musicNum:Int = 0
    var currentLocal = ""
    var deviceNum:Int = 0
    var lottieNum:Int = 0
    let aniView = UIView()
    var firstAni:Bool = true
    var modalState:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
//        print(locale)
        if locale.regionCode == nil{
            self.currentLocal = "KR"
        }else{
            self.currentLocal = locale.regionCode!
        }
        
        deviceScale()
        segueChange()
        fontSizeRe()
        viewModal.isHidden = true
        viewModalSe.isHidden = true
        currentTimer.isHidden = true
        currentTimerSe.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.modalState = true
        }
        
        print(Int(detailData)!)
        
        if stayTour == "on"{
            initPlayer()
        }else{
            musicStop = true
            playTotalAudioFile(Int(detailData)!)
        }
        
        audioPlayer.delegate = self
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                let paragraphStyleSe = NSMutableParagraphStyle()
                paragraphStyleSe.lineSpacing = 4
                let attributesSe = [NSAttributedString.Key.paragraphStyle: paragraphStyleSe]
                textViewSe.attributedText = NSAttributedString(string: textViewSe.text, attributes: attributesSe)
                textViewSe.textAlignment = .center
                textViewSe.textColor = UIColor(white: 1, alpha: 0.5)
                
                timePicerViewSe.dataSource = self
                timePicerViewSe.delegate = self
            default:
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 7
                let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
                textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
                textView.textAlignment = .center
                textView.textColor = UIColor(white: 1, alpha: 0.5)
                
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 1334:
                        textView.font = UIFont.systemFont(ofSize: 12)
                    default:
                        textView.font = UIFont.systemFont(ofSize: 14)
                    }
                }
                timePicerView.dataSource = self
                timePicerView.delegate = self
            }
        }
        
        textViewSe.contentOffset = CGPoint.zero
        textViewSe.contentOffset = CGPoint(x: 0, y: textView.contentOffset.y - 10)
        textView.contentOffset = CGPoint.zero
        textView.contentOffset = CGPoint(x: 0, y: textView.contentOffset.y - 10)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
//            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
        } catch {
            print(error)
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .duckOthers)
//            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
        } catch {
            print(error)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animationView.play()
    }
    
    func removeNotificationHand(){
//        print("핸드노티 삭제2")
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }

    @objc func handleInterruption(notification: NSNotification) {
//           print("handleInterruption2")
           guard let userInfo = notification.userInfo,
               let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
               let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                   return
           }
           switch type {
           case .began:
//                print("전화옴")
            self.audioPlayer.pause()
            case .ended:
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
//                    print("전화끔1")
                    self.audioPlayer.play()
                } else {
//                    print("전화끔2")
                    self.audioPlayer.play()
                }
            default :
               print("ended")
           }
    }

    @objc func timeLimit() {
        if time > 0{
            time -= 1
            let min = Int(time / 60)
            let sec = Int(time) % 60
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    if time > 3600 {
                        let getHour = Int(time / 3600)
                        let min = Int(min % 60)
                        if sec <= 9{
                            if min <= 9{
                                currentTimerSe.text = "0\(getHour):0\(min):0\(sec)"
                            }else{
                                currentTimerSe.text = "0\(getHour):\(min):0\(sec)"
                            }
                        }else{
                            if min <= 9{
                                currentTimerSe.text = "0\(getHour):0\(min):\(sec)"
                            }else{
                                currentTimerSe.text = "0\(getHour):\(min):\(sec)"
                            }
                            
                        }
                    }else{
                        if sec <= 9{
                            if min <= 9{
                                currentTimerSe.text = "0\(min):0\(sec)"
                            }else{
                                currentTimerSe.text = "\(min):0\(sec)"
                            }
                        }else{
                            if min <= 9{
                                currentTimerSe.text = "0\(min):\(sec)"
                            }else{
                                currentTimerSe.text = "\(min):\(sec)"
                            }
                        }
                    }
                    
                default:
                    if time > 3600 {
                        let getHour = Int(time / 3600)
                        let min = Int(min % 60)
                        if sec <= 9{
                            if min <= 9{
                                currentTimer.text = "0\(getHour):0\(min):0\(sec)"
                            }else{
                                currentTimer.text = "0\(getHour):\(min):0\(sec)"
                            }
                        }else{
                            if min <= 9{
                                currentTimer.text = "0\(getHour):0\(min):\(sec)"
                                currentTimerSe.text = "0\(getHour):0\(min):\(sec)"
                            }else{
                                currentTimer.text = "0\(getHour):\(min):\(sec)"
                            }
                            
                        }
                    }else{
                        if sec <= 9{
                            if min <= 9{
                                currentTimer.text = "0\(min):0\(sec)"
                            }else{
                                currentTimer.text = "\(min):0\(sec)"
                            }
                        }else{
                            if min <= 9{
                                currentTimer.text = "0\(min):\(sec)"
                            }else{
                                currentTimer.text = "\(min):\(sec)"
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tourMode() {
        detailMainView.alpha = 0.0
        segueChange()

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.viewModal.isHidden = true
            self.viewModalSe.isHidden = true
            self.detailMainView.alpha = 1.0
        }, completion: nil)
    }
    
    func playTotalAudioFile(_ index: Int) {
        do{
            if let path = Bundle.main.path(forResource: musicNameArray[index-1], ofType: "mp3"){
                let url = URL(fileURLWithPath: path)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.delegate = self
                audioPlayer.numberOfLoops = 0
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 1
                let time = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: time) {
                    self.audioPlayer.play()
                }
                if checkMusic == false{
                    tourMode()
                }
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    //  스테이 첫번째 음원
    func initPlayer(){
        do{
            if let path = Bundle.main.path(forResource: detailMusic, ofType: "mp3"){
                let url = URL(fileURLWithPath: path)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer.prepareToPlay()
                musicNum = Int(detailData)! - 1
                self.audioPlayer.play()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    //  스테이 두번째 음원
    func initPlayerRe(){
        do{
            if let path = Bundle.main.path(forResource: musicNameArrayStay[musicNum], ofType: "mp3"){
                let url = URL(fileURLWithPath: path)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.numberOfLoops = -1
                self.audioPlayer.play()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if musicStop == true {
            detailData =  String(Int(detailData)! + 1)
            if checkMusic == true{
                checkMusic = false
            }
            if detailData == "12"{
                detailData = "1"
            }
            
            audioPlayer.stop()
            playTotalAudioFile(Int(detailData)!)
        }
        
        if stayTour == "on"{
            initPlayerRe()
        }
    }
    
    @IBAction func showModally(_ sender: UIButton) {
        if modalState == true {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    viewModalSe.alpha = 0.0
                    viewModalSe.isHidden = false
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        self.viewModalSe.alpha = 1.0
                    }, completion: nil)
                    textViewSe.resignFirstResponder()
                    textViewSe.isEditable = false
                    textViewSe.isSelectable = false
                    if statePicker == true {
                        timePicerViewSe.selectRow(3, inComponent: 0, animated: false)
                    }
                default:
                    viewModal.alpha = 0.0
                    viewModal.isHidden = false
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                        self.viewModal.alpha = 1.0
                    }, completion: nil)
                    textView.resignFirstResponder()
                    textView.isEditable = false
                    textView.isSelectable = false
                    if statePicker == true {
                        timePicerView.selectRow(3, inComponent: 0, animated: false)
                    }
                }
            }
        }
    }
    @IBAction func goToMainSe(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        preventButtonTouch = true
        removeNotificationHand()
        self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
        let time = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.performSegue(withIdentifier: "goMain", sender: self)
            self.audioPlayer.stop()
            self.animationView.stop()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.detailImageView.removeFromSuperview()
            self.viewModal.isHidden = true
            self.currentTimer.isHidden = true
            self.viewModalSe.isHidden = true
            self.currentTimerSe.isHidden = true
        }
    }
    
    @IBAction func goToMain(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        preventButtonTouch = true
        removeNotificationHand()
        self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
        let time = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.performSegue(withIdentifier: "goMain", sender: self)
            self.audioPlayer.stop()
            self.animationView.stop()
            self.viewTitleModal.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.detailImageView.removeFromSuperview()
            self.viewModal.isHidden = true
            self.currentTimer.isHidden = true
            self.viewModalSe.isHidden = true
            self.currentTimerSe.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goMain" {
            let detailVC = segue.destination as! ViewController
            detailVC.buttonTi = buttonTi
            detailVC.stayTour = stayTour
        }
    }
    
    @IBAction func closeButtonModal(_ sender: Any) {
        viewModal.alpha = 1.1
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.viewModal.alpha = 0.0
        }, completion: { success in
            self.viewModal.isHidden = true
        })
    }
    
    @IBAction func showModallySe(_ sender: Any) {
        if modalState == true {
            viewModalSe.alpha = 1.1
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.viewModalSe.alpha = 0.0
            }, completion: { success in
                self.viewModalSe.isHidden = true
            })
        }
    }
    
    func endEdit() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                self.textViewSe.resignFirstResponder()
                self.textViewSe.isEditable = false
            default:
                self.textView.resignFirstResponder()
                self.textView.isEditable = false
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        label.text = timeArray[row]
        label.textColor = UIColor(white: 1.0, alpha: 0.8)
        label.textAlignment = .center
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                timePicerViewSe.subviews[1].backgroundColor = UIColor(white: 1.0, alpha: 0.0)
//                timePicerViewSe.subviews[2].backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            default:
                timePicerView.subviews[1].backgroundColor = UIColor(white: 1.0, alpha: 0.0)
//                timePicerView.subviews[2].backgroundColor = UIColor(white: 1.0, alpha: 0.0)
            }
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            rowSelected = row
        }
    }
    
    func timeIntervalToString(time: TimeInterval) -> String{
        let min = Int(time / 60)
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    @IBAction func settingButton(_ sender: Any) {
        if settingB == "on"{
            timerLabel.text = "타이머 중지"
            if currentLocal != "KR"{
                timerLabel.text = "타이머 중지".localized
            }
            timePicerView.isHidden = true
            currentTimer.isHidden = false
            if audioState == "off"{
                initPlayer()
            }
            if self.rowSelected != 100 {
                currentTimer.text = timeArray[rowSelected]
                statePicker = false
                if currentTimer.text == "1 min" || currentTimer.text == "01:00"{
                    currentTimer.text = "01:00"
                }else if currentTimer.text == "5 min" || currentTimer.text == "05:00"{
                    time = 300
                    currentTimer.text = "05:00"
                }else if currentTimer.text == "10 min" || currentTimer.text == "10:00"{
                    time = 600
                    currentTimer.text = "10:00"
//                }else if currentTimer.text == "" || currentTimer.text == "30 min" || currentTimer.text == "30:00"{
                }else if currentTimer.text == "30 min" || currentTimer.text == "30:00"{
                    time = 1800
                    currentTimer.text = "30:00"
                }else if currentTimer.text == "1 hour" || currentTimer.text == "01:00:00"{
                    time = 3600
                    currentTimer.text = "01:00:00"
                }else if currentTimer.text == "2 hour" || currentTimer.text == "02:00:00"{
                    time = 7200
                    currentTimer.text = "02:00:00"
                }else if currentTimer.text == "4 hour" || currentTimer.text == "04:00:00"{
                    time = 14400
                    currentTimer.text = "04:00:00"
                }else if currentTimer.text == "8 hour" || currentTimer.text == "08:00:00"{
                    time = 28800
                    currentTimer.text = "08:00:00"
                }else{
                    currentTimer.text = "01:00"
                }
                
                if let selectTime = self.currentTimer.text {
                    print(selectTime)
                }
                
                self.mTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    self.timeLimit()
                    if self.currentTimer.text == "00:00" {
//                        print(self.currentTimer.text!)
//                        print("진입")
                        self.audioPlayer.setVolume(0.0, fadeDuration: 0.5)
                        self.timePicerView.isHidden = false
                        self.currentTimer.isHidden = true
                        self.timerLabel.text = "타이머 시작"
                        if self.currentLocal != "KR"{
                            self.timerLabel.text = "타이머 시작".localized
                        }
                        
                        self.time = 60
                        self.mTimer.invalidate()
                        self.audioState = "off"
                        self.settingB = "on"
                        self.musicStop = false
                        let delaytime = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: delaytime) {
                            self.audioPlayer.stop()
                        }
                    }
                })
                
                settingB = "off"
            }
        }else if settingB == "off"{
            timePicerView.isHidden = false
            currentTimer.isHidden = true
            timerLabel.text = "타이머 시작"
            if currentLocal != "KR"{
                timerLabel.text = "타이머 시작".localized
            }
            
            mTimer.invalidate()
            time = 60
            settingB = "on"
            
        }
    }
    
    @IBAction func settingButtonSe(_ sender: Any) {
        if settingB == "on"{
            timerLabelSe.text = "타이머 중지"
            if currentLocal != "KR"{
                timerLabelSe.text = "타이머 중지".localized
            }
            timePicerViewSe.isHidden = true
            currentTimerSe.isHidden = false
            if audioState == "off"{
                initPlayer()
            }
            if self.rowSelected != 100 {
                currentTimerSe.text = timeArray[rowSelected]
                statePicker = false
                if currentTimerSe.text == "1 min" || currentTimerSe.text == "01:00"{
                    currentTimerSe.text = "01:00"
                }else if currentTimerSe.text == "5 min" || currentTimerSe.text == "05:00"{
                    time = 300
                    currentTimerSe.text = "05:00"
                }else if currentTimerSe.text == "10 min" || currentTimerSe.text == "10:00"{
                    time = 600
                    currentTimerSe.text = "10:00"
//                }else if currentTimerSe.text == "" || currentTimerSe.text == "30 min" || currentTimerSe.text == "30:00"{
                }else if currentTimerSe.text == "30 min" || currentTimerSe.text == "30:00"{
                    time = 1800
                    currentTimerSe.text = "30:00"
                }else if currentTimerSe.text == "1 hour" || currentTimerSe.text == "01:00:00"{
                    time = 3600
                    currentTimerSe.text = "01:00:00"
                }else if currentTimerSe.text == "2 hour" || currentTimerSe.text == "02:00:00"{
                    time = 7200
                    currentTimerSe.text = "02:00:00"
                }else if currentTimerSe.text == "4 hour" || currentTimerSe.text == "04:00:00"{
                    time = 14400
                    currentTimerSe.text = "04:00:00"
                }else if currentTimerSe.text == "8 hour" || currentTimerSe.text == "08:00:00"{
                    time = 28800
                    currentTimerSe.text = "08:00:00"
                }else{
                    currentTimerSe.text = "01:00"
                }
                
                if let selectTime = self.currentTimerSe.text {
                    print(selectTime)
                }
                
                self.mTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    self.timeLimit()
                    if self.currentTimerSe.text == "00:00" {
                        self.audioPlayer.setVolume(0.0, fadeDuration: 0.5)
                        self.timePicerViewSe.isHidden = false
                        self.currentTimerSe.isHidden = true
                        self.timerLabelSe.text = "타이머 시작"
                        if self.currentLocal != "KR"{
                            self.timerLabelSe.text = "타이머 시작".localized
                        }
                        self.time = 60
                        self.mTimer.invalidate()
                        self.audioState = "off"
                        self.settingB = "on"
                        self.musicStop = false
                        let delaytime = DispatchTime.now() + 0.5
                        DispatchQueue.main.asyncAfter(deadline: delaytime) {
                            self.audioPlayer.stop()
                        }
                    }
                })
                
                settingB = "off"
            }
        }else if settingB == "off"{
            timePicerViewSe.isHidden = false
            currentTimerSe.isHidden = true
            timerLabelSe.text = "타이머 시작"
            if currentLocal != "KR"{
                timerLabelSe.text = "타이머 시작".localized
            }
            mTimer.invalidate()
            time = 60
            settingB = "on"
            
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func deviceScale() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone se")
                deviceNum = 2
                lottieNum = 3
                viewModal.isHidden = true
                viewModalSe.isHidden = false
            case 1334:
                print("iPhone 6/6S/7/8")
                deviceNum = 2
                lottieNum = 2
                exitButtonRight.constant = 22.3
                exitButtonTop.constant = 22.3
                exitIconTop.constant = 26
                
                titleLabelTop.constant = 68.5
                textViewLeft.constant = 46.5
                
                timerTitleTop.constant = 68.5
                timerTitleLeft.constant = 97
                pickerViewLeft.constant = 56.33
                timerLineLeft.constant = 56.33
                timerBtLeft.constant = 81.33
                settingBtLeft.constant = 81.33
                timerLabelLeft.constant = 111
                currentTimeLeft.constant = 115
                textViewWidth.constant = 310
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
                deviceNum = 2
                lottieNum = 2
                exitButtonRight.constant = 22.3
                exitButtonTop.constant = 20.3
                exitIconTop.constant = 24
                titleLabelTop.constant = 88.7
                textViewLeft.constant = 39
                textViewBottom.constant = 50
                
                timerTitleTop.constant = 87.3
                timerTitleLeft.constant = 118
                pickerViewLeft.constant = 77.33
                timerLineLeft.constant = 77.33
                timerBtLeft.constant = 102.33
                settingBtLeft.constant = 102.33
                timerLabelLeft.constant = 132
                currentTimeLeft.constant = 136
            case 1920:
                deviceNum = 2
                lottieNum = 2
                exitButtonRight.constant = 22.3
                exitButtonTop.constant = 20.3
                exitIconTop.constant = 24
                titleLabelTop.constant = 88.7
                textViewLeft.constant = 39
                textViewBottom.constant = 50
                
                timerTitleTop.constant = 87.3
                timerTitleLeft.constant = 118
                pickerViewLeft.constant = 77.33
                timerLineLeft.constant = 77.33
                timerBtLeft.constant = 102.33
                settingBtLeft.constant = 102.33
                timerLabelLeft.constant = 132
                currentTimeLeft.constant = 136
            case 2688:
                print("iPhone XMax")
            default:
                print("unknown")
            }
        }
    }
    
    func fontSizeRe() {
        timerTitle.font = UIFont.systemFont(ofSize: 21)
        timerTitle.text = "타이머 설정"
        if currentLocal != "KR"{
            timerTitle.text = "타이머 설정".localized
            timerTitle.font = UIFont.systemFont(ofSize: 18)
        }
        
        mainExitLabel.font = UIFont.systemFont(ofSize: 13)
        mainExitLabel.text = "Map으로 나가기"
        if currentLocal != "KR"{
            mainExitLabel.text = "Map으로 나가기".localized
        }
        
        timerLabel.font = UIFont.systemFont(ofSize: 14)
        timerLabel.text = "타이머 시작"
        if currentLocal != "KR"{
            timerLabel.text = "타이머 시작".localized
        }
        
        timerTitleSe.font = UIFont.systemFont(ofSize: 17)
        timerTitleSe.text = "타이머 설정"
        if currentLocal != "KR"{
            timerTitleSe.text = "타이머 설정".localized
            timerTitleSe.font = UIFont.systemFont(ofSize: 13)
        }
        mainExitLabelSe.font = UIFont.systemFont(ofSize: 13)
        mainExitLabelSe.text = "Map으로 나가기"
        if currentLocal != "KR"{
            mainExitLabelSe.text = "Map으로 나가기".localized
            mainExitLabelLeft.constant = 465
        }
        timerLabelSe.font = UIFont.systemFont(ofSize: 13)
        timerLabelSe.text = "타이머 시작"
        if currentLocal != "KR"{
            timerLabelSe.text = "타이머 시작".localized
        }
    }
    
    func detailImageView2(_ imageName: String) {
        detailImageView2.image = UIImage(named: imageName)
        if deviceNum == 2 {
            detailImageView2.frame = CGRect(x: detailView.frame.width+3, y: detailView.frame.height+3, width: detailView.frame.width+3, height: detailView.frame.height+3) // 애니메이션뷰의 크기 설정
        }else {
            detailImageView2.frame = CGRect(x: detailView.frame.width+2, y: detailView.frame.height+2, width: detailView.frame.width+2, height: detailView.frame.height+2) // 애니메이션뷰의 크기 설정
        }
        detailImageView2.center = self.view.center // 애니메이션뷰의 위치설정
        detailImageView2.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
        detailMainView.addSubview(detailImageView2)
    }
    
    func detailImageView3(_ imageName: String) {
        detailImageView3.image = UIImage(named: imageName)
        if deviceNum == 2 {
            detailImageView3.frame = CGRect(x: detailView.frame.width+3, y: detailView.frame.height+3, width: detailView.frame.width+3, height: detailView.frame.height+3) // 애니메이션뷰의 크기 설정
        }else {
            detailImageView3.frame = CGRect(x: detailView.frame.width+2, y: detailView.frame.height+2, width: detailView.frame.width+2, height: detailView.frame.height+2) // 애니메이션뷰의 크기 설정
        }
        detailImageView3.center = self.view.center // 애니메이션뷰의 위치설정
        detailImageView3.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
        detailMainView.addSubview(detailImageView3)
    }
    
    func lottieChange(_ lottieName: String) {
        if firstAni == true{
            firstAni = false
        }
        aniView.frame = CGRect(x: detailView.frame.width, y: detailView.frame.height, width: detailView.frame.width, height: detailView.frame.height) // 애니메이션뷰의 크기 설정
        aniView.center = self.view.center // 애니메이션뷰의 위치설정
        aniView.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
        self.detailMainView.addSubview(aniView)
        
        animationView = AnimationView(name: lottieName)
        animationView.frame = CGRect(x: detailView.frame.width, y: detailView.frame.height, width: detailView.frame.width, height: detailView.frame.height) // 애니메이션뷰의 크기 설정
        animationView.center = self.view.center // 애니메이션뷰의 위치설정
        animationView.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        aniView.addSubview(animationView)
        self.detailMainView.insertSubview(aniView, aboveSubview: self.detailImageView)
        animationView.play()
    }
    
    func titleImageChange(_ titleName: String) {
        viewTitleModal.alpha = 1.0
        detailTitleImageView.image = UIImage(named: titleName)
        UIView.animate(withDuration: 1.5, delay: 2.0, options: .curveEaseOut, animations: {
            self.viewTitleModal.alpha = 0.0
        }, completion: nil)
    }
    
    func segueChange() {
        if preventButtonTouch == true {
            return
        }
        if firstAni == false {
            for subview in aniView.subviews {
                subview.removeFromSuperview()
            }
            self.detailImageView2.removeFromSuperview()
        }
        
        switch detailData {
        case "1":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "05")
            }else {
                detailImageView.image = UIImage(named: "05오설록녹차밭2_02")
            }
            
            if lottieNum == 0{
                lottieChange("2. nokcha_2436_1125")
                detailImageView2("05오설록녹차밭2")
            }else{
                lottieChange("2. nokcha_2208_1242")
                detailImageView2("05_02")
            }
            
            self.aniView.insertSubview(detailImageView2, aboveSubview: self.animationView)
            
            if currentLocal == "KR"{
                titleImageChange("녹차밭")
            }else{
                titleImageChange("녹차밭_en")
            }
            
            titleLabel.text = "오설록 녹차밭"
            textView.text = "녹색의 패턴이 만들어주는 내림과 느림의 정서.\n\n귀를 기울여야 들리는 소리가 있다.\n바람에 희미하게 스치는 녹차잎의 소리.\n\n잠시 움직임을 멈추고, 무릎을 꿇고 밭의 가운데에\n앉아 있어야 들을 수 있는 소리이다.\n그 소리를 느끼며 바라보는 녹차밭의 파노라마는\n내림과 느림의 안정감을 준다.\n\n그래서 녹차밭은 이른 아침에 방문하는 것이 좋다.\n방문객이 아직 없을 아침시간의 고요함 안에서, 바다에서\n불어오는 해풍이 만들어낸 안개속에서 녹차밭의\n신비로움도 더해진다.\n\n한낮의 녹차밭은 마치 녹색 카펫을 깔아놓은것처럼 보인다.\n작은 능선들이 만들어내는 끊임없는 녹색의 패턴안에서\n우리 마음의 온도도 함께 뜨거워질 것이다.\n유유자적.\n\n천천히 그리고 낮게. 똑같아 보여도 똑같이 않은 모습으로.\n우리도 그렇게."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "5.녹차밭(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "녹색의 패턴이 만들어주는 내림과 느림의 정서.\n\n귀를 기울여야 들리는 소리가 있다.\n바람에 희미하게 스치는 녹차잎의 소리.\n\n잠시 움직임을 멈추고, 무릎을 꿇고 밭의 가운데에\n앉아 있어야 들을 수 있는 소리이다.\n그 소리를 느끼며 바라보는 녹차밭의 파노라마는\n내림과 느림의 안정감을 준다.\n\n그래서 녹차밭은 이른 아침에 방문하는 것이 좋다.\n방문객이 아직 없을 아침시간의 고요함 안에서, 바다에서\n불어오는 해풍이 만들어낸 안개속에서 녹차밭의\n신비로움도 더해진다.\n\n한낮의 녹차밭은 마치 녹색 카펫을 깔아놓은것처럼 보인다.\n작은 능선들이 만들어내는 끊임없는 녹색의 패턴안에서\n우리 마음의 온도도 함께 뜨거워질 것이다.\n유유자적.\n\n천천히 그리고 낮게. 똑같아 보여도 똑같이 않은 모습으로.\n우리도 그렇게."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "2":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "06")
            }else {
                detailImageView.image = UIImage(named: "06애월앞바다2")
            }
            
            if lottieNum == 0{
                lottieChange("9. Aewol wave_2436_1125")
                lottieChange("9. Aewol human_2436_1125")
            }else{
                lottieChange("9. Aewol wave_2208_1242")
                lottieChange("9. Aewol human_2208_1242")
            }
            
            animationView.frame = CGRect(x: detailView.frame.width+2, y: detailView.frame.height+2, width: detailView.frame.width+2, height: detailView.frame.height+2) // 애니메이션뷰의 크기 설정
            animationView.center = self.view.center // 애니메이션뷰의 위치설정
            animationView.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
            
            if currentLocal == "KR"{
                titleImageChange("애월")
            }else{
                titleImageChange("애월_en")
            }
            
            titleLabel.text = "애월"
            textView.text = "제주도 북서쪽에 위치한 애월은 오랜 시간 파도의 침식이\n만들어낸 해벽이 상당한 거리의 해안선을 따라 펼쳐진 곳이다.\n\n지명에서부터 사랑의 이미지를 은근히 풍기는 탓일까,\n애월은 최근 다양한 방송 프로그램의 영향으로 제주에서 가장\n트렌디함의 중심으로 떠오르고 있다. 협재해변, 금능해변 등의\n청정한 바다와 함께 트렌디한 카페와 맛집들이 밀집되어\n어느 계절에 방문해도 사람들의 발길이 끊이지 않는다.\n\n애월은 제주 공항에서 가까워 제주를 찾은 이들이 가장 먼저\n방문하는 곳이기도 하며, 제주공항에서 서쪽으로 길게 뻗은\n해안 도로를 따라서 해안의 절벽과 하얀 파도를 감상하다 보면\n제주의 여행이 시작되었음을 느끼게 해줄 것이다.\n\n해변가의 카페들이 밀집되어 있는 곳을 조금만 벗어나면\n올레길 코스로 진입할 수 있는데, 바다를 바로 옆에 두고\n걸을 수 있어서 파도 소리를 들으며 짧은 산책을\n하기에 좋은 코스이다.\n\n누구든 애월 해변을 따라 조용히 걷다 보면 발걸음 소리와\n파도 소리가 한 몸이 되는 순간이  있을 것이다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "6.애월(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "제주도 북서쪽에 위치한 애월은 오랜 시간 파도의 침식이\n만들어낸 해벽이 상당한 거리의 해안선을\n따라 펼쳐진 곳이다.\n\n지명에서부터 사랑의 이미지를 은근히 풍기는 탓일까,\n애월은 최근 다양한 방송 프로그램의 영향으로\n제주에서 가장 트렌디함의 중심으로 떠오르고 있다.\n협재해변, 금능해변 등의 청정한 바다와 함께\n트렌디한 카페와 맛집들이 밀집되어\n어느 계절에 방문해도 사람들의 발길이 끊이지 않는다.\n\n애월은 제주 공항에서 가까워 제주를 찾은 이들이\n가장 먼저 방문하는 곳이기도 하며, 제주공항에서\n서쪽으로 길게 뻗은 해안 도로를 따라서\n해안의 절벽과 하얀 파도를 감상하다 보면\n제주의 여행이 시작되었음을 느끼게 해줄 것이다.\n\n해변가의 카페들이 밀집되어 있는 곳을 조금만 벗어나면\n올레길 코스로 진입할 수 있는데, 바다를 바로 옆에 두고\n걸을 수 있어서 파도 소리를 들으며 짧은 산책을\n하기에 좋은 코스이다.\n\n누구든 애월 해변을 따라 조용히 걷다 보면 발걸음 소리와\n파도 소리가 한 몸이 되는 순간이  있을 것이다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "3":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "08")
            }else {
                detailImageView.image = UIImage(named: "08공항2")
            }
            
            if lottieNum == 0{
                lottieChange("1. airport_2436_1125")
            }else{
                lottieChange("1. airport_2208_1242")
            }
            
            if currentLocal == "KR"{
                titleImageChange("공항")
            }else{
                titleImageChange("공항_en")
            }
            
            titleLabel.text = "제주공항"
            textView.text = "제주 여행의 시작과 끝은 공항과 연결되어 있다.\n\n엄격하고 폐쇄적인 정서의 공항이지만 제주공항에서는\n신분증검사, 긴 줄서기, 연착이 수시로 일어나는 곳임에도\n여행의 즐거움, 만남과 이별의 감성이\n더 많은 부분을 차지하고 있다.\n\n출발, 도착 시간에 맞춰 제주의 파도처럼 사람들이 이동한다.\n어떤이는 제주 여행을 통해 일상의 스트레스를 잊었을 것이며,\n어떤이는 소중한 사람과의 추억이 만들어진것에 감사하고\n있을 것이다. 거대한 국제공항 안에서 티켓팅을 마치고 바라보는\n풍경은 보통 그런 것들이다. 아쉬운 추억을 되새기는 사람들과\n새로운 여행지의 기대감에 들뜬 사람들이 불규칙하게\n흘러가면서 독특한 풍경을 만들어낸다.\n\n그 안에서 우리는 모두 주인공이며, 여행자이다.\n또다른 세계로의 진입을 눈앞에 두고 있기에\n이 곳은 잠시 지나가는 곳이며, 어딘가의 한켠에서\n우리의 감정을 내려놓고 싶은 곳이다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized

            }
            detailMusic = "8.공항(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "제주 여행의 시작과 끝은 공항과 연결되어 있다.\n\n엄격하고 폐쇄적인 정서의 공항이지만 제주공항에서는\n신분증검사, 긴 줄서기, 연착이 수시로 일어나는 곳임에도\n여행의 즐거움, 만남과 이별의 감성이\n더 많은 부분을 차지하고 있다.\n\n출발, 도착 시간에 맞춰 제주의 파도처럼\n사람들이 이동한다.\n어떤이는 제주 여행을 통해 일상의 스트레스를\n잊었을 것이며, 어떤이는 소중한 사람과의 추억이\n만들어진 것에 감사하고 있을 것이다.\n거대한 국제공항 안에서 티켓팅을 마치고 바라보는\n풍경은 보통 그런 것들이다. 아쉬운 추억을 되새기는\n사람들과 새로운 여행지의 기대감에 들뜬 사람들이\n불규칙하게 흘러가면서 독특한 풍경을 만들어낸다.\n\n그 안에서 우리는 모두 주인공이며, 여행자이다.\n또다른 세계로의 진입을 눈앞에 두고 있기에\n이 곳은 잠시 지나가는 곳이며, 어딘가의 한켠에서\n우리의 감정을 내려놓고 싶은 곳이다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "4":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "03")
                detailImageView2("03_2")
            }else {
                detailImageView.image = UIImage(named: "03밤바다_함덕서우봉해변2_02")
                detailImageView2("03밤바다_함덕서우봉해변2")
            }
            
            if lottieNum == 0{
                lottieChange("8. bambada light wave_2436_1125")
                lottieChange("8. bambada star_2436_1125")
            }else{
                lottieChange("8. bambada light wave_2208_1242")
                lottieChange("8. bambada star_2208_1242")
            }
            
            self.detailMainView.insertSubview(aniView, aboveSubview: self.detailImageView)
            self.detailMainView.insertSubview(detailImageView2, aboveSubview: self.animationView)
            
            if currentLocal == "KR"{
                titleImageChange("함덕해변")
            }else{
                detailTitleImageView.isHidden = true
                detailTitleImageView2.isHidden = false
                if lottieNum == 3 {
                    detailTitleImageView2.image = UIImage(named: "name02")
                }else if lottieNum == 2 {
                    detailTitleImageView2.image = UIImage(named: "name027")
                }else{
                    detailTitleImageView2.image = UIImage(named: "함덕해변_en")
                }
                
                viewTitleModal.alpha = 1.0
                UIView.animate(withDuration: 1.5, delay: 2.0, options: .curveEaseOut, animations: {
                    self.viewTitleModal.alpha = 0.0
                }, completion: nil)
            }
            
            titleLabel.text = "함덕 해변"
            textView.text = "하얀 모래위에  낙서하기 좋은 바다.\n\n제주도의 바다는 대부분 에매랄드 빛으로 가득한데\n함덕해변은 바다가 얕아지면서 형성된 하얀 패사층으로\n산호바다처럼 바닷물을 더욱 푸르르게 만든다.\n입구에서부터 보이는 야자수들과 하얀모래로 더욱\n이국적인 느낌을 선사할 것이다.\n\n제주도 바다는 밀물, 썰물이 있으면서도 육지의 서해나\n동해바다처럼 바닷비린내가 없는것이 특징이다.\n썰물때 드러나는 모래톱까지 걸어가서 한참 낙서를 하다보면\n천천히 다리위로 바닷물이 차오르게 될 것이다. 밤이되면\n해변으로 물이 가득 들어와서 모래톱은 사라지고, 어딘가에\n남겨놓았던 낙서들도 함께 사라질 것이다. 하지만 그때부터\n함덕해변의 진짜 아름다움이 시작된다. 밤에도 바다를\n즐길 수 있는 산책로를 따라 걷다보면\n제주도의 푸른밤이 그대로 느껴질 것이다.\n\n낙서는 사라져도 여행의 기억은 계속 남는것이니까.\n그렇게 그 곳은 하루의 시작과 끝을 함께하고 있다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "3.밤(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "하얀 모래위에  낙서하기 좋은 바다.\n\n제주도의 바다는 대부분 에매랄드 빛으로 가득한데\n함덕해변은 바다가 얕아지면서 형성된 하얀 패사층으로\n산호바다처럼 바닷물을 더욱 푸르르게 만든다.\n입구에서부터 보이는 야자수들과 하얀모래로 더욱\n이국적인 느낌을 선사할 것이다.\n\n제주도 바다는 밀물, 썰물이 있으면서도 육지의 서해나\n동해바다처럼 바닷비린내가 없는것이 특징이다.\n썰물때 드러나는 모래톱까지 걸어가서 한참 낙서를\n하다보면 천천히 다리위로 바닷물이 차오르게 될 것이다.\n밤이되면 해변으로 물이 가득 들어와서 모래톱은\n사라지고, 어딘가에 남겨놓았던 낙서들도 함께\n사라질 것이다. 하지만 그때부터 함덕해변의 진짜\n아름다움이 시작된다. 밤에도 바다를 즐길 수 있는\n산책로를 따라 걷다보면\n제주도의 푸른밤이 그대로 느껴질 것이다.\n\n낙서는 사라져도 여행의 기억은 계속 남는것이니까.\n그렇게 그 곳은 하루의 시작과 끝을 함께하고 있다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "5":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "09")
            }else {
                detailImageView.image = UIImage(named: "09천왕사2")
            }
            
            if lottieNum == 0{
                lottieChange("3. cheonwangsa_2436_1125")
            }else{
                lottieChange("3. cheonwangsa_2208_1242")
            }
            
            if detailTitleImageView.isHidden == true{
                detailTitleImageView.isHidden = false
                detailTitleImageView2.isHidden = true
            }
            
            if currentLocal == "KR"{
                titleImageChange("천왕사")
            }else{
                titleImageChange("천왕사_en")
            }
            
            titleLabel.text = "천왕사"
            textView.text = "나를 만날 수 있는 곳.\n천왕사는 가장 작은 소리안에서 가슴의 울림을\n들을 수 있는 곳이다.\n\n긴 삼나무 숲길을 따라 올라가는 아름다운 트래킹 코스가\n숨이 차오를 때 쯤이되면 멀리서 천천히 산사에\n울려퍼지는 풍경소리를 들을 수 있다.\n\n약수터에서 목을 축이고 위를 바라보면, 한라산 아래의\n수많은 봉우리와 골짜기로 이루어진 움푹 들어간 산자락에\n자리를 잡은 대웅전과 바로 옆의 계곡물이 흐르는\n소리를 함께 감상할 수 있다.\n\n누군가의 소원이 담겨 있을 여러개의 돌탑들, 기둥마다\n놓여져 있는 작은 불상들에서 이 장소에 새겨져있을 많은\n이들의 감정과 생각들을 떠올려볼 수 있다.\n\n바람이 만들어내는 천왕사의 풍경소리는 모든 소리가\n다 다를것이다. 처마구석에 홀로 매달려 사계절의 풍파에도\n늘 그렇게 있을 것이다.\n소리는 항상 그 자리에 있다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "9.사찰(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "나를 만날 수 있는 곳.\n천왕사는 가장 작은 소리안에서 가슴의 울림을\n들을 수 있는 곳이다.\n\n긴 삼나무 숲길을 따라 올라가는 아름다운 트래킹 코스가\n숨이 차오를 때 쯤이되면 멀리서 천천히 산사에\n울려퍼지는 풍경소리를 들을 수 있다.\n\n약수터에서 목을 축이고 위를 바라보면, 한라산 아래의\n수많은 봉우리와 골짜기로 이루어진 움푹 들어간 산자락에\n자리를 잡은 대웅전과 바로 옆의 계곡물이 흐르는\n소리를 함께 감상할 수 있다.\n\n누군가의 소원이 담겨 있을 여러 개의 돌탑들, 기둥마다\n놓여져 있는 작은 불상들에서 이 장소에 새겨져있을\n많은 이들의 감정과 생각들을 떠올려볼 수 있다.\n\n바람이 만들어내는 천왕사의 풍경소리는 모든 소리가\n다 다를것이다. 처마구석에 홀로 매달려 사계절의\n풍파에도 지금도 늘 그렇게 있을 것이다.\n소리는 항상 그 자리에 있다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "6":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "07")
            }else {
                detailImageView.image = UIImage(named: "07사려니숲2")
            }
            
            if lottieNum == 3{
                lottieChange("4. saryeoni_1136_640")
            }else if lottieNum == 2{
                lottieChange("4. saryeoni_2208_1242")
            }else{
                lottieChange("4. saryeoni_2436_1125")
            }
            
            if currentLocal == "KR"{
                titleImageChange("사려니")
            }else{
                titleImageChange("사려니_en")
            }
            
            titleLabel.text = "사려니 숲길"
            textView.text = "소리를 채취하는 일은 기다림과의 경쟁이기도 하다.\n수백년간 되풀이되는 햇볕과 그늘속에서\n자연의 생존법칙이 만들어놓았을 사려니 숲길은\n제주의 신비로움을 품고 있는 곳이다.\n\n방문하는 시간에 따라, 날씨에 따라 매번 다른 모습을\n감상할 수 있는 이곳에서 낯선존재, 낯선소리는\n오직 사람일 것이다.\n\n비가 내리기 시작하는 동트는 시간에 잠시 방문해서\n숲이 만들어주는 소리를 담아올 수 있었고 숲이 만들어내는\n소리는 세상의 어떤 음악보다도 아름다운 소리였다.\n조용히 숨을 죽이고 나즈막히 앉아서\n숲이 만들어주는 소리를 듣는다는 것,\n잠시나마 그들의 세상속에 살짝 들어갈 수 있는\n귀한 시간이 될 것이다.\n\n우리는 항상 변하고 또 다른 새로운 자극에 갈증을 느끼지만,\n우리가 지나왔던 장소는 항상 그대로이고 그 안에서\n들을 수 있는 소리 역시 변하지 않고\n우리를 기다리고 있을 것이다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "7.사려니(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "소리를 채취하는 일은 기다림과의 경쟁이기도 하다.\n수백년간 되풀이되는 햇볕과 그늘속에서\n자연의 생존법칙이 만들어놓았을 사려니 숲길은\n제주의 신비로움을 품고 있는 곳이다.\n\n방문하는 시간에 따라, 날씨에 따라 매번 다른 모습을\n감상할 수 있는 이곳에서 낯선존재, 낯선소리는\n오직 사람일 것이다.\n\n비가 내리기 시작하는 동트는 시간에 잠시 방문해서\n숲이 만들어주는 소리를 담아올 수 있었고 숲이 만들어내는\n소리는 세상의 어떤 음악보다도 아름다운 소리였다.\n조용히 숨을 죽이고 나즈막히 앉아서\n숲이 만들어주는 소리를 듣는다는 것,\n잠시나마 그들의 세상속에 살짝 들어갈 수 있는\n귀한 시간이 될 것이다.\n\n우리는 항상 변하고 또 다른 새로운 자극에 갈증을\n느끼지만, 우리가 지나왔던 장소는 항상 그대로이고\n그 안에서 들을 수 있는 소리 역시 변하지 않고\n우리를 기다리고 있을 것이다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "7":
            detailView3 = true
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "02")
            }else {
                detailImageView.image = UIImage(named: "02우도2_02")
            }
            
            if lottieNum == 0{
                lottieChange("7. udo wave_2436_1125")
                detailImageView2("02우도3")
                self.aniView.insertSubview(detailImageView2, aboveSubview: self.animationView)
                lottieChange("7. udo human_2436_1125")
                detailImageView3("02우도2")
                self.aniView.insertSubview(detailImageView3, aboveSubview: self.animationView)
            }else{
                lottieChange("7. udo wave_2208_1242")
                detailImageView2("02_2")
                self.aniView.insertSubview(detailImageView2, aboveSubview: self.animationView)
                lottieChange("7. udo human_2208_1242")
                detailImageView3("02_3")
                self.aniView.insertSubview(detailImageView3, aboveSubview: self.animationView)
            }
            
            if currentLocal == "KR"{
                titleImageChange("우도")
            }else{
                titleImageChange("우도_en")
            }
            
            titleLabel.text = "하고수동 해수욕장"
            textView.text = "제주 안의 또 다른 제주, 우도.\n\n제주 성산포항에서 여객선을 타고 15분 정도면\n하우목동 선착장에 닿는다. 짧은 배여행이지만,\n수학여행 온 시끌거리는 학생들부터 조용히 섬을 바라보며\n제주도를 느끼는 노부부까지 다양한 사람들을\n엿볼 수 있는 시간이다.\n\n2017년부터 환경보호를 위해 자동차와 함께 들어갈 수 없어서\n선착장에 내리면 수많은 전기차, 자전거 등의 탈것을 대여해서\n우도를 일주하는 새로운 즐거움을 찾을 수 있다.\n\n우도의 아름다운 해변가중 하고수동 해수욕장은 ‘투명함’\n그 자체이다. 바다와 하늘의 색경계가 모호할 정도로\n푸른 바닷물과 잔잔하게 밀려오는 파도소리는\n섬세할정도로 고운 백사장의 모래 질감이\n그대로 느껴질 정도로 부드럽고 차분하다.\n\n얕은 수심이 길게 뻗어 있어 한가로운 오후의 태양아래\n바지를 살짝 걷은채로 걷다보면 서정적인 제주 섬마을의\n풍경과 아늑한 풀밭의 정취와 하나가 되는\n경험을 할 수 있을 것이다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "2.우도(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "제주 안의 또 다른 제주, 우도.\n\n제주 성산포항에서 여객선을 타고 15분 정도면\n하우목동 선착장에 닿는다. 짧은 배여행이지만,\n수학여행 온 시끌거리는 학생들부터 조용히 섬을 바라보며\n제주도를 느끼는 노부부까지 다양한 사람들을\n엿볼 수 있는 시간이다.\n\n2017년부터 환경보호를 위해 자동차와 함께\n들어갈 수 없어서 선착장에 내리면 수많은\n전기차, 자전거 등의 탈것을 대여해서\n우도를 일주하는 새로운 즐거움을 찾을 수 있다.\n\n우도의 아름다운 해변가중 하고수동 해수욕장은 ‘투명함’\n그 자체이다. 바다와 하늘의 색경계가 모호할 정도로\n푸른 바닷물과 잔잔하게 밀려오는 파도소리는\n섬세할정도로 고운 백사장의 모래 질감이\n그대로 느껴질 정도로 부드럽고 차분하다.\n\n얕은 수심이 길게 뻗어 있어 한가로운 오후의 태양아래\n바지를 살짝 걷은채로 걷다보면 서정적인 제주 섬마을의\n풍경과 아늑한 풀밭의 정취와 하나가 되는\n경험을 할 수 있을 것이다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "8":
            if detailView3 == true {
                self.detailImageView2.removeFromSuperview()
                detailView3 = false
            }
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "04")
                detailImageView2("04_2")
            }else {
                detailImageView.image = UIImage(named: "04성산어판장2_02")
                detailImageView2("04성산어판장2")
            }
            
            if lottieNum == 0{
                lottieChange("5. deck wave_2436_1125")
                lottieChange("5. deck ship_2436_1125")
                lottieChange("5. deck human_2436_1125")
            }else{
                lottieChange("5. deck wave_2208_1242")
                lottieChange("5. deck ship_2208_1242")
                lottieChange("5. deck human_2208_1242")
            }
            
            self.detailMainView.insertSubview(aniView, aboveSubview: self.detailImageView)
            self.detailMainView.insertSubview(detailImageView2, aboveSubview: self.animationView)
            
            if currentLocal == "KR"{
                titleImageChange("어판장")
            }else{
                titleImageChange("어판장_en")
            }
            
            titleLabel.text = "성산포 위판장"
            textView.text = "제주도 하루의 시작을 느낄 수 있는 곳.\n\n아침 6시에 찾은 성산포 위판장은 새벽을 여는\n사람들로 가득하다.\n조금 멀리서 볼 때는 조용한 모습이지만 일단 바다쪽으로\n한 발 들여놓으면 사정은 다르다.\n밤새 고기를 잡고 입찰 시간에 맞춰 들어오는 배들과\n배가 들어오면 잡은 물고기를 서둘러 옮겨서 경매장으로\n옮기는 사람들의 분주함이 가득하다.\n\n눈이 부실 정도로 빛나는 은빛의 갈치들 사이로\n경매가 시작된다. 크기와 선도, 당일의 어획량을 등을\n감안해서 서로의 눈치를 보며 진행되는 경매장엔 말소리는 없다. 오직 호루라기 소리와 숨죽인 수신호만 있을 뿐이다.\n조금이라도 더 높은 값을 받고 싶어하는 선주들, 눈치를 보며\n짐해둔 생선의 입찰에 참여하는 경매자들의 두어시간이\n지나면 그들은 이제 아침식사를 하러 가거나 밤샘 작업의\n피로를 풀러 집으로 갈 것이다.\n\n성산포 어판장은 제주의 아침이 제대로 시작되지 않은 시간부터\n하루의 시작과 끝을 함께하고 있다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "4.어판장(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "제주도 하루의 시작을 느낄 수 있는 곳.\n\n아침 6시에 찾은 성산포 위판장은 새벽을 여는\n사람들로 가득하다.\n조금 멀리서 볼 때는 조용한 모습이지만 일단 바다쪽으로\n한 발 들여놓으면 사정은 다르다.\n밤새 고기를 잡고 입찰 시간에 맞춰 들어오는 배들과\n배가 들어오면 잡은 물고기를 서둘러 옮겨서 경매장으로\n옮기는 사람들의 분주함이 가득하다.\n\n눈이 부실 정도로 빛나는 은빛의 갈치들 사이로\n경매가 시작된다. 크기와 선도, 당일의 어획량을 등을\n감안해서 서로의 눈치를 보며 진행되는 경매장엔 말소리는\n없다. 오직 호루라기 소리와 숨죽인 수신호만 있을 뿐이다.조금이라도 더 높은 값을 받고 싶어하는 선주들,\n눈치를 보며 짐해둔 생선의 입찰에 참여하는 경매자들의\n두어시간이 지나면 그들은 이제 아침식사를\n하러 가거나 밤샘 작업의 피로를 풀러 집으로 갈 것이다.\n\n성산포 어판장은 제주의 아침이\n제대로 시작되지 않은 시간부터\n하루의 시작과 끝을 함께하고 있다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "9":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "12")
            }else {
                detailImageView.image = UIImage(named: "12올레길2")
            }
            
            if lottieNum == 0{
                lottieChange("10. olle shadow_2436_1125")
                lottieChange("10. olle tree cloud_2436_1125")
            }else{
                lottieChange("10. olle shadow_2208_1242")
                lottieChange("10. olle tree cloud_2208_1242")
            }
            animationView.frame.origin.y = animationView.frame.origin.y + 2
            
            if currentLocal == "KR"{
                titleImageChange("올레길")
            }else{
//                titleImageChange("올레길_en")
                detailTitleImageView.isHidden = true
                detailTitleImageView3.isHidden = false
                if lottieNum == 3 {
                    detailTitleImageView3.image = UIImage(named: "name11")
                }else if lottieNum == 2 {
                    detailTitleImageView3.image = UIImage(named: "name117")
                }else{
                    detailTitleImageView3.image = UIImage(named: "올레길_en")
                }
//
                viewTitleModal.alpha = 1.0
                UIView.animate(withDuration: 1.5, delay: 2.0, options: .curveEaseOut, animations: {
                    self.viewTitleModal.alpha = 0.0
                }, completion: nil)
            }
            
            titleLabel.text = "올레길"
            textView.text = "우리는 하루 대부분의 시간을 사무실 혹은 집처럼 특정한\n공간안에서 생활한다. 일상이 주는 무료함도 있을 것이며,\n어떤 공간은 지속적으로 스트레스가 쌓여가고 어떤 순간에\n벗어나고 싶다는 임계점이 올수도 있을 것이다.\n그럴때 제주도의 올레길을 걸어 보기를 추천한다.\n\n조용히 혼자 혹은 둘이 걷기에 좋은 길.\n제주 표선 해안도로에서 남원포구까지 이어지는\n올레길 4코스는 주로 해안가를 따라 바닷길을 걷고,\n중간 중간 작은 언덕과 풀숲길을 걸을 수 있는 곳이다.\n다른 올레길 코스에 비하여 평지가 많고 운이 좋다면\n풀숲길을 걸으며 네잎 크로바를 찾을 수도 있을 것이다.\n무엇보다도 사람이 적어서 혼자만의 조용한 여행을\n원한다면 좋은 경험이 될 수 있을 곳이다.\n그 시간에 여행지에 혼자 있다는 생각을 해도 좋다.\n쓸쓸하다는 생각을 해도 좋다.\n\n그렇게 계속 걷다보면 어느순간 배가 고파지고\n다시 사람들속으로, 일상속으로 돌아가고 싶다는\n생각이 들 때가 올 것이다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "11.올레길(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "우리는 하루 대부분의 시간을 사무실 혹은 집처럼 특정한\n공간안에서 생활한다. 일상이 주는 무료함도 있을 것이며,\n어떤 공간은 지속적으로 스트레스가 쌓여가고 어떤 순간에\n벗어나고 싶다는 임계점이 올수도 있을 것이다.\n그럴때 제주도의 올레길을 걸어 보기를 추천한다.\n\n조용히 혼자 혹은 둘이 걷기에 좋은 길.\n제주 표선 해안도로에서 남원포구까지 이어지는\n올레길 4코스는 주로 해안가를 따라 바닷길을 걷고,\n중간 중간 작은 언덕과 풀숲길을 걸을 수 있는 곳이다.\n다른 올레길 코스에 비하여 평지가 많고 운이 좋다면\n풀숲길을 걸으며 네잎 크로바를 찾을 수도 있을 것이다.\n무엇보다도 사람이 적어서 혼자만의 조용한 여행을\n원한다면 좋은 경험이 될 수 있을 곳이다.\n그 시간에 여행지에 혼자 있다는 생각을 해도 좋다.\n쓸쓸하다는 생각을 해도 좋다.\n\n그렇게 계속 걷다보면 어느순간 배가 고파지고\n다시 사람들속으로, 일상속으로 돌아가고 싶다는\n생각이 들 때가 올 것이다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "10":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "10")
            }else {
                detailImageView.image = UIImage(named: "10쇠소깎2")
            }
            
            if lottieNum == 0{
                lottieChange("6. soggak wave_2436_1125")
                lottieChange("6. soggak boat_2436_1125")
            }else{
                lottieChange("6. soggak wave_2208_1242")
                lottieChange("6. soggak boat_2208_1242")
            }
            
            if detailTitleImageView.isHidden == true{
                detailTitleImageView.isHidden = false
                detailTitleImageView3.isHidden = true
            }
            
            if currentLocal == "KR"{
                titleImageChange("쇠소깍")
            }else{
                titleImageChange("쇠소깍_en")
            }
            
            titleLabel.text = "쇠소깍"
            textView.text = "어떤 장소를 우리가 기억하는 방법은 다양하다.\n특징적인 소리, 향기, 색감, 사물.. 다양한 방법중에서\n쇠소깍은 ‘나룻배’와 함께 기억할 수 있다. 더 정확하게는\n나룻배를 타고 이곳의 풍경을 바라볼 때\n완성되는 하나의 이미지 이기도 하다.\n\n한라산에서 시작된 물줄기는 제주도 남쪽을 따라 흘러 내려오고\n그 끝자락의 효돈천 담수와 해수가 만나서 깊은 웅덩이가\n생겨났다. 쇠소깍은 바로 옆에 해변을두고 병풍처럼 둘러쌓인\n기암괴석과 우거진 숲이 만나 제주도에서도 특히\n이색적인 풍경을 가진 곳이다.\n\n유난히 푸르고 맑은 색감의 물은 에메랄드 및 바다와\n주변 암석, 소나무들이 조화롭게 이루어져 있기 때문일 것이다.\n어느 한가지만으로 이곳의 정서가 완성된다기 보다는\n이 모든 것들이 하나의 풍경으로 눈에 들어올 때 일것이다.\n\n나룻배를 타고 천천히 노를 젖기 시작하면, 물줄기가\n만들어지고 바위의 냄새, 소나무 아래 절벽의 서늘함이\n함께 느껴지면서 어느 순간,\n내가 한편의 수묵화 그림 안에 존재하고 있다는\n느낌을 받을 수 있을 것이다."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "12.쇠소깍(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "어떤 장소를 우리가 기억하는 방법은 다양하다.\n특징적인 소리, 향기, 색감, 사물.. 다양한 방법중에서\n쇠소깍은 ‘나룻배’와 함께 기억할 수 있다. 더 정확하게는\n나룻배를 타고 이곳의 풍경을 바라볼 때\n완성되는 하나의 이미지 이기도 하다.\n\n한라산에서 시작된 물줄기는 제주도 남쪽을 따라\n흘러 내려오고 그 끝자락의 효돈천 담수와 해수가\n만나서 깊은 웅덩이가 생겨났다.\n쇠소깍은 바로 옆에 해변을두고 병풍처럼 둘러쌓인\n기암괴석과 우거진 숲이 만나 제주도에서도 특히\n이색적인 풍경을 가진 곳이다.\n\n유난히 푸르고 맑은 색감의 물은 에메랄드 빛\n바다와 주변 암석, 소나무들이 조화롭게\n이루어져 있기 때문일 것이다.\n어느 한 가지만으로 이곳의 정서가 완성된다기 보다는\n이 모든 것들이 하나의 풍경으로 눈에 들어올 때 일것이다.\n\n나룻배를 타고 천천히 노를 젖기 시작하면, 물줄기가\n만들어지고 바위의 냄새, 소나무 아래 절벽의 서늘함이\n함께 느껴지면서 어느 순간,\n내가 한편의 수묵화 그림 안에 존재하고 있다는\n느낌을 받을 수 있을 것이다."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        case "11":
            if deviceNum == 2 {
                detailImageView.image = UIImage(named: "11")
                detailImageView2("11_02")
                self.detailMainView.insertSubview(detailImageView2, aboveSubview: self.animationView)
            }else {
                detailImageView.image = UIImage(named: "11천제연폭포2_02")
                detailImageView2("11천제연폭포2")
                self.detailMainView.insertSubview(detailImageView2, aboveSubview: self.animationView)
            }
            
            if currentLocal == "KR"{
                titleImageChange("폭포")
            }else{
                titleImageChange("폭포_en")
            }
            
            if lottieNum == 0{
                lottieChange("11. pokpo1_2436_1125")
                lottieChange("11. pokpo2_2436_1125")
                lottieChange("11. pokpo3_2436_1125")
            }else{
                lottieChange("11. pokpo1_2208_1242")
                lottieChange("11. pokpo2_2208_1242")
                lottieChange("11. pokpo3_2208_1242")
            }
            
            titleLabel.text = "천지연폭포"
            textView.text = "우리가 여행지에서만 느낄 수 있다고 생각하는 것은\n일상에서 얻지 못했던것들일 것이다.\n혹은 일상의 풍경과 소리가 너무 익숙해져서 아무 감흥을\n얻지 못하는 것일수도 있다.\n\n천지연폭포는 일상의 소리가 폭포소리에 모두 묻히는 곳이다.\n눈을 감고 폭포소리를 듣는다면 처음엔 새벽시간의\n방송이 끝난 티비처럼 지글거림만 들릴 것이다.\n하지만 더 인내를 가지고 소리에 집중하다보면\n그 물줄기 소리 안에서도 어떤 불규칙함과 바위의 울퉁거림,\n새들의 지저귐, 폭포가 떨어지는 바위의 반동을\n들을 수 있을것이다.\n\n폭포소리를 듣는다는 행위는 이 모든 풍경 속으로 들어가\n더 깊은 자연과 나만의 여행을  경험해보겠다는 의미이다.\n\n눈을 감고 귀를 기울여보자. 물소리의 감각이,\n여행의 감각이 다시 살아나길 반복해보자.\n그리고 다시 도시로 돌아왔을 때 들리는\n소리 하나하나가 더 깊고 의미있게 들릴 수 있도록.."
            if currentLocal != "KR"{
                titleLabel.text = titleLabel.text?.localized
                titleLabel.font = UIFont.systemFont(ofSize: 19)
                titleLabelHeight.constant = 22
                textView.text = textView.text.localized
            }
            detailMusic = "10.폭포(A)"
            if UIScreen.main.nativeBounds.height == 1136 {
                titleLabelSe.text = titleLabel.text
                textViewSe.text = "우리가 여행지에서만 느낄 수 있다고 생각하는 것은\n일상에서 얻지 못했던것들일 것이다.\n혹은 일상의 풍경과 소리가 너무 익숙해져서 아무 감흥을\n얻지 못하는 것일수도 있다.\n\n천지연폭포는 일상의 소리가 폭포소리에\n모두 묻히는 곳이다.\n눈을 감고 폭포소리를 듣는다면 처음엔 새벽시간의\n방송이 끝난 티비처럼 지글거림만 들릴 것이다.\n하지만 더 인내를 가지고 소리에 집중하다보면\n그 물줄기 소리 안에서도 어떤 불규칙함과 바위의 울퉁거림,\n새들의 지저귐, 폭포가 떨어지는 바위의 반동을\n들을 수 있을것이다.\n\n폭포소리를 듣는다는 행위는 이 모든 풍경 속으로 들어가\n더 깊은 자연과 나만의 여행을  경험해보겠다는 의미이다.\n\n눈을 감고 귀를 기울여보자. 물소리의 감각이,\n여행의 감각이 다시 살아나길 반복해보자.\n그리고 다시 도시로 돌아왔을 때 들리는\n소리 하나하나가 더 깊고 의미있게 들릴 수 있도록.."
                if currentLocal != "KR"{
                    titleLabelSe.text = titleLabel.text?.localized
                    titleLabelSe.font = UIFont.systemFont(ofSize: 15)
                    titleLabelSeHeight.constant = 20
                    textViewSe.text = textView.text.localized
                }
            }
        default:
            print("unknown")
        }
    }
}

extension UIView  {
    func isScrolling () -> Bool {
        if let scrollView = self as? UIScrollView {
            if  (scrollView.isDragging || scrollView.isDecelerating) {
                return true
            }
        }
        
        for subview in self.subviews {
            if ( subview.isScrolling() ) {
                return true
            }
        }
        return false
    }
}

extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }
}
