//
//  UdpOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class UDPOperation: UDPCoreOperation {
    override func udpOperationTimeOut() {
        super.udpOperationTimeOut()
    }
    
    override func onDataSend() -> Data? {
        if let data = self.buildRequest() {
            return data
        }
        
        return nil
    }
}
