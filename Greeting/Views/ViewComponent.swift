//
//  ViewComponent.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/26/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import UIKit

class ViewComponent {
    
    public static let shareInstance : ViewComponent = {
        let instance = ViewComponent()
        return instance
    }()
    
    var mainWindow : UIWindow? = UIApplication.shared.keyWindow

     func start() {
            debugPrint("ViewComponent Did Start")
            if(mainWindow == nil){
                mainWindow = UIWindow(frame: UIScreen.main.bounds)
                if #available(iOS 13.0, *) {
                    mainWindow?.overrideUserInterfaceStyle = .light
                }
                mainWindow?.rootViewController = ViewController()
                mainWindow?.makeKeyAndVisible()
            }
    }
    
    func getRootView() -> UIViewController?{
        self.mainWindow?.rootViewController?.modalPresentationStyle = .fullScreen
        return self.mainWindow?.rootViewController
    }

    func getTopView() -> UIViewController?{
        if let root = self.getRootView(){
            if(root.presentedViewController != nil){
                return root.presentedViewController
            }else{
                return root
            }
        }
        return nil
    }

    
    func showGreetingView(person: Person) {
        let title = "Welcome"
        let msg = "Hello " + person.name
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Thanks", style: .default, handler: nil))
        
        self.getTopView()?.present(alert, animated: true, completion: nil)
    }
}
