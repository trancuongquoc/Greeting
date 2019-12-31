//
//  UDPCoreOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

open class UDPCoreOperation: BaseOperation {
    
    public var type : Int32 = 0
    public var tag  : UInt64 = 0
    public var replyData : Data?
    
    public var theClassName: String {
        
        return NSStringFromClass(self.classForCoder)
    }
    
    required public init() {
        super.init()
        self.type = self.numberRequestType()
        if let udp = Engine.shared.getComponent(type: .UDP) as? UDP{
            self.tag = udp.getRequetsID()
        }
    }
    
    
    public class func getClassName() -> String{
        return NSStringFromClass(self)
    }
    
    open func endpointAddress() -> String? {
        return nil
    }
    
    open func onDataSend() -> Data?{
        return buildRequest()
    }

    open func timeOutAfter() -> Double{
        return 10
    }
    
    open func numberRequestType() -> Int32{
        fatalError("Subclasses need to implement the `numberRequestType()` method.")
    }
    
    open func buildRequest() -> Data? {
        fatalError("Subclasses need to implement the `buildRequest()` method.")
    }
    
    open func onReplyRequest(requestID _id : UInt64?,code : Int32,replyData : Data){
        fatalError("Subclasses need to implement the `onReplyRequest` method.")
    }
    
    open func udpOperationTimeOut(){
        
    }
    
    func operationTimeOut(){
//        if let tcp = Engine.shared.getComponent(type: .UDP) as? UDP{
//
//        }
    }
    
    
    override open func main() {
        
        if self.replyData == nil {
            let requestData = self.onDataSend()
            
            if let udp = Engine.shared.getComponent(type: .UDP) as? UDP {
                if let data = requestData {
                    if let address = self.endpointAddress() {
                        udp.send(data, to: address, success: {
                        })
                    }
                }
            }
        } else {
            self.onReplyRequest(requestID: self.tag, code: self.type, replyData: self.replyData!)
        }
    }
    
}
