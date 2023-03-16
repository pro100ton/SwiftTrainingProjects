//
//  ViewController.swift
//  AppEventCount
//
//  Created by Антон Шалимов on 02.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // View variables
    var sceneWillConnectCount = 0
    var sceneDidBecomeActiveCount = 0
    var sceneWillResignActiveCount = 0
    var sceneWillEnterForegroundCount = 0
    var sceneDidEnterBackgroundCount = 0
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    // View outlets
    @IBOutlet var applicationDidFinishLaunchingWithOptions: UILabel!
    @IBOutlet var applicationConfiguratedForConnections: UILabel!
    @IBOutlet var sceneWillConnectTo: UILabel!
    @IBOutlet var sceneDidBecomeActive: UILabel!
    @IBOutlet var sceneWillResignActive: UILabel!
    @IBOutlet var sceneWillEnterForeground: UILabel!
    @IBOutlet var sceneDidEnterBackground: UILabel!
    
    // View functions
    func updateUI() {
        applicationDidFinishLaunchingWithOptions.text = "The App launched \(appDelegate.launchCount) times"
        applicationConfiguratedForConnections.text = "The App configurated \(appDelegate.configurationForConnectingCount) times"
        sceneWillConnectTo.text = "Scene will connected count: \(sceneWillConnectCount)"
        sceneDidBecomeActive.text = "Scene did become active count: \(sceneDidBecomeActiveCount)"
        sceneWillResignActive.text = "Scene will resign active count: \(sceneWillResignActiveCount)"
        sceneWillEnterForeground.text = "Scene will enter foreground count: \(sceneWillEnterForegroundCount)"
        sceneDidEnterBackground.text = "Scene did enter background count: \(sceneDidEnterBackgroundCount)"
    }
}

