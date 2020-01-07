//
//  Registrations.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/27/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

open class Registrations: NSObject {
    
    open func registerComponents() {
        Engine.shared.registerComponent(component: Events())
        Engine.shared.registerComponent(component: OperationManage())
    }
}
