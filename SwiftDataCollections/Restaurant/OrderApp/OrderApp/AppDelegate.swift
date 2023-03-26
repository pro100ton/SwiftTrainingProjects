//
//  AppDelegate.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /// Получаем путь до временной директории пользователя с помощью функции `NSTemporaryDirectory()`
        let temporaryDirectory = NSTemporaryDirectory()
        
        /// Создаем объект `URLCache`, с помощью которого задаем объеем треубемой для выделения:
        /// Оперативной памяти
        /// Памяти на диске устройства
        /// Пусть до временной папки (до диска) пользователя
        let urlCache = URLCache(
            memoryCapacity: 25_000_000,
            diskCapacity: 50_000_000,
            diskPath: temporaryDirectory)
        
        /// Присваиваем заданные выше параметры кэша для `shared` кэша, чтобы `URLSession` использовала эти
        /// настройки при осуществлении веб запросов
        URLCache.shared = urlCache
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

