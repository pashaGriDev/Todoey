//
//  AppDelegate.swift
//  Todoey
//
//  Created by Павел Грицков on 29.03.23.
//

import UIKit
import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // расположения базы данных Realm
//        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // блок миграции ниже статья про это
        // https://www.selmanalpdundar.com/solution-of-realm-migration-error-code-10.html
//        let config = Realm.Configuration(
//            schemaVersion: 1,
//            migrationBlock: { migration, oldSchemaVersion in
//                if (oldSchemaVersion < 1) {
//                }
//            })
        
        // еще один вариант миграции удалить приложение из симулятора, а потом установить заново.

//        Realm.Configuration.defaultConfiguration = config
        
        do {
            let _ = try Realm()
        } catch {
            print("Ошибка Realm \(error)")
        }
        
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

