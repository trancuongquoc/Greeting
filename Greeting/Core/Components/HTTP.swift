//
//  HTTP.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/7/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

public enum HTTPMethods {
    case POST, GET, PUT, PATCH, DELETE
}
public enum ContentParser {
    case JSON, TEXT, DEFAULT
}

public enum HttpError : Error{
    case server_error
    case unknow_error
    case connect_error
}

open class HTTP : NSObject, Component,URLSessionTaskDelegate,URLSessionDataDelegate {
    public func componentType() -> ComponentType {
        return .HTTP
    }
    
    public func start() throws {
        debugPrint("HTTP Component Did Start")
    }
    
    public func stop() {
        self.session.reset {
            debugPrint("URLSession reset")
        }

        debugPrint("HTTP Component Did Stop")
    }
    
    
    lazy var cachesDirectoryPath: URL = {
        let documents = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        return documents
    }()
    
    private let statusCodesMessage = [
        
        100: "Continue", 101: "Switching Protocols", 102: "Processing",
        200: "OK", 201: "Created", 202: "Accepted", 203: "Non Authoritative Information",
        204: "No Content", 205: "Reset Content", 206: "Partial Content", 207: "Multi-Status",
        300: "Multiple Choices", 301: "Moved Permanently", 302: "Moved Temporarily", 303: "See Other",
        304: "Not Modified", 305: "Use Proxy", 307: "Temporary Redirect",
        400: "Bad Request", 401: "Unauthorized", 402: "Payment Required", 403: "Forbidden", 404: "Not Found",
        405: "Method Not Allowed", 406: "Not Acceptable", 407: "Proxy Authentication Required",
        408: "Request Timeout", 409: "Conflict", 410: "Gone", 411: "Length Required",
        412: "Precondition Failed", 413: "Request Entity Too Large", 414: "Request-URI Too Long",
        415: "Unsupported Media Type", 416: "Requested Range Not Satisfiable", 417: "Expectation Failed",
        419: "Insufficient Space on Resource", 420: "Method Failure", 422: "Unprocessable Entity",
        424: "Failed Dependency", 428: "Precondition Required", 429: "Too Many Requests",
        431: "Request Header Fields Too Large",
        500: "Server Error", 501: "Not Implemented", 502: "Bad Gateway", 503: "Service Unavailable",
        504: "Gateway Timeout", 505: "HTTP Version Not Supported", 507: "Insufficient Storage",
        511: "Network Authentication Required"
    ]
    
    public var listTaskSuccess = Dictionary<URLSessionTask,((_ responseData : Data) -> Void)>()
    public var listTaskFailure = Dictionary<URLSessionTask,((_ errorMessage: String?,_ er : HttpError?) -> Void)>()

    var session : URLSession!

    open func priority() -> NSNumber? {
        return NSNumber(integerLiteral: 0)
    }
    
    override init() {
        super.init()
        
        let config = URLSessionConfiguration.default//URLSessionConfiguration.background(withIdentifier: "dung.nt.vivas.viettalk")
        
//        config.timeoutIntervalForRequest = 20
//        config.timeoutIntervalForResource = 20
//        config.httpMaximumConnectionsPerHost = 8
//
//        config.isDiscretionary = true
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }

    public func makeRequest(withType requestType : HTTPMethods,requestURLString : String,header : Dictionary<String,String>?,params: Data?,success:@escaping((_ responseData : Data) -> Void),failure:@escaping ((_ errorMessage: String?,_ er : HttpError?) -> Void)){

        var request = URLRequest(url: URL(string: requestURLString)!)
        if(requestType == .GET){ request.httpMethod = "GET" }
        else if(requestType == .POST){ request.httpMethod = "POST" }
        else if(requestType == .PUT){ request.httpMethod = "PUT" }
        else if(requestType == .PATCH){ request.httpMethod = "PATCH" }
        else{ request.httpMethod = "DELETE" }
        
        
        if(header != nil){

            for key in header!.keys{
                request.setValue(header![key], forHTTPHeaderField: key)
            }
        }

        if params != nil {
            request.httpBody = params
        }
        
                let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//                    print(response as Any)
                    if let HTTPResponse = response as? HTTPURLResponse {
                        let statusCode = HTTPResponse.statusCode
                        
                        if statusCode == 200 {
                            if data != nil {
                                success(data!)
                            }
                        }
                        
                    }
                    
        //            let reply = String(data: data!, encoding: .utf8)
        //            print(reply)
                    
                    
                    if error != nil {
                        failure(error?.localizedDescription, HttpError.unknow_error)
                    }
                })
                task.resume()

//        let task = self.session.dataTask(with: request)
//        self.listTaskSuccess[task] = success
//        self.listTaskFailure[task] = failure
//        task.resume()

    }
    
    //MARK: - 🔌 URLSessionDelegate Method
    
    open func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    }
    
//    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        
//        guard let httpResponse = dataTask.response as? HTTPURLResponse else {
//            // Error
//            return
//        }
//        
//        if(httpResponse.statusCode == 200){ // ok
//            //        let data = reply as? Data
//                    let str = String(data: data, encoding: .utf8)
//                    print(str)
//
//            if let cb = self.listTaskSuccess[dataTask]{
//                cb(data)
//                self.listTaskSuccess.removeValue(forKey: dataTask)
//                self.listTaskFailure.removeValue(forKey: dataTask)
//            }
//            
//        }else{
//            if let cb = self.listTaskFailure[dataTask]{
//                if(dataTask.error != nil){
//                    cb(dataTask.error?.localizedDescription, dataTask.error as? HttpError)
//                }else{
//                    cb(self.statusCodesMessage[httpResponse.statusCode],HttpError.unknow_error)
//                }
//                self.listTaskSuccess.removeValue(forKey: dataTask)
//                self.listTaskFailure.removeValue(forKey: dataTask)
//            }
//        }
//        
//    }
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        task.cancel()
        if(error != nil){
            if let cb = self.listTaskFailure[task]{
                if(error != nil){
                    cb(error?.localizedDescription, error as? HttpError)
                }else{
                    cb("An error occurred to please try again.",HttpError.unknow_error)
                }
                self.listTaskSuccess.removeValue(forKey: task)
                self.listTaskFailure.removeValue(forKey: task)
            }
        }
    }
    
}
