//
//  UDP.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/29/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public protocol UDPDelegate{
    func registerReceiveOperation()
}

public class UDP: NSObject, Component, GCDAsyncUdpSocketDelegate {
    
    private var outSocket: GCDAsyncUdpSocket!
    private var inSocket: GCDAsyncUdpSocket!
    private var multicastAddress = "239.255.255.250"
    private var port:UInt16 = 3702
    private var receiveOperationManager : Dictionary<Int32,Array<String>>!
    public  var delegate: UDPDelegate?
    private     var msgForID                : UInt64 = 0
    
    public func componentType() -> ComponentType {
        return .UDP
    }
    
    public init(delegate : UDPDelegate?) {
        super.init()
        self.delegate = delegate
        self.receiveOperationManager = Dictionary<Int32,Array<String>>()
        
    }
    
    public func start() throws {
        debugPrint("UDP Component Did Start")        
        if(self.delegate != nil){
            self.delegate!.registerReceiveOperation()
        }
        
    }
    
    public func getRequetsID() -> UInt64{
        self.msgForID = self.msgForID + 1
        return self.msgForID
    }
    
    func processReply(rep : Data,reType : Int32,requestID : UInt64) {
//        let op = ReadProbeResponseOperation()
//            op.data = rep
//            op.fire()
        
        if(self.receiveOperationManager[reType] != nil){
            debugPrint("receive Type : \(reType)")
            for cName in self.receiveOperationManager[reType] ?? []{
                if let aClass = NSClassFromString(cName) as? UDPCoreOperation.Type{
                    let c = aClass.init()
                    c.tag = requestID
                    c.type = reType
                    c.replyData = rep
                    c.fire()
                }
            }
            
        }
    }
    
    public func registerReceiveOperation(operationType : Int32,operationClassName : String){
        if(self.receiveOperationManager != nil){
            if(self.receiveOperationManager[operationType] == nil){
                self.receiveOperationManager[operationType] = [operationClassName]
            }
            else{
                if(self.receiveOperationManager[operationType]?.contains(operationClassName) == false){
                    self.receiveOperationManager[operationType]?.append(operationClassName)
                }
            }
        }
    }
    
    
    private func outSocketSetupConnection(success:(()->())){
        
        if outSocket != nil {
            outSocket = nil
        }
        
        outSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue:DispatchQueue.main)
        do { try outSocket.connect(toHost:multicastAddress, onPort: port)} catch {
            print("Error: outSocket not connect to ", multicastAddress, " on port ", port)
            return
        }
        do { try outSocket.beginReceiving()} catch {
            print("beginReceiving not procceed")
            return
        }
        
        
        success()
    }
    
    private func inSocketSetupConnection(port: UInt16) {
        
        if inSocket != nil {
            inSocket = nil
        }
        
        inSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue:DispatchQueue.main)
        do { try inSocket.bind(toPort: port)} catch {
            print("Error: inSocket not able to bind to ", port)
            return
        }
        do { try inSocket.beginReceiving()} catch {
            print("beginReceiving not procceed")
            return
        }
        
//        print("outsocket: local port \(outSocket.localPort()), connected port \(outSocket.connectedPort())")
//        print("insocket: local port \(inSocket.localPort()), connected port \(inSocket.connectedPort())")
        
        if inSocket.localPort() != outSocket.localPort() {
            self.inSocketSetupConnection(port: outSocket.localPort())
        }
    }
    
    private func closeSocket() {
        if outSocket != nil {
            if outSocket.isClosed() {
                outSocket.close()
                outSocket = nil
            }
        }
        
        if inSocket != nil {
            if inSocket.isClosed() {
                inSocket.close()
                inSocket = nil
            }
        }
    }
    
    
    func send(_ data: Data, to address: String, success:(()->())) {
        //        print("data send to: ", socket.connectedHost(), " ,on: ", socket.connectedPort(), " ,from: ", socket.localHost(), " ,on: ", socket.localPort())
        outSocketSetupConnection {
            if outSocket != nil {
                
                outSocket.send(data, withTimeout: 5, tag: 0)
                self.inSocketSetupConnection(port: outSocket.localPort())
                success()
            }
        }
    }
    
    public func stop() {
        debugPrint("UDP Component Did Stop")
    }
}

public extension UDP {
    //MARK:- GCDAsyncUdpSocketDelegate
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        var host: NSString?
        var port: UInt16 = 0
        GCDAsyncUdpSocket.getHost(&host, port: &port, fromAddress: address)
        debugPrint("Message from host: ", host ?? "")
        
        self.processReply(rep: data, reType: 2, requestID: 2)
    }
    
    //    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
    //        //        print("OutSocket didConnectToAddress")
    //    }
    //
    //    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
    //        if let _error = error {
    //            print("OutSocket didNotConnect \(_error )")
    //        }
    //    }
    //
    //    func udpSocketDidClose(_ sock: GCDAsyncUdpSocket, withError error: Error?) {
    //        debugPrint("OutSocket didClose, error: ", error)
    //    }
    //    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
    //        print("didNotSendDataWithTag")
    //    }
    //    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
    //        print("OutSocket didSendDataWithTag", tag)
    //    }
}
