//
//  Engine.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/27/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

/*
   Engine used:
   - register component
   - Save listComponent registered
   - get component
   -
*/

import Foundation

open class Engine {
    
    //MARK: - init singleton
    public static let shared : Engine = {
        let instance = Engine()
        return instance
    }()

    //Components to be registered for use.
    private(set) var componentsToBeRegisterd : Registrations?
    
    //MARK: - Saved Component
    var components: [ComponentType:Component] = [:]
    var isStarted: Bool = false
    
    open func start(with registeredComponent: Registrations) {
        if !isStarted {
            self.componentsToBeRegisterd = registeredComponent
            isStarted = true
            componentsToBeRegisterd?.registerComponents()
            Engine.shared.startComponents()
        }
        
        debugPrint("ENGINE DID START")
    }
    
    open func registerComponent(component: Component) {
        self.components[component.componentType()] = component
    }
    
    //Start the components which are already registered for use.
    open func startComponents() {
        
        for component in self.components.sorted(by: { (a, b) -> Bool in
            return (a.value.priority?() ?? 1000).compare(b.value.priority?() ?? 1000) == ComparisonResult.orderedAscending
        }) {
            do{
                try component.value.start()
            }catch{
                // Start error
            }
            
        }
        
    }
    
    open func stopComponents() {
            for component in self.components.sorted(by: { (a, b) -> Bool in
                return (a.value.priority?() ?? 1000).compare(b.value.priority?() ?? 1000) == ComparisonResult.orderedDescending
            }) {
                component.value.stop()
            }
            self.removeComponent()
    }
    
    open func removeComponent(){
        
    }
    
    open func getComponent(type : ComponentType) -> Component? {
        
        if let component = self.components[type]{
            return component
        }
        return nil
    }

}
