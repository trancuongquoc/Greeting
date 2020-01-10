//
//  BaseXMLOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

public class BaseXMLOperation: BaseOperation, XMLParserDelegate {
    
    var data: Data?
    var error: Error?
    
    private func parse(_ data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    
    open func processReply(reply:Any?,type:Int,errMsg:String?) {

    }
    
    override open func main() {
        guard let requestData = self.data else {
            fatalError("XML no data")
        }
        
        self.parse(requestData)
        debugPrint(self.theClassName)
    }
}
