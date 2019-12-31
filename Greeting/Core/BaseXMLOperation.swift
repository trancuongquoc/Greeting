//
//  BaseXMLOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

public class BaseXMLOperation: BaseOperation, XMLParserDelegate {
    
    open func buildRequest() -> Data?{
        fatalError("Subclasses need to implement the `buildRequest()` method.")
    }
    
    private func parse(_ data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    
    open func processReply(reply:Any?,type:Int,errMsg:String?) {

    }
    
    override open func main() {
        guard let requestData = self.buildRequest() else {
            self.processReply(reply: nil, type: 1, errMsg: "XML: No request data.")
            return
        }
        
        self.parse(requestData)
    }
    
    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    open func parser(_ parser: XMLParser, foundCharacters string: String) {

    }
    
    open func parserDidEndDocument(_ parser: XMLParser) {
        
    }
}
