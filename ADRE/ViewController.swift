//
//  ViewController.swift
//  ADRE
//
//  Created by youngwoo Choi on 15/04/2019.
//  Copyright © 2019 youngwoo Choi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import TAKUUID
import SwiftGifOrigin
import StoreKit
import Lottie
import SystemConfiguration

class ViewController: UIViewController, AVAudioPlayerDelegate, XMLParserDelegate, SKPaymentTransactionObserver, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapPoninbt: UIImageView!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var goDetailBt01: UIButton!
    @IBOutlet weak var goDetailBt02: UIButton!
    @IBOutlet weak var goDetailBt03: UIButton!
    @IBOutlet weak var goDetailBt04: UIButton!
    @IBOutlet weak var goDetailBt05: UIButton!
    @IBOutlet weak var goDetailBt06: UIButton!
    @IBOutlet weak var goDetailBt07: UIButton!
    @IBOutlet weak var goDetailBt08: UIButton!
    @IBOutlet weak var goDetailBt09: UIButton!
    @IBOutlet weak var goDetailBt10: UIButton!
    @IBOutlet weak var goDetailBt11: UIButton!
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mainMapView: UIView!
    @IBOutlet weak var mainIslandBackground: UIImageView!
    @IBOutlet weak var menuLine: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingImage: UIImageView!
    
    @IBOutlet weak var mapButtonLeft: NSLayoutConstraint!
    @IBOutlet weak var mapButtonTop: NSLayoutConstraint!
    @IBOutlet weak var epiButtonTop: NSLayoutConstraint!
    @IBOutlet weak var epiButtonRight: NSLayoutConstraint!
    @IBOutlet weak var payMainTop: NSLayoutConstraint!
    @IBOutlet weak var creditLeft: NSLayoutConstraint!
    @IBOutlet weak var creditRight: NSLayoutConstraint!
    @IBOutlet weak var stayButtonLeft: NSLayoutConstraint!
    @IBOutlet weak var stayBtLeft: NSLayoutConstraint!
    
    @IBOutlet weak var payMainView: UIView!
    @IBOutlet weak var payMainViewSe: UIView!
    @IBOutlet weak var payMainTextView: UITextView!
    @IBOutlet weak var payMainTextViewSE: UITextView!
    @IBOutlet weak var payButtonSE: UIButton!
    @IBOutlet weak var restoreButtonSE: UIButton!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var creditScroll: UIScrollView!
    @IBOutlet weak var creditSubView: UIView!
    
    @IBOutlet weak var stayImageView: UIImageView!
    @IBOutlet weak var tourImageView: UIImageView!
    @IBOutlet weak var stayButton: UIButton!
    
    @IBOutlet weak var buySoundLabel: UILabel!
    @IBOutlet weak var buySoundLabelSE: UILabel!
    @IBOutlet weak var buySoundNotiLabel: UILabel!
    @IBOutlet weak var buySoundNotiSE: UILabel!
    @IBOutlet weak var buyEmailLabel: UILabel!
    @IBOutlet weak var restoreBT: UIButton!
    @IBOutlet weak var payButtonImage: UIImageView!
    @IBOutlet weak var payButtonImageSE: UIImageView!
    @IBOutlet weak var buyEmailLabelSE: UILabel!
    
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var noticeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var buyNotiLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var buyBTLeft: NSLayoutConstraint!
    @IBOutlet weak var buyExitRihgt: NSLayoutConstraint!
    @IBOutlet weak var payMainTextViewTop: NSLayoutConstraint!
    @IBOutlet weak var noticeViewBottom: NSLayoutConstraint!
    @IBOutlet weak var buyLogoSeTop: NSLayoutConstraint!
    @IBOutlet weak var tosWidth: NSLayoutConstraint!
    @IBOutlet weak var tosSeWidth: NSLayoutConstraint!
    @IBOutlet weak var tourImageViewLeft: NSLayoutConstraint!
    
    private var refreshControl = UIRefreshControl()
    var parser: XMLParser!
    var label : UILabel = UILabel()
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer!
    var playerTimer: Timer!
    var mTimer : Timer!
    var leftFrame:CGRect!   // ! 강제 언래핑 (즉, NULL 허용)
    var rightFrame:CGRect!
    var buttonTi: String = "on"
    var stayTour: String = "on"
    var backgoundState: String = "on"
    var creditState: String = "on"
    var musicLen: String = ""
    var currentLocal: String = ""
    var currentMusic: String = ""
    var reMessage: String = "구매복원을 성공하였습니다."
    var refMessage: String = "구매내역이 없습니다."
    var payfMessage: String = "결제 요청이 불가능합니다."
    var doubleTapState: Bool = true
    var audioChek: Bool = true
    var currentImage = 0
    var data = ""
    var detailData = ""
    var detailCheck = ""
    var preventButtonTouch = false
    var payState = false
    var epiButtonState = false
    let productID = "com.union.adre.tourmusic"
    var isOtherAudioPlaying = AVAudioSession.sharedInstance().isOtherAudioPlaying
    var upDownG = ""
    var animator: UIViewPropertyAnimator?
    var recognizerScale:CGFloat = 1.0
    var maxScale:CGFloat = 2.0
    var minScale:CGFloat = 1.0
    var lottieNum:Int = 0
    var animationView = AnimationView()
    var loadingiamgeArray = [UIImage]()
    var purchased = [SKPaymentTransaction]();
    let aniView = UIView()
    let defaults = UserDefaults.standard
    let notificationName = Notification.Name("UIApplication.didEnterBackgroundNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.epiButtonState = true
        }
        
        let locale = Locale.current
        if locale.regionCode == nil{
            self.currentLocal = "KR"
        }else{
            self.currentLocal = locale.regionCode!
        }
        
        if currentLocal != "KR"{
            reMessage = "Purchase restore succeeded."
            refMessage = "No purchase details."
            payfMessage = "Payment request is not possible."
        }
        
        if buttonTi == "on" {
            mapPoninbt.image = UIImage(named: "mapPointBt01")
            menuLine.alpha = 1.0
        }else{
            mapPoninbt.image = UIImage(named: "mapPointBt02")
            menuLine.alpha = 0.0
        }
        
        let opx:String? = defaults.string(forKey: "stayTour")
        if let opy = opx {  // opy 값은 더이상 옵셔널이 아님
            stayTour = opy
            if stayTour == "on" {
                stayImageView.image = UIImage(named: "stayBt01")
                tourImageView.image = UIImage(named: "tourBt02")
            }else{
                stayImageView.image = UIImage(named: "stayBt02")
                tourImageView.image = UIImage(named: "tourBt01")
            }
        }
        
        initPlayer()
        deviceScale()
        
        if lottieNum == 0{
            lottieChange("main_aewol")
            lottieChange("main_airport")
            lottieChange("main_beach")
            lottieChange("main_camera")
            lottieChange("main_center")
            lottieChange("main_cheonwangsa")
            lottieChange("main_deck")
            lottieChange("main_nokcha")
            lottieChange("main_olle")
            lottieChange("main_pokpo")
            lottieChange("main_saryeoni")
            lottieChange("main_soggak")
        }else{
            lottieChange("main_aewol_2208_1242")
            lottieChange("main_airport_2208_1242")
            lottieChange("main_beach_2208_1242")
            lottieChange("main_camera_2208_1242")
            lottieChange("main_center_2208_1242")
            lottieChange("main_cheonwangsa_2208_1242")
            lottieChange("main_deck_2208_1242")
            lottieChange("main_nokcha_2208_1242")
            lottieChange("main_olle_2208_1242")
            lottieChange("main_pokpo_2208_1242")
            lottieChange("main_saryeoni_2208_1242")
            lottieChange("main_soggak_2208_1242")
        }
        
        fontSizeRe()
        userCheck()
        payCheck()
        
        audioPlayer.delegate = self
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
//            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
        } catch {
            print(error)
        }
        
        // 페이먼트 관련 설정을 해 주도록 합니다.
        SKPaymentQueue.default().add(self)
        
        payMainView.isHidden = true
        payMainViewSe.isHidden = true
        creditView.isHidden = true
        noticeView.isHidden = true
        loadingView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.otehrApp(bool:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.frontgroundNoti(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.backgroundNoti(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animationView.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeNotificationBack(){
//        print("백노티 삭제")
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func removeNotificationFront(){
//        print("프론트노티 삭제")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func removeNotificationHand(){
//        print("핸드노티 삭제")
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc func frontgroundNoti(notification: NSNotification) {
//        print("front")
        if backgoundState == "on"{
            do {
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
//                print("soloAmbient OK")
                try AVAudioSession.sharedInstance().setActive(true)
//                print("Session is Active")
            } catch {
                print(error)
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
//                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
//                print("Session is Active")
            } catch {
                print(error)
            }
             if self.audioPlayer.isPlaying == false{
                self.audioPlayer.play()
            }
        }
    }
    
    @objc func backgroundNoti(notification: NSNotification) {
//        print("back")
        if backgoundState == "on"{
            do {
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
//                print("Soloabient OK")
                try AVAudioSession.sharedInstance().setActive(true)
//                print("Session is Active")
            } catch {
                print(error)
            }
            self.audioPlayer.pause()
        }
    }
    
    @objc func handleInterruption(notification: NSNotification) {
//           print("handleInterruption")
           guard let userInfo = notification.userInfo,
               let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
               let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                   return
           }
           switch type {
           case .began:
            if self.audioPlayer.isPlaying == true{
//                print("전화옴")
                self.audioPlayer.pause()
            }
            case .ended:
                guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
//                    print("전화끔1")
                    if self.audioPlayer.isPlaying == false{
                        self.audioPlayer.play()
                    }
                } else {
//                    print("전화끔2")
                    if self.audioPlayer.isPlaying == false{
                        self.audioPlayer.play()
                    }
                }
            default :
               print("ended")
           }
    }
    
    @objc func otehrApp(bool: Bool) {
//        print("다른 앱:\(bool)")
        if (AVAudioSession.sharedInstance().isOtherAudioPlaying) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
//                print("Soloabient OK")
                try AVAudioSession.sharedInstance().setActive(true)
//                print("Session is Active")
            } catch {
                print(error)
            }
        }
    }
    
    func userCheck(){
        let user = String(TAKUUIDStorage.sharedInstance().findOrCreate()!)
//        print(user)
//        디비에있는 회원인지 확인
        if let requestUrl = URL(string: "http://starwatch.co.kr/glo/checkUser?adre_user=\(user)"){
            let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data,
                    let res = response as? HTTPURLResponse,
                    res.statusCode == 200
                {
                    let urlContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    if let urlContent = urlContent {
                        if urlContent == "0" {
                            let locale = Locale.current
                            if locale.regionCode == nil{
                                self.currentLocal = "KR"
                            }else{
                                self.currentLocal = locale.regionCode!
                            }
//                            print("국가:\(self.currentLocal)")
                            let baseUrl : String = "http://starwatch.co.kr/glo/insertUser?adre_user=\(user)&adre_location=\(self.currentLocal)"
                            
                            if let requestUrl = URL(string: baseUrl){
                                self.parser = XMLParser(contentsOf: requestUrl)
                                self.parser.delegate = self
                                self.parser.parse()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self.payUser()
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func payUser() {
//        print("기존회원")
        let user = String(TAKUUIDStorage.sharedInstance().findOrCreate()!)
        if let requestUrl = URL(string: "http://starwatch.co.kr/glo/checkPay?adre_user=\(user)"){
            let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data,
                    let res = response as? HTTPURLResponse,
                    res.statusCode == 200
                {
                    let urlContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    if let urlContent = urlContent {
                        if urlContent == "1" {
//                            print("결제회원")
                            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL = dir.appendingPathComponent("payCheck.txt")
                            //reading
                            do {
                                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                                print(text2)
                            }
                            catch let error {
                                print(error.localizedDescription)
                                let file = "payCheck.txt"
                                let text = "thanksAdre"
                                
                                let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                //        print(dir)
                                let fileURL = dir.appendingPathComponent(file)
                                
                                //writing
                                do {
                                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                                }
                                catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
//        print(payState)
        if payState == true {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.payMainView.alpha = 0.0
            }, completion: { success in
                self.payMainView.isHidden = true
                self.payMainViewSe.isHidden = true
            })
        }
    }
    
    func payCheck(){
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = dir.appendingPathComponent("payCheck.txt")
        //reading
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            
            if text2 == "thanksAdre" {
                self.payState = true
                self.menuLine.image = UIImage(named: "view02Mapguide02")
            }
        }
        catch let error {
            print(error.localizedDescription)
            menuLine.image = UIImage(named: "view02Mapguide01")
        }
        
        let user = String(TAKUUIDStorage.sharedInstance().findOrCreate()!)
        if let requestUrl = URL(string: "http://starwatch.co.kr/glo/checkPay?adre_user=\(user)"){
            let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data,
                    let res = response as? HTTPURLResponse,
                    res.statusCode == 200
                {
                    let urlContent = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    if let urlContent = urlContent {
                        if urlContent == "1" {
                            self.payState = true
                            DispatchQueue.main.async {
                                self.menuLine.image = UIImage(named: "view02Mapguide02")
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }

    @IBAction func payBT(_ sender: Any) {
//        구매 복원
//        print("복원")
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = self.productID
            print(paymentRequest.productIdentifier)
            SKPaymentQueue.default().restoreCompletedTransactions()
            self.loadingChange()
            self.loadingImage.startAnimating()
        }
    }
    
    @IBAction func payBT2(_ sender: Any) {
        if SKPaymentQueue.canMakePayments() {
//            print("결제 요청이 가능합니다.")
//            print("tour모드 결제 할거에요.")
            let paymentRequest = SKMutablePayment()
//            print(self.productID)
            paymentRequest.productIdentifier = self.productID
            SKPaymentQueue.default().add(paymentRequest)
            self.loadingChange()
            self.loadingImage.startAnimating()
        } else {
            print("결제 요청이 불가능합니다.")
        }
    }
    
    @IBAction func payseBT(_ sender: Any) {
//        구매 복원
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = self.productID
            SKPaymentQueue.default().restoreCompletedTransactions()
            self.loadingChange()
            self.loadingImage.startAnimating()
        }
    }
    @IBAction func payseBT2(_ sender: Any) {
        if SKPaymentQueue.canMakePayments() {
//            print("결제 요청이 가능합니다.")
//            print("tour모드 결제 할거에요.")
            let paymentRequest = SKMutablePayment()
//            print(self.productID)
            paymentRequest.productIdentifier = self.productID
            SKPaymentQueue.default().add(paymentRequest)
            self.loadingChange()
            self.loadingImage.startAnimating()
        } else {
            print("결제 요청이 불가능합니다.")
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState{
            case .purchasing:
//                print("결제가 진행되고 있습니다.");
                break;
                
            // 결제 창을 띄우는 데 실패했습니다.
            case .deferred:
//                print("아이폰의 잠기는 등의 이류로 결제 창을 띄우지 못했습니다.")
                self.loadingImage.stopAnimating()
                self.loadingView.isHidden = true
                self.loadingiamgeArray.removeAll()
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            case .purchased:
//                print("결제를 성공하였습니다.")
                self.loadingImage.stopAnimating()
                self.loadingView.isHidden = true
                self.loadingiamgeArray.removeAll()
//                print("영수증")
//                handlePurchased(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                let user = String(TAKUUIDStorage.sharedInstance().findOrCreate()!)
                if let requestUrl = URL(string: "http://starwatch.co.kr/glo/updateUser?adre_user=\(user)"){
                    let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        if let data = data,
                            let res = response as? HTTPURLResponse,
                            res.statusCode == 200
                        {
                            let success = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                            print("구매완료 \(String(describing: success))")
                        }
                    }
                    task.resume()
                }

                let file = "payCheck.txt"
                let text = "thanksAdre"

                let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                //        print(dir)
                let fileURL = dir.appendingPathComponent(file)

                //writing
                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                    payState = true
                }
                catch let error {
                    print(error.localizedDescription)
                }
                
            case .failed:
//                print("결제를 실패하였습니다.")
                self.loadingImage.stopAnimating()
                self.loadingView.isHidden = true
                self.loadingiamgeArray.removeAll()
                if(isConnectedToNetwork()) {
                    print("연결")
                }else{
                    let dialog = UIAlertController(title: "", message: self.payfMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                    dialog.addAction(action)
                    self.present(dialog, animated: true, completion: nil)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            case .restored:
//                print("결제를 검증을 하였습니다.")
                self.loadingImage.stopAnimating()
                self.loadingView.isHidden = true
                self.loadingiamgeArray.removeAll()
//                print("영수증")
//                handlePurchased(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                let user = String(TAKUUIDStorage.sharedInstance().findOrCreate()!)
                if let requestUrl = URL(string: "http://starwatch.co.kr/glo/updateUser?adre_user=\(user)"){
                    let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        if let data = data,
                            let res = response as? HTTPURLResponse,
                            res.statusCode == 200
                        {
                            let success = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                            print("구매완료 \(String(describing: success))")
                        }
                    }
                    task.resume()
                }

                let file = "payCheck.txt"
                let text = "thanksAdre"

                let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                //        print(dir)
                let fileURL = dir.appendingPathComponent(file)

                //writing
                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
                    payState = true
                }
                catch let error {
                    print(error.localizedDescription)
                }
            default:
//                print("알수 없는 오류를 만났습니다.")
                SKPaymentQueue.default().finishTransaction(transaction)
                break;
            }
        }
        self.userCheck()
        self.payCheck()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions == []{
            let dialog = UIAlertController(title: "", message: refMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
//            print("상품 못찾음")
            self.loadingImage.stopAnimating()
            self.loadingView.isHidden = true
            self.loadingiamgeArray.removeAll()
        }
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
//            print("회원이결제id: \(prodID)")
            switch prodID {
            case productID:
                let dialog = UIAlertController(title: "", message: reMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
//                print("복원 성공")
                self.loadingImage.stopAnimating()
                self.loadingView.isHidden = true
                self.loadingiamgeArray.removeAll()
            default:
                let dialog = UIAlertController(title: "", message: refMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
                dialog.addAction(action)
                self.present(dialog, animated: true, completion: nil)
//                print("상품 못찾음")
                self.loadingImage.stopAnimating()
                self.loadingView.isHidden = true
                self.loadingiamgeArray.removeAll()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.loadingImage.stopAnimating()
        self.loadingView.isHidden = true
        self.loadingiamgeArray.removeAll()
        let dialog = UIAlertController(title: "", message: payfMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
    }
    
    func loadingChange() {
        loadingView.isHidden = false
        for i in 1...3 {
            loadingiamgeArray.append(UIImage(named: "loading0\(i)")!)
        }
        loadingImage.animationImages = loadingiamgeArray
        loadingImage.animationDuration = 0.7
    }
    
    func fontSizeRe() {
        payMainTextView.text = "ADRE는 소리와 감성을 직접 담아와 여러분께 들려드립니다.\nADRE All Sound를 구매하시면 Island의 모든 장소의 오픈과\n갤러리 스타일의 투어모드를 자유롭게 이용하실 수 있습니다."
            if currentLocal != "KR"{
                payMainTextView.text = "ADRE는 소리와 감성을 직접 담아와 여러분께 들려드립니다.\nADRE All Sound를 구매하시면 Island의 모든 장소의 오픈과\n갤러리 스타일의 투어모드를 자유롭게 이용하실 수 있습니다.".localized
            }
        
        payMainTextViewSE.text = "ADRE는 소리와 감성을 직접 담아와 여러분께 들려드립니다.\nADRE All Sound를 구매하시면 Island의 모든 장소의 오픈과\n갤러리 스타일의 투어모드를 자유롭게 이용하실 수 있습니다."
        if currentLocal != "KR"{
            payMainTextViewSE.text = "ADRE는 소리와 감성을 직접 담아와 여러분께 들려드립니다.\nADRE All Sound를 구매하시면 Island의 모든 장소의 오픈과\n갤러리 스타일의 투어모드를 자유롭게 이용하실 수 있습니다.".localized
        }
        payMainTextViewSE.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.8)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        payMainTextView.attributedText = NSAttributedString(string: payMainTextView.text, attributes: attributes)
        payMainTextView.textAlignment = .center
        payMainTextView.font = UIFont.systemFont(ofSize: 14)
        payMainTextView.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.8)
        
        
        buyEmailLabel.font = UIFont.systemFont(ofSize: 13)
        buyEmailLabel.text = "adresupt@gmail.com"
        
        buyEmailLabelSE.font = UIFont.systemFont(ofSize: 10)
        buyEmailLabelSE.text = "adresupt@gmail.com"
        
        
        
        buySoundLabel.font = UIFont.systemFont(ofSize: 16)
        buySoundLabel.text = "ADRE 구매"
        buySoundLabel.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.8)
        if currentLocal != "KR"{
            buySoundLabel.text = "ADRE 구매".localized
        }
        buySoundLabelSE.font = UIFont.systemFont(ofSize: 14)
        buySoundLabelSE.text = "ADRE 구매"
        if currentLocal != "KR"{
            buySoundLabelSE.text = "ADRE 구매".localized
        }
        buySoundLabelSE.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.8)
        
        
        buySoundNotiLabel.font = UIFont.systemFont(ofSize: 15)
        buySoundNotiLabel.text = "이용약관  |  구매복원"
        buySoundNotiLabel.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.8)
        if currentLocal != "KR"{
            buySoundNotiLabel.text = "이용약관 | 구매복원".localized
            if lottieNum == 2{
                tosWidth.constant = 115
            }else{
                tosWidth.constant = 120
            }
        }
        
        buySoundNotiSE.font = UIFont.systemFont(ofSize: 11)
        buySoundNotiSE.text = "이용약관  |  구매복원"
        if currentLocal != "KR"{
            buySoundNotiSE.text = "이용약관 | 구매복원".localized
            tosSeWidth.constant = 110
        }
        let attributeStr2 = NSMutableAttributedString(string: buySoundNotiSE.text!)
        attributeStr2.addAttribute(.foregroundColor, value: UIColor.init(displayP3Red: 136.0/255, green: 136.0/255, blue: 136.0/255, alpha: 1.0), range: (buySoundNotiSE.text! as NSString).range(of: "|"))
        buySoundNotiSE.attributedText = attributeStr2
        buySoundNotiSE.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.8)
    }
    
    func initPlayer(){
        do{
            if let path = Bundle.main.path(forResource: "1.메인화면(A)", ofType: "mp3"){
                let url = URL(fileURLWithPath: path)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.numberOfLoops = -1
                if self.audioPlayer.isPlaying == false{
                    self.audioPlayer.play()
                }
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func buttonChanged(_ sender: UIButton) {
        
        if self.buttonTi == "off"{
            mapPoninbt.image = UIImage(named: "mapPointBt02")
            menuLine.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.buttonTi = "on"
                self.mapPoninbt.image = UIImage(named: "mapPointBt01")
                self.menuLine.alpha = 1.0
            }, completion: nil)
        }else if self.buttonTi == "on"{
            mapPoninbt.image = UIImage(named: "mapPointBt01")
            menuLine.alpha = 1.0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.buttonTi = "off"
                self.mapPoninbt.image = UIImage(named: "mapPointBt02")
                self.menuLine.alpha = 0.0
            }, completion: nil)
        }
    }
    
    @IBAction func stayChanged(_ sender: UIButton) {
        if payState == true {
            noticeView.isHidden = false
            noticeView.alpha = 1.0
            noticeViewWidth.constant = 310
            noticeView.layer.cornerRadius = 20
            noticeView.layer.masksToBounds = true
            noticeLabel.font = .systemFont(ofSize: 16)
            noticeLabel.text = "선택한 장소의 음악을 계속 플레이합니다."
            if currentLocal != "KR"{
                noticeLabel.text = "선택한 장소의 음악을 계속 플레이합니다.".localized
                noticeViewWidth.constant = 360
            }
            noticeLabel.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1.0)
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                self.noticeView.alpha = 0.0
            }, completion: nil)
            
            stayImageView.image = UIImage(named: "stayBt02")
            tourImageView.image = UIImage(named: "tourBt01")
            defaults.setValue("on", forKey: "stayTour")
            defaults.synchronize()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.stayTour = "on"
                
                self.stayImageView.image = UIImage(named: "stayBt01")
                self.tourImageView.image = UIImage(named: "tourBt02")
            }, completion: nil)
        }
    }
    
    @IBAction func tourChanged(_ sender: Any) {
        if payState == false {
            payGoButton()
        }else{
            noticeView.isHidden = false
            noticeView.alpha = 1.0
            noticeViewWidth.constant = 393
            noticeView.layer.cornerRadius = 20
            noticeView.layer.masksToBounds = true
            noticeLabel.font = .systemFont(ofSize: 16)
            noticeLabel.text = "선택한 장소의 음악이 끝나면 다음 장소로 이동합니다."
            if currentLocal != "KR"{
                noticeLabel.text = "선택한 장소의 음악이 끝나면 다음 장소로 이동합니다.".localized
                noticeViewWidth.constant = 430
            }
            noticeLabel.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1.0)
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .curveEaseOut, animations: {
                self.noticeView.alpha = 0.0
            }, completion: nil)
            
            stayImageView.image = UIImage(named: "stayBt01")
            tourImageView.image = UIImage(named: "tourBt02")
            defaults.setValue("off", forKey: "stayTour")
            defaults.synchronize()
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.stayTour = "off"
                self.stayImageView.image = UIImage(named: "stayBt02")
                self.tourImageView.image = UIImage(named: "tourBt01")
            }, completion: nil)
        }
    }
    @IBAction func epiPaygo(_ sender: Any) {
        payGoButton()
    }
    
    @IBAction func detailPageGo06(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "1"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
        
    @IBAction func detailPage01(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        detailCheck = "2"
        preventButtonTouch = true
        self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
        let time = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.performSegue(withIdentifier: "ShowDetail", sender: self)
            self.audioPlayer.stop()
            self.removeAni()
        }
        removeNotificationFront()
        removeNotificationBack()
        removeNotificationHand()
    }
    
    @IBAction func detailPage07(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "3"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    @IBAction func detailPage09(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "4"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    @IBAction func detailPage08(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "5"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    @IBAction func detailPageGo05(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        detailCheck = "6"
        preventButtonTouch = true
        self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
        let time = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.performSegue(withIdentifier: "ShowDetail", sender: self)
            self.audioPlayer.stop()
            self.removeAni()
        }
        removeNotificationFront()
        removeNotificationBack()
        removeNotificationHand()
    }
    
    @IBAction func detailPage11(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "7"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    @IBAction func detailPage04(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "8"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    @IBAction func detailPage02(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "9"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }

    @IBAction func detailPage10(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "10"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    @IBAction func detailPage03(_ sender: Any) {
        if preventButtonTouch == true {
            return
        }
        if payState == false {
            payGoButton()
        }else{
            detailCheck = "11"
            preventButtonTouch = true
            self.audioPlayer.setVolume(0.0, fadeDuration: 0.3)
            let time = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: time) {
                self.performSegue(withIdentifier: "ShowDetail", sender: self)
                self.audioPlayer.stop()
                self.removeAni()
            }
            removeNotificationFront()
            removeNotificationBack()
            removeNotificationHand()
        }
    }
    
    func removeAni() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            for subview in self.aniView.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailVC = segue.destination as! DetailViewController
            detailVC.detailData = detailCheck
            detailVC.buttonTi = buttonTi
            detailVC.stayTour = stayTour
            backgoundState = "off"
        }
    }
    
    func payGoButton() {
        if payState == true {
            restoreBT.isHidden = true
            buySoundLabel.isHidden = true
            payButton.isHidden = true
            payButtonImage.isHidden = true
            payMainTop.constant = 102.6
            buySoundNotiLabel.font = UIFont.systemFont(ofSize: 15)
            buySoundNotiLabel.text = "이용약관"
            if currentLocal != "KR"{
                buySoundNotiLabel.text = "이용약관".localized
                if lottieNum == 2{
                    tosWidth.constant = 115
                }else{
                    tosWidth.constant = 120
                }
            }
            payMainTextView.font = UIFont.systemFont(ofSize: 14)
            payMainTextView.text = "ADRE는 그 장소의 소리와 감성을 직접 담아와 여러분의 힐링을 도와드립니다.\n답답한 일상을 벗어나 ADRE와 함께 릴렉스 타임을 즐겨보세요."
            if currentLocal != "KR"{
                payMainTextView.text = "ADRE는 그 장소의 소리와 감성을 직접 담아와 여러분의 힐링을 도와드립니다.\n답답한 일상을 벗어나 ADRE와 함께 릴렉스 타임을 즐겨보세요.".localized
            }
            
            restoreButtonSE.isHidden = true
            buySoundLabelSE.isHidden = true
            payButtonSE.isHidden = true
            payButtonImageSE.isHidden = true
            buyLogoSeTop.constant = 93.4
            buySoundNotiSE.font = UIFont.systemFont(ofSize: 11)
            buySoundNotiSE.text = "이용약관"
            if currentLocal != "KR"{
                buySoundNotiSE.text = "이용약관".localized
                tosSeWidth.constant = 110
            }
            payMainTextViewSE.font = UIFont.systemFont(ofSize: 12)
            payMainTextViewSE.text = "ADRE는 그 장소의 소리와 감성을 직접 담아와 여러분의 힐링을 도와드립니다.\n답답한 일상을 벗어나 ADRE와 함께 릴렉스 타임을 즐겨보세요."
            if currentLocal != "KR"{
                payMainTextViewSE.text = "ADRE는 그 장소의 소리와 감성을 직접 담아와 여러분의 힐링을 도와드립니다.\n답답한 일상을 벗어나 ADRE와 함께 릴렉스 타임을 즐겨보세요.".localized
            }
        }
        if UIDevice().userInterfaceIdiom == .phone {
//            print(UIScreen.main.nativeBounds.height)
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                payMainViewSe.alpha = 0.0
                payMainViewSe.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.payMainViewSe.alpha = 1.0
                }, completion: nil)
                
                payMainTextViewSE.isEditable = false
                payMainTextViewSE.isUserInteractionEnabled = false
            default:
                payMainView.alpha = 0.0
                payMainView.isHidden = false
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.payMainView.alpha = 1.0
                }, completion: nil)
                
                payMainTextView.isEditable = false
                payMainTextView.isUserInteractionEnabled = false
            }
        }
    }
    @IBAction func payGoMain(_ sender: Any) {
        payMainView.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.payMainView.alpha = 0.0
        }, completion: { success in
            self.payMainView.isHidden = true
        })
    }
    
    @IBAction func payGoMainSe(_ sender: Any) {
        payMainViewSe.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.payMainViewSe.alpha = 0.0
        }, completion: { success in
            self.payMainViewSe.isHidden = true
        })
    }
    
    @IBAction func goToSafari(_ sender: Any) {
        if currentLocal == "KR"{
            if let url = URL(string: "http://unionc.co.kr/privacy.html"){
                UIApplication.shared.open(url, options: [:])
            }
        }else{
            if let url = URL(string: "http://unionc.co.kr/privacyeng.html"){
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func goToSafariSe(_ sender: Any) {
        if currentLocal == "KR"{
            if let url = URL(string: "http://unionc.co.kr/privacy.html"){
                UIApplication.shared.open(url, options: [:])
            }
        }else{
            if let url = URL(string: "http://unionc.co.kr/privacyeng.html"){
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
        return true
        
    }
        
    @IBAction func goToCredit(_ sender: Any) {
        self.creditView.isHidden = false
        creditView.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.creditView.alpha = 1.0
        }, completion: nil)
        
        creditScroll.contentOffset = CGPoint(x: 0.0, y: 0.0)
        let contentSize = self.creditScroll.contentSize
        let contentInset = self.creditScroll.contentInset
        let textViewBounds = self.creditScroll.bounds
        let newContentOffset = CGPoint(
            x: contentSize.width + contentInset.right - textViewBounds.width,
            y: contentSize.height + contentInset.bottom - textViewBounds.height
        )

        UIView.animate(withDuration: 20, delay: 0, options: [UIView.AnimationOptions.allowUserInteraction, UIView.AnimationOptions.curveLinear], animations: {
            self.creditScroll.contentOffset = newContentOffset
        }, completion: nil)
    }
    
    @IBAction func creditGoToMain(_ sender: Any) {
        creditView.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.creditView.alpha = 0.0
        }, completion: { success in
            self.creditView.isHidden = true
            self.creditScroll.layer.removeAllAnimations()
            self.creditScroll.contentOffset = CGPoint(x: 0.0, y: 0.0)
        })
    }
    
    func lottieChange(_ lottieName: String) {
        aniView.frame = CGRect(x: mainView.frame.width, y: mainView.frame.height, width: mainView.frame.width, height: mainView.frame.height) // 애니메이션뷰의 크기 설정
        aniView.center = self.view.center // 애니메이션뷰의 위치설정
        aniView.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
        self.mainMapView.addSubview(aniView)
        
        animationView = AnimationView(name: lottieName)
        animationView.frame = CGRect(x: mainView.frame.width, y: mainView.frame.height, width: mainView.frame.width, height: mainView.frame.height) // 애니메이션뷰의 크기 설정
        animationView.center = self.view.center // 애니메이션뷰의 위치설정
        animationView.contentMode = .scaleToFill // 애니메이션뷰의 콘텐트모드 설정
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        aniView.addSubview(animationView)
        self.mainMapView.insertSubview(aniView, aboveSubview: self.mainIslandBackground)
        animationView.play()
    }
    
    func scrollTextViewToBottom(_ textView: UITextView) {
        if(textView.text.count > 0 ) {
            guard let text = textView.text else {
                return
            }
            let bottom = NSRange(location: text.count - 1, length: 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func buttonLocal() {
        goDetailBt01.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt02.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt03.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt04.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt05.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt06.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt07.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt08.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt09.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt10.backgroundColor = UIColor(white: 1, alpha: 0.5)
        goDetailBt11.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        goDetailBt01.setTitle("1", for: .normal)
        goDetailBt02.setTitle("2", for: .normal)
        goDetailBt03.setTitle("3", for: .normal)
        goDetailBt04.setTitle("4", for: .normal)
        goDetailBt05.setTitle("5", for: .normal)
        goDetailBt06.setTitle("6", for: .normal)
        goDetailBt07.setTitle("7", for: .normal)
        goDetailBt08.setTitle("8", for: .normal)
        goDetailBt09.setTitle("9", for: .normal)
        goDetailBt10.setTitle("10", for: .normal)
        goDetailBt11.setTitle("11", for: .normal)
    }
    
    func deviceScale() {
        if preventButtonTouch == true {
            return
        }
        if UIDevice().userInterfaceIdiom == .phone {
//            print(UIScreen.main.nativeBounds.height)
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone se")
                lottieNum = 3
                mainIslandBackground.image = UIImage(named: "mainBg2")
                menuLine.frame = CGRect(x: 122.5, y: 48.5, width: 387, height: 182.5)
                mapButtonLeft.constant = 13
                stayButtonLeft.constant = 63
                stayBtLeft.constant = 63
                mapButtonTop.constant = 12
                epiButtonRight.constant = 13
                epiButtonTop.constant = 12
                noticeViewBottom.constant = 12
                tourImageViewLeft.constant = -1
                
                goDetailBt01.frame = CGRect(x: 90, y: 81.5, width: 106, height: 49)
                goDetailBt02.frame = CGRect(x: 367, y: 168, width: 55, height: 38)
                goDetailBt03.frame = CGRect(x: 174, y: 202, width: 105, height: 44)
                goDetailBt04.frame = CGRect(x: 449.5, y: 110, width: 68, height: 46.5)
                goDetailBt05.frame = CGRect(x: 306.5, y: 84.5, width: 62.5, height: 69.5)
                goDetailBt06.frame = CGRect(x: 76, y: 155, width: 118, height: 39)
                goDetailBt07.frame = CGRect(x: 223.5, y: 27.5, width: 76, height: 72.5)
                goDetailBt08.frame = CGRect(x: 373, y: 30, width: 63, height: 39.5)
                goDetailBt09.frame = CGRect(x: 310, y: 39, width: 57, height: 39.5)
                goDetailBt10.frame = CGRect(x: 302, y: 183, width: 53, height: 45)
                goDetailBt11.frame = CGRect(x: 470, y: 38, width: 49, height: 45)
                
                creditLeft.constant = 150
                creditRight.constant = 150
            case 1334:
                print("iPhone 6/6S/7/8")
                lottieNum = 2
                mainIslandBackground.image = UIImage(named: "mainBg2")
                mapButtonLeft.constant = 15
                stayButtonLeft.constant = 65
                stayBtLeft.constant = 65
                epiButtonRight.constant = 15.7
                buyNotiLabelLeft.constant = 20
                buyBTLeft.constant = 20
                buyExitRihgt.constant = 22
                noticeViewBottom.constant = 12
                tourImageViewLeft.constant = -1
                
                goDetailBt01.frame = CGRect(x: 140.5, y: 114, width: 80, height: 44)
                goDetailBt02.frame = CGRect(x: 429, y: 193.5, width: 67, height: 48.5)
                goDetailBt03.frame = CGRect(x: 271, y: 246, width: 44.5, height: 50)
                goDetailBt04.frame = CGRect(x: 514.5, y: 132.5, width: 35, height: 28)
                goDetailBt05.frame = CGRect(x: 380.5, y: 109.5, width: 34, height: 61)
                goDetailBt06.frame = CGRect(x: 130, y: 182.5, width: 83, height: 50)
                goDetailBt07.frame = CGRect(x: 275, y: 29.5, width: 69, height: 82)
                goDetailBt08.frame = CGRect(x: 440.5, y: 40, width: 51, height: 50)
                goDetailBt09.frame = CGRect(x: 367.5, y: 48, width: 50, height: 48)
                goDetailBt10.frame = CGRect(x: 367.5, y: 216, width: 38.5, height: 51)
                goDetailBt11.frame = CGRect(x: 565, y: 55, width: 74, height: 53.5)
                
                menuLine.frame = CGRect(x: 144, y: 57, width: 454.5, height: 214)
                
            case 2208:
                print("plus")
                lottieNum = 2
                mainIslandBackground.image = UIImage(named: "mainBg2")
                mapButtonLeft.constant = 15
                stayButtonLeft.constant = 65
                stayBtLeft.constant = 65
                epiButtonRight.constant = 15.7
                buyNotiLabelLeft.constant = 20
                buyBTLeft.constant = 20
                buyExitRihgt.constant = 22
                payMainTextViewTop.constant = 17
                noticeViewBottom.constant = 15
                
                goDetailBt01.frame = CGRect(x: 161.7, y: 126, width: 79.3, height: 47.3)
                goDetailBt02.frame = CGRect(x: 473.7, y: 213.7, width: 74, height: 52.3)
                goDetailBt03.frame = CGRect(x: 289, y: 271.3, width: 57, height: 43.7)
                goDetailBt04.frame = CGRect(x: 572, y: 155.3, width: 37.3, height: 27)
                goDetailBt05.frame = CGRect(x: 419.7, y: 121, width: 40, height: 67.3)
                goDetailBt06.frame = CGRect(x: 160, y: 201.7, width: 88.3, height: 54.3)
                goDetailBt07.frame = CGRect(x: 303.3, y: 32.3, width: 76, height: 85)
                goDetailBt08.frame = CGRect(x: 481.7, y: 53.3, width: 56.3, height: 48)
                goDetailBt09.frame = CGRect(x: 405.7, y: 60.7, width: 55.3, height: 45)
                goDetailBt10.frame = CGRect(x: 405.7, y: 239, width: 42.3, height: 54.7)
                goDetailBt11.frame = CGRect(x: 628.7, y: 60.7, width: 69.7, height: 59)
                
                menuLine.frame = CGRect(x: 159, y: 63, width: 501.3, height: 236)
                
            case 1920:
                print("plus")
                lottieNum = 2
                mainIslandBackground.image = UIImage(named: "mainBg2")
                mapButtonLeft.constant = 15
                stayButtonLeft.constant = 65
                stayBtLeft.constant = 65
                epiButtonRight.constant = 15.7
                buyNotiLabelLeft.constant = 20
                buyBTLeft.constant = 20
                buyExitRihgt.constant = 22
                payMainTextViewTop.constant = 17
                noticeViewBottom.constant = 15
            
                goDetailBt01.frame = CGRect(x: 161.7, y: 126, width: 79.3, height: 47.3)
                goDetailBt02.frame = CGRect(x: 473.7, y: 213.7, width: 74, height: 52.3)
                goDetailBt03.frame = CGRect(x: 289, y: 271.3, width: 57, height: 43.7)
                goDetailBt04.frame = CGRect(x: 572, y: 155.3, width: 37.3, height: 27)
                goDetailBt05.frame = CGRect(x: 419.7, y: 121, width: 40, height: 67.3)
                goDetailBt06.frame = CGRect(x: 160, y: 201.7, width: 88.3, height: 54.3)
                goDetailBt07.frame = CGRect(x: 303.3, y: 32.3, width: 76, height: 85)
                goDetailBt08.frame = CGRect(x: 481.7, y: 53.3, width: 56.3, height: 48)
                goDetailBt09.frame = CGRect(x: 405.7, y: 60.7, width: 55.3, height: 45)
                goDetailBt10.frame = CGRect(x: 405.7, y: 239, width: 42.3, height: 54.7)
                goDetailBt11.frame = CGRect(x: 628.7, y: 60.7, width: 69.7, height: 59)
                
                menuLine.frame = CGRect(x: 159, y: 63, width: 501.3, height: 236)
                
            case 2688:
                print("iPhone XMax")
                
                goDetailBt01.frame = CGRect(x: 218, y: 122, width: 104, height: 57)
                goDetailBt02.frame = CGRect(x: 551, y: 217, width: 86, height: 52)
                goDetailBt03.frame = CGRect(x: 351, y: 261, width: 82, height: 59)
                goDetailBt04.frame = CGRect(x: 650, y: 142, width: 42, height: 37)
                goDetailBt05.frame = CGRect(x: 481, y: 111, width: 68, height: 80)
                goDetailBt06.frame = CGRect(x: 218, y: 198, width: 96, height: 61)
                goDetailBt07.frame = CGRect(x: 393, y: 43, width: 57, height: 73)
                goDetailBt08.frame = CGRect(x: 561, y: 34, width: 63, height: 46)
                goDetailBt09.frame = CGRect(x: 480, y: 40, width: 68, height: 58)
                goDetailBt10.frame = CGRect(x: 467, y: 235, width: 66, height: 68)
                goDetailBt11.frame = CGRect(x: 694, y: 57, width: 60, height: 46)
                menuLine.frame = CGRect(x: 239, y: 59, width: 497, height: 237)
                mainIslandBackground.image = UIImage(named: "mainBg")
            case 1792:
                print("iPhone XR")
                
                goDetailBt01.frame = CGRect(x: 218, y: 122, width: 104, height: 57)
                goDetailBt02.frame = CGRect(x: 551, y: 217, width: 86, height: 52)
                goDetailBt03.frame = CGRect(x: 351, y: 261, width: 82, height: 59)
                goDetailBt04.frame = CGRect(x: 650, y: 142, width: 42, height: 37)
                goDetailBt05.frame = CGRect(x: 481, y: 111, width: 68, height: 80)
                goDetailBt06.frame = CGRect(x: 218, y: 198, width: 96, height: 61)
                goDetailBt07.frame = CGRect(x: 393, y: 43, width: 57, height: 73)
                goDetailBt08.frame = CGRect(x: 561, y: 34, width: 63, height: 46)
                goDetailBt09.frame = CGRect(x: 480, y: 40, width: 68, height: 58)
                goDetailBt10.frame = CGRect(x: 467, y: 235, width: 66, height: 68)
                goDetailBt11.frame = CGRect(x: 694, y: 57, width: 60, height: 46)
                menuLine.frame = CGRect(x: 239, y: 59, width: 497, height: 237)
                mainIslandBackground.image = UIImage(named: "mainBg")
            default:
                print("iPhone X")
                mainIslandBackground.image = UIImage(named: "mainBg")
            }
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
