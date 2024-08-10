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
    var player100: AVAudioPlayer?
    var player300: AVAudioPlayer?
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
        guard let url100 = Bundle.main.url(forResource: "potholeAlert100", withExtension: "mp3") else {
            print("item not avail")
            return
        }
        
        guard let url300 = Bundle.main.url(forResource: "potholeAlert300", withExtension: "mp3") else {
            print("item not avail")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player100 = try AVAudioPlayer(contentsOf: url100)
            player300 = try AVAudioPlayer(contentsOf: url300)
        }catch{
            print("error: \(error)")
        }
        
    }
    func playWarningAudio(warningType: WarningType){
        if warningType == .hundred{
            guard let player = player100 else {return}
            player.play()
        }else if warningType == .threeHundred{
            guard let player = player300 else {return}
            player.play()
        }
        
    }
}


protocol AudioWarning {
    var player100: AVAudioPlayer? {get set}
    var player300: AVAudioPlayer? {get set}
    func setupAudio()
    func playWarningAudio(warningType: WarningType)
}

protocol BackgroundNotification {
    var center: UNUserNotificationCenter {get}
    var trigger: UNTimeIntervalNotificationTrigger {get}
    func checkNotificationPermission() async
    func notifyUser(title: String, content: String) async
}

enum WarningType{
    case hundred, threeHundred
}
