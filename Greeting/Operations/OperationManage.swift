//
//  OperationManager.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/29/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

open class OperationManage: Component {
    let operationQueue: OperationQueue = OperationQueue()
    
    init() {
        // Set thuộc tính cho queue
        self.operationQueue.maxConcurrentOperationCount = ProcessInfo.processInfo.activeProcessorCount * 4//OperationQueue.defaultMaxConcurrentOperationCount
        self.operationQueue.qualityOfService = .default
        
    }
    
    open func start() {
        debugPrint("OperationComponent Did Start")
    }
    
    open func stop() {
        self.operationQueue.cancelAllOperations()
    }
    
    open func componentType() -> ComponentType {
        return ComponentType.Operations
    }
    //MARK: - Add operation
    open func enqueue(operation:BaseOperation) {
        self.operationQueue.addOperation(operation)
    }
    
    open func dequeue(operation:BaseOperation) {
        for op in self.operationQueue.operations {
            if op == operation {
                operation.cancel()
            }
        }
    }
}
