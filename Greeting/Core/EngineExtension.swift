//
//  EngineExtension.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/27/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class ComponentRegister: Registrations {
    override func registerComponents() {
        super.registerComponents()
        Engine.shared.registerComponent(component: ViewComponent())
//        Engine.shared.registerComponent(component: DiscoveryComponent())
//        Engine.shared.registerComponent(component: UDP())
        Engine.shared.registerComponent(component: UDP(delegate: UDPDelegateRegister()))
    }
}

extension Engine{
    func getViewComponent() -> ViewComponent?{
        return Engine.shared.getComponent(type: ComponentType.View) as? ViewComponent
    }
    
//    func getDiscoveryComponent() -> DiscoveryComponent?{
//        return Engine.shared.getComponent(type: ComponentType.WSDiscovery) as? DiscoveryComponent
//    }
    
    func getOperationComponent() -> OperationManage? {
        return Engine.shared.getComponent(type: .Operations) as? OperationManage
    }

}

class UDPDelegateRegister: OnvifUDPDelegate {
    override func registerReceiveOperation() {
        super.registerReceiveOperation()
        if let udp = Engine.shared.getComponent(type: .UDP) as? UDP {
            udp.registerReceiveOperation(operationType: 2, operationClassName: ReceiveOnvifDevciesOperation.getClassName())
        }
    }
}

open class OnvifUDPDelegate: UDPDelegate {
    public init() { }
    
    open func registerReceiveOperation() {
        
    }
    
    
}


