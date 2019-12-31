//
//  ViewComponent.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/26/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import UIKit

class ViewComponent: Component {
    
    func componentType() -> ComponentType {
        return ComponentType.View
    }
    
    func stop() {
        
    }
    
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

}
