//
//  IntroViewController.swift
//  ADRE
//
//  Created by youngwoo Choi on 02/05/2019.
//  Copyright © 2019 youngwoo Choi. All rights reserved.
//

import UIKit
import AVFoundation

class IntroViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var introView: UIImageView!
    @IBOutlet weak var inrtoImage: UIImageView!
    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet var introMainView: UIView!
    
    var audioPlayer: AVAudioPlayer!
    var selectImage:UIImageView!
    var currentImage = 0
    var state:String = "on"
    var data = ""
    var selectFrame:CGRect!
    var audioChek: Bool = true
    var currentLocal = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
        if locale.regionCode == nil{
            self.currentLocal = "KR"
        }else{
            self.currentLocal = locale.regionCode!
        }
        
        initPlayer()
        playCheck()
        
        introView.image = UIImage(named: "tutorialBg")
        inrtoImage.image = UIImage(named: "tutorialImg")
        inrtoImage.contentMode = .scaleToFill
        
        introTextView.text = "더 깊은 당신의 여행을 위해\n이어폰이나 헤드셋을 권장드립니다."
        if currentLocal != "KR"{
            introTextView.text = "더 깊은 당신의 여행을 위해\n이어폰이나 헤드셋을 권장드립니다.".localized
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        introTextView.attributedText = NSAttributedString(string: introTextView.text, attributes: attributes)
        introTextView.textAlignment = .center    // 가운데 정렬
        introTextView.isEditable = false         // 수정 금지
        introTextView.isScrollEnabled = false    // 스크롤 금지
        introTextView.isSelectable = false
        introTextView.alpha = 1.0
        introTextView.textColor = UIColor.init(displayP3Red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 0.6)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
//                print("iPhone 5 or 5S or 5C")
                introTextView.font = UIFont.boldSystemFont(ofSize: 12)
            default:
//                print("default")
                introTextView.font = UIFont.boldSystemFont(ofSize: 15)
            }
        }
        
        let time = DispatchTime.now() + 3.0
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            self.performSegue(withIdentifier: "showMain", sender: self)
        }
    }
    
    func initPlayer(){
        do{
            if let path = Bundle.main.path(forResource: "1.메인화면(A)", ofType: "mp3"){
                let url = URL(fileURLWithPath: path)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer.prepareToPlay()
            }
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playCheck() {
        audioChek = audioPlayer.isPlaying
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMain"{
            let detailVC = segue.destination as! ViewController
            detailVC.data = "introReceive"
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}



