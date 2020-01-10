//
//  BaseOpertaion.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/29/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation
open class BaseOperation: Operation {
    
    
    public lazy var uid : String = UUID().uuidString
    public lazy var event_error : String = "error_\(self.uid)"
    public lazy var event_success : String = "success_\(self.uid)"
    public lazy var event_timeOut : String = "time_out_\(self.uid)"
    
    public var theClassName: String {
        
        return NSStringFromClass(self.classForCoder)
    }

    required override public init() {
        super.init()
    }
        
    //MARK: - ready state
    override open func start() {
        
        // init code here
       super.start()
    }
    
    override open func main() {
        if isCancelled {
            return
        }
        
    }
    
        //MARK: - Fire operation
    open func fire() {
        if self.isReady && !self.isExecuting && !self.isFinished {
            let operations:OperationManage = Engine.shared.getComponent(type: .Operations) as! OperationManage
            operations.enqueue(operation: self)
            
        }
    }
    
    open func addSuccessEvent(event : Event){
        Events.instance().listenTo(with: event_success, event: event)
    }
    open func addErrorEvent(event : Event){
        Events.instance().listenTo(with: event_error, event: event)
    }
    open func addTimeOutEvent(event : Event){
        Events.instance().listenTo(with: event_timeOut, event: event)
    }
    open func sendSuccessEvent(param : Any?){
        Events.instance().trigger(eventName: event_success, information: param)
    }
    open func sendErrorEvent(param : Any?){
        Events.instance().trigger(eventName: event_error, information: param)
    }
    open func sendTimeOutEvent(param : Any?){
        Events.instance().trigger(eventName: event_timeOut, information: param)
    }
    
    
    
}
