//
//  HTTPCoreOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/7/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

class HTTPCoreOperation: BaseOperation {
    
    public var requestBuildData : Data?
    
    
    required public init() {
        super.init()
        
    }
    open func httpMethod() -> HTTPMethods {
        return .POST
    }
    
    open func httpParserOnSuccess() -> ContentParser{
        return .DEFAULT
    }
    
    open func httpHeader() -> Dictionary<String,String>? {
        return nil
    }
    
    open func requestURL() -> String {
        fatalError("This method must be overriden by the subclass")
    }
    
    
    open func buildRequest() -> Data? {
        return nil
    }
    
    open func processReply(reply:Any?,errMsg:String?,error:HttpError?) {

    }
    
    func text(with data : Data) -> String?{
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func json(with data : Data) -> Any?{
        do{
            
            let re = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            return re
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
    override open func main() {
        let requestData = self.buildRequest()
        let url = self.requestURL()
        let method = self.httpMethod()
        
        if let http: HTTP = Engine.shared.getComponent(type: .HTTP) as! HTTP? {
            http.makeRequest(withType: method, requestURLString: url, header: self.httpHeader(), params: requestData, success: { (data) in
                DispatchQueue.main.async {
                    switch self.httpParserOnSuccess(){
                    case .DEFAULT :
                        self.processReply(reply: data, errMsg: nil, error: nil)
                    case .JSON:
                        self.processReply(reply: self.json(with: data), errMsg: nil, error: nil)
                    case .TEXT:
                        self.processReply(reply: self.text(with: data), errMsg: nil, error: nil)
                    }
                    
                    
                }
            }) { (errMsg, error) in
                DispatchQueue.main.async {
                    self.processReply(reply: nil, errMsg: errMsg, error: error)
                }
                
            }
            
        }
    }
    
}
