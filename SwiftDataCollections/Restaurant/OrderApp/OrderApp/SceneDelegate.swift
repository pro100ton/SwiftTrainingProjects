//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Антон Шалимов on 18.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// Создаем ссылку на tab bar, баджи который мы хотим обновлять
    /// Force unwrap здесь используется так как если что-то пойдет не так (а баджики всегда должны работать), значит
    /// мы что-то поломали в приложении и оно справедливо крашится
    var orderTabBarItem: UITabBarItem!
    
    
    /// Объявляем функцию для обновления баджика заказа
    /// Значение берется из расшаренного статического экземпляра `MenuController`'а
    /// `@objc` аннотация нужна для того, чтобы можно было использовать эту функцию как selector в нашем вызове
    /// добавления observer'a: `addObserver(_:selector:name:object:)`
    @objc func updateOrderBadge() {
        /// Следующий код сделан для того, что если в заказе отсутствуют пункты то бадж отсутствует
        /// В противном случае присваивается кол-во пунктов в заказе
        switch MenuController.shared.order.menuItems.count{
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        /// Необходимое добавление проперти при первом запуске приложения для наблюдения за
        /// `orderUpdatedNotification` по аналогии с тем, что мы сделали в `OrderTabelViewController`
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOrderBadge),
                                               name: MenuController.orderUpdateNotification,
                                               object: nil)
        /// Следующая строка кода позволяет нам получить ссылку на элемент таба, который мы хотим использовать для
        /// отображения значка баджа, который показывает количество элементов в заказе.
        /// Это делается путем получения второго элемента нашей панели вкладок и использования его свойства tabBarItem
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

