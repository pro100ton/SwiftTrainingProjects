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
    
    /// Данный метод вызывается когда сцена уходит в background.
    /// Метод вызывается `UIKit`'ом, который запрашивает `NSUserActivity`, для возврата когда сцена вновь будет
    /// присоединена
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    
    /// Данный метод вызывается когда сцена вновь загружена, но до того как будут загружены все view и будет
    /// осуществлена загрузка приложения в foreground
    /// Аргумент `restoreInteractionStateWith` будет содержать `NSUserActivity` инстанс, который мы
    /// предоставили в методе `stateRestorationActivity`
    /// Далее этот инстанс `NSUserActivity` мы используем для восстановления состояния прилоежния
    func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity) {
        /// Тут происходит извлечение проперти `order`, если оно имеется в состоянии `NSUserActivity`
        if let restoredOrder = stateRestorationActivity.order {
            MenuController.shared.order = restoredOrder
        }
        
        /// Тут происходит проверка правильно ициализации нашего приложения перед запуском
        /// Функция выполняет серию проверок, чтобы убедиться, что представление приложения находится в
        ///     правильном состоянии, и если все проверки проходят успешно, она создает объект
        ///     `StateRestorationController` и извлекает `UITabBarController` из окна приложения.
        ///     Он также извлекает `CategoryTableViewController` из первого представления контроллера
        ///     `UITabBarController`. Если все эти шаги выполнены успешно, то мы можем продолжить
        ///     восстановление состояния, иначе функция просто завершается.
        /// Подробно про каждый шаг:
        /// На первом этапе создается новый объект `StateRestorationController`, используя переданный
        ///     `stateRestorationActivity`. Если создание этого объекта не удалось, то функция завершается.
        guard let restorationController = StateRestorationController(
            userActivity: stateRestorationActivity),
              /// Далее получаем `UITabBarController`, который является корневым контроллером текущего окна.
              /// Если это невозможно, то функция завершается.
                let tabBarController = window?.rootViewController as? UITabBarController,
              /// Далее проверям, что у `tabBarController` есть два дочерних контроллера.
              /// Если это условие не выполняется, то функция завершается.
                tabBarController.viewControllers?.count == 2,
              /// Далее получаем первый дочерний контроллер у tabBarController и убеждаемся, что это
              ///   UINavigationController. Затем извлекаем topViewController из этого UINavigationController и убеждаемся,
                ///   что это CategoryTableViewController. Если какой-то из этих контроллеров недоступен или не
                ///   соответствует ожидаемому типу, то функция завершается.
                let categoryTableViewController = (
                    tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController
                as? CategoryTableViewController
        else {
            return
        }
        
        /// Создаем ссылку на наш `Storyboard`
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch restorationController {
        case .categories:
            /// В случае если у нас в сохраненном состоянии контроллер с категориями - то ничего делать не надо, так как
            /// он загружается по умолчанию
            break
        case .order:
            /// В случае если у пользователя был открыт VC с заказом, то необходимо tab bar'у установить значение 1, что
            /// соответствует второй вкладке с заказом
            tabBarController.selectedIndex = 1
        case .menu(let category):
            /// В случае, если restorationController содержит значение .menu, то создается экземпляр контроллера
            /// MenuTableViewController, используя идентификатор и создатель, заданные в перечислении.
            let menuTableViewController = storyboard.instantiateViewController(
                identifier: restorationController.identifier.rawValue,
                creator: {(coder) in
                    return MenuTableViewController(coder: coder, category: category)
                })
            /// Затем созданный контроллер помещается в навигационный контроллер, который уже содержится в первой
            /// вкладке таб-бара. Это позволяет перейти на страницу меню с определенной категорией.
            categoryTableViewController.navigationController?.pushViewController(
                menuTableViewController, animated: true)
        case .menuItemDetail(let menuItem):
            /// В случае, если restorationController содержит значение .menuItemDetail, то создаются экземпляры
            /// MenuTableViewController и MenuItemDetailViewController, используя идентификаторы и создателей,
            /// заданные в перечислении.
            ///
            /// Инциализируются два контроллера (хотя вроде бы нужны только детали пункта меню), потому что по
            /// нашей логике приложения в пункт с деталями блюда можно перейти только через выделение
            /// элемента на MenuTableViewController, поэтому необходимо инициализировать и его
            let menuTableViewController = storyboard.instantiateViewController(
                identifier: StateRestorationController.Identifier.menu.rawValue,
                creator: { (coder) in
                    return MenuTableViewController(coder: coder, category: menuItem.category)
                })
            let menuItemDetailViewController = storyboard.instantiateViewController(
                identifier: restorationController.identifier.rawValue,
                creator: { (coder) in
                    return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
                })
            /// Затем созданные контроллеры помещаются в навигационный контроллер, который уже содержится в
            /// первой вкладке таб-бара. Это позволяет перейти на страницу с деталями конкретного элемента меню.
            categoryTableViewController.navigationController?.pushViewController(
                menuTableViewController,
                animated: false)
            categoryTableViewController.navigationController?.pushViewController(
                menuItemDetailViewController,
                animated: false)
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

