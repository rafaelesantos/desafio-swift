//
//  SceneDelegate.swift
//  Main
//
//  Created by Rafael Escaleira on 14/06/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = EventsComposer.composeControllerWith(getEvents: UseCaseFactory.makeRemoteGetEvents())
        window?.makeKeyAndVisible()
    }
}

