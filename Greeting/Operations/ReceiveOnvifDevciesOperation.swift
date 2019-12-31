//
//  ReceiveOnvifDevciesOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class ReceiveOnvifDevciesOperation: UDPOperation {
    override func numberRequestType() -> Int32 {
        return 3
    }
    
    override func onReplyRequest(requestID _id: UInt64?, code: Int32, replyData: Data) {
        print("ReceiveOnvifDevciesOperation")
//        let probe = ProbeMatch(data: replyData)
//        print(probe.hardware)
    }
}
