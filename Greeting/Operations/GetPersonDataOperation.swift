//
//  GetPersonDataOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/26/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class GetPersonDataOperation {
    
    public lazy var uid : String = UUID().uuidString
    public lazy var event_error : String = "error_\(self.uid)"
    public lazy var event_success : String = "success_\(self.uid)"
    public lazy var event_timeOut : String = "time_out_\(self.uid)"

    init() {
        
    }
    
    func getData() {
        var persons = [Person]()
        
        let person = Person()
        person.name = "Phuc XO"
        persons.append(person)
        
        let person1 = Person()
        person1.name = "Kha'"
        persons.append(person1)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.onReply(success: false, reply: persons)
        }
    }
    
    func onReply(success: Bool, reply: [Person]) {
        if success {
            PersonComponent.shared.list_person.append(contentsOf: reply)
            self.sendSuccessEvent(param: reply)
        } else {
            self.sendErrorEvent(param: "GetPersonDataOperationError")
        }
    }
    
    open func fire() {
        self.getData()
    }
    
    open func addSuccessEvent(event : Event){
        Events.shareInstance.listenTo(with: event_success, event: event)
    }
    open func addErrorEvent(event : Event){
        Events.shareInstance.listenTo(with: event_error, event: event)
    }
    open func addTimeOutEvent(event : Event){
        Events.shareInstance.listenTo(with: event_timeOut, event: event)
    }
    open func sendSuccessEvent(param : Any?){
        Events.shareInstance.trigger(eventName: event_success, information: param)
    }
    open func sendErrorEvent(param : Any?){
        Events.shareInstance.trigger(eventName: event_error, information: param)
    }
    open func sendTimeOutEvent(param : Any?){
        Events.shareInstance.trigger(eventName: event_timeOut, information: param)
    }
}
