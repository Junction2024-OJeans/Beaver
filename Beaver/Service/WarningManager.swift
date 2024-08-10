//
//  WarningManager.swift
//  Beaver
//
//  Created by Hyun Lee on 8/11/24.
//

import Foundation
import AVFoundation
import UserNotifications
import SwiftUI

class WarningManager: ObservableObject{
    @EnvironmentObject var locationManager: LocationManager
    
    internal let center = UNUserNotificationCenter.current()
    internal let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
    var player: AVAudioPlayer?
}

extension WarningManager: BackgroundNotification {
    
    func checkNotificationPermission() async { //앱 실행 할때 필요
        do{
            try await center.requestAuthorization(options: [.alert, .sound])
        }catch{
            print("Error in getting notification permissions: \(error)")
        }
    }
    
    func notifyUser(title: String, content: String) async {
        let notifContent = UNMutableNotificationContent()
        notifContent.title = title
        notifContent.body = content
        let request = UNNotificationRequest(identifier: "abcds", content: notifContent, trigger: trigger)
        do {
            try await center.add(request)
        }catch{
            print("Error in sending notification: \(error )")
        }
    }
}

extension WarningManager: AudioWarning {
    func setupAudio(){ //이 친구는 알림 시작 버튼 누를때 사용 필요
        guard let url = Bundle.main.url(forResource: "tempWarningAudio2", withExtension: "wav") else {
            print("item not avail")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
        }catch{
            print("error: \(error)")
        }
        
    }
    func playWarningAudio(){
        guard let player = player else {return}
        player.play()
    }
}


protocol AudioWarning {
    var player: AVAudioPlayer? {get set}
    func setupAudio()
    func playWarningAudio()
}

protocol BackgroundNotification {
    var center: UNUserNotificationCenter {get}
    var trigger: UNTimeIntervalNotificationTrigger {get}
    func checkNotificationPermission() async
    func notifyUser(title: String, content: String) async
}
