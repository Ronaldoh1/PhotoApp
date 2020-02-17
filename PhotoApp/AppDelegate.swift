//
//  AppDelegate.swift
//  PhotoApp
//
//  Created by Hernandez, Ronald on 2/9/20.
//  Copyright © 2020 Ronaldoh1. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let bag = DisposeBag()
        
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject.takeUntil(trigger)
            .subscribe { print( $0)}
            .disposed(by: bag)

        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        
        trigger.onNext("X")
      
        subject.onNext("4")
        subject.onNext("5")
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

