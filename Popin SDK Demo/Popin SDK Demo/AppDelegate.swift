//
//  AppDelegate.swift
//  Popin SDK Demo
//

import UIKit
import PopinCall

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        NSLog("[Popin] AppDelegate: didFinishLaunchingWithOptions START")

        let config = PopinConfig.Builder()
            .userName("Demo Vishal")
            .contactInfo("demo@example.com")
            .secondaryProductText("Car details")
            .expertDesignation("Car Expert")
            .sandboxMode(true)
            .hideFlipCameraButton(true)
            .enableDebugMode(true)
            .enableIncomingCalls(true)
            .build()

        Popin.initialize(token: 51, config: config)
        Popin.registerForVoIPPushes()

        NSLog("[Popin] AppDelegate: didFinishLaunchingWithOptions END")
        return true
    }
}
