//
//  SucheVC.swift
//  Trashy
//
//  Created by Kai Zheng on 02.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import Speech
import AudioToolbox

class SucheVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, SFSpeechRecognizerDelegate, UISearchBarDelegate {
    
    var trashImageArray = ["TrashBlau", "TrashGrau", "TrashBraun", "TrashGelb"]
    var recordingTimer: Timer?
    
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier:"zh_Hans"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var tabBarView: RoundView!
    @IBOutlet weak var sucheTabelView: UITableView!
    @IBOutlet weak var sucheCollectionView: UICollectionView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var sucheSearchBar: UISearchBar!
    @IBOutlet weak var recordingImageView: RoundImageView!
    @IBOutlet weak var recordingShadowView: RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        sucheCollectionView.layer.zPosition += 1
        tabBarView.layer.zPosition += 1
        recordingImageView.layer.zPosition += 1
        recordingShadowView.layer.zPosition += 1
        setUpShatten(view: tabBarView, op: 0.5, radius: 20.0)
        setUpShatten(view: recordingShadowView, op: 0.3, radius: 8.0)
        
        self.recordingImageView.alpha = 0.0
        self.recordingShadowView.alpha = 0.0
        
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization {
            status in
            var buttonState = false
            switch status {
            case .authorized:
                buttonState = true
                print("Permission received")
            case .denied:
                buttonState = false
                print("User did not give permission to use speech recognition")
            case .notDetermined:
                buttonState = false
                print("Speech recognition not allowed by user")
            case .restricted:
                buttonState = false
                print("Speech recognition not supported on this device")
            }
            DispatchQueue.main.async {
                self.recordButton.isEnabled = buttonState
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sucheTabelView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sucheCell = tableView.dequeueReusableCell(withIdentifier: "SucheCell") as! SucheTVCell
        
        setUpShatten(view: sucheCell.sucheView, op: 0.3, radius: 8.0)
        
        return sucheCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trashImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCell", for: indexPath) as! TrashCVCell
        
        trashCell.trashImageView.image = UIImage.init(named: trashImageArray[indexPath.row])
        
        return trashCell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //hideKeyboard()
    }
    
    func hideKeyboard() {
        sucheSearchBar.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print(notification.name)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.size.height else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            print("Hi")
            tabBarView.frame.origin.y = screenHeight - keyboardRect.height - tabBarView.frame.height + 25.0
            sucheCollectionView.alpha = 0.0
        } else {
            print("Hiii")
            tabBarView.frame.origin.y = screenHeight - tabBarHeight + 25.0 - tabBarView.frame.height
            sucheCollectionView.alpha = 1.0
        }
    }
    
    @IBAction func recordButtonAction(_ sender: Any) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.recordingImageView.alpha = 0.0
            self.recordingShadowView.alpha = 0.0
            self.stopTimer(timer: &self.recordingTimer)
        })
    }
    
    @IBAction func recordButtonTouchDownAction(_ sender: Any) {
        startRecording()
        setUpRecordingImageView()
    }
    
    func setUpRecordingImageView() {
        self.recordingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.addPulse), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.recordingImageView.alpha = 1.0
            self.recordingShadowView.alpha = 1.0
        })
    }
    
    @objc func addPulse(){
        let pulse = Pulsing(numberOfPulses: 1, radius: 180, position: recordingImageView.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = UIColor.init(named: "TrashyBlue")?.cgColor
        
        self.view.layer.insertSublayer(pulse, below: recordingImageView.layer)
    }
    
    func stopTimer(timer: inout Timer?) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func startRecording() {
        if recognitionTask != nil { //used to track progress of a transcription or cancel it
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue:
                convertFromAVAudioSessionCategory(AVAudioSession.Category.record)), mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to setup audio session")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest() //read from buffer
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Could not create request instance")
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) {
            res, err in
            var isLast = false
            if res != nil { //res contains transcription of a chunk of audio, corresponding to a single word usually
                isLast = (res?.isFinal)!
            }
            if err != nil || isLast {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                let bestStr = res?.bestTranscription.formattedString
                //var inDict = self.locDict.contains { $0.key == bestStr}
                
                //if inDict {
                    self.sucheSearchBar.text = bestStr
                //}
                //else {
                //    self.sucheSearchBar.text = "can't find it in the dictionary"
                //}
            }
        }
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
            buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Can't start the engine")
        }
    }
    
    fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
        return input.rawValue
    }
}
