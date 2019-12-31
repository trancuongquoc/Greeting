//
//  Events.swift
//  CoreEngine
//
//  Created by Quoc Cuong on 12/9/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

public struct EventName {
    public struct core {
        public static let udp_did_receive_data: String = "udp_did_receive_data"
        public static let did_receive_probematch: String = "did_receive_probematch"
        public static let did_receive_onvif_device: String = "did_receive_onvif_device"
    }
}
public struct Event {
    public var autoDelete : Bool = false
    public var action : ((_ param : Any?) -> Void)
    
    public init(with action:@escaping ((_ param : Any?) -> Void),isAutoDelete : Bool = false) {
        self.action = action
        self.autoDelete = isAutoDelete
    }
}

open class Events : Component  {
    
    var listeners : Dictionary<String, Dictionary<String,Event>>!
    
    public class func instance() -> Events {
        return Engine.shared.getComponent(type: .Event) as! Events
    }
    
    init() {
         listeners = Dictionary<String, Dictionary<String,Event>>()
    }
    
    public func start() {
       debugPrint("EventComponent Did Start")
    }
    
    public func stop() {
        self.removeEvent()
    }
    
    public func componentType() -> ComponentType {
        return ComponentType.Event
    }
    public func priority() -> NSNumber? {
        return NSNumber(integerLiteral: 0)
    }
    // Thêm 1 listener không chứa data
    // + eventName: Matching trigger eventNames will cause this listener to fire
    // + action: The block of code you want executed when the event triggers
    public func listenTo(eventName : String,event : Event) -> String{
        let key = UUID().uuidString
        if(listeners[eventName] != nil){
            listeners[eventName]?[key] = event
        }
        else{
            listeners[eventName] = [key:event]
        }
        return key
    }
    public func listenTo(with eventName : String,event : Event){
        let key = UUID().uuidString
        if(listeners[eventName] != nil){
            listeners[eventName]?[key] = event
        }
        else{
            listeners[eventName] = [key:event]
        }
    }
    
    public func listenTo(with eventName : String,key: String,event : Event){
        if(listeners[eventName] != nil){
            listeners[eventName]?[key] = event
        }
        else{
            listeners[eventName] = [key:event]
        }
    }
    public func replate(with eventName : String,toEventName : String){
        if(listeners[eventName] != nil){
            let e = listeners.removeValue(forKey: eventName)
            listeners[toEventName] = e
        }
    }
    
    public func removeEvent(with eventName : String? = nil,eventId : String = ""){
        if(eventName == nil){
            // remove all
            self.listeners.removeAll()
        }else{
            if(eventId == ""){
                self.listeners.removeValue(forKey: eventName ?? "")
            }else{
                if(self.listeners[eventName ?? ""] != nil){
                    let _ = self.listeners[eventName ?? ""]?.removeValue(forKey: eventId)
                }
                
            }
        }
    }
    
    // Triggers an event
    // + eventName: Matching listener eventNames will fire when this is called
    // + information: pass values to your listeners
    public func trigger(eventName : String, information : Any? = nil) {
        if self.listeners == nil {
            return
        }
        if let actionObjects = self.listeners[eventName] {
            for v in actionObjects{
                v.value.action(information)
                if(v.value.autoDelete){
                    let _ = self.listeners[eventName]?.removeValue(forKey: v.key)
                }
            }
        }
    }
}
