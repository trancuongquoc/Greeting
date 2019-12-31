////
////  Discovery.swift
////  WSExamplee
////
////  Created by Quoc Cuong on 11/12/19.
////  Copyright © 2019 Quoc Cuong. All rights reserved.
////
//
//import UIKit
//import CommonCrypto
//
//public protocol DiscoveryDelegate: class {
//    func discoveryDidReceive(probeMatches: [ProbeMatch], devices: [Device])
//}
//
//public class DiscoveryComponent: Component {
//
//    public func componentType() -> ComponentType {
//        return .WSDiscovery
//    }
//
//    public func start() throws {
//        debugPrint("DiscoveryComponent Did Start")
//    }
//
//    public func stop() {
//
//    }
//
//
//    public weak var delegate: DiscoveryDelegate?
//    public var probeMatches = [ProbeMatch]()
//    public var devices = [Device]()
//
//    let kDefaultTimeOutMinimum = 5
//    private var multicastAddr = "239.255.255.250"
//    private var timeout: Int = 5
//
//    private var lastProbeMessageUUID: String = ""
//
//    private var isConnected = false
//
//    private var probe: Data?
//
//    public func set(multicastAddress: String) {
//        self.multicastAddr = multicastAddress
//    }
//
//    public func set(timeOut: Int) {
//        var time = timeOut
//
//        if timeOut < kDefaultTimeOutMinimum {
//            time = kDefaultTimeOutMinimum
//        }
//
//        self.timeout = time
//    }
//
//    func readResponse(_ data: Data) {
//        let probeMatch = ProbeMatch(data: data)
//        print(probeMatch.hardware)
//        if !self.probeMatches.contains(where: { (probe) -> Bool in
//            probe.messageID == probeMatch.messageID
//        }) {
//
//            if probeMatch.relatedTo == self.lastProbeMessageUUID {
//
//                self.probeMatches.append(probeMatch)
//
//                let device = Device()
//                device.hardware = probeMatch.hardware
//                device.xAddr = probeMatch.xAddr
//                print(device.hardware)
//                self.devices.append(device)
//            }
//
//        }
//    }
//
//    public func discover(type: String = "") {
////        self.probeMatches = []
////        self.devices = []
////
////        if !isConnected {
////            setupConection()
////        }
////
////        self.lastProbeMessageUUID = UUID.init().uuidString
////        if let probe = buildProbe(with: self.lastProbeMessageUUID, type: type) {
////            self.probe = probe
////            self.send(probe: probe)
////        } else {
////            print("Probe build error.")
////        }
//        let op = SendProbeOperation()
//
//        op.fire()
//    }
//
//    func setupConection() {
//        if inSocket != nil {
//            inSocket.close()
//            inSocket = nil
//        }
//
//        if outSocket != nil {
//            outSocket.close()
//            outSocket = nil
//        }
//
//        outSocket = OutSocket(ip_address: self.multicastAddr)
//        outSocket.setupConnection {
//            print("OutSocket setup on ", self.outSocket.socket.localPort())
//            self.inSocket = InSocket(port: self.outSocket.socket.localPort())
//        }
//
//        if inSocket != nil && outSocket != nil {
//            if inSocket.socket.localPort() != outSocket.socket.localPort() {
//                print("inSocket listening to another port, ",inSocket.socket.localPort())
//                self.isConnected = false
//                setupConection()
//            } else {
//                self.isConnected = true
//                print("inSocket and outSocket on same local port.")
//            }
//        }
//    }
//
//    func send(probe: Data) {
//        if inSocket != nil && outSocket != nil {
//            if inSocket.socket.localPort() ==  outSocket.socket.localPort() {
//                print("InSocket listening to port: ", inSocket.socket.localPort())
//                outSocket.send(probe)
//                print("Discovery is waiting for probe match..")
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(self.timeout*1000)) {
//                    if self.probeMatches.isEmpty {
//                        print("Discovery timeout. No probe match received")
//                    }
//                    self.delegate?.discoveryDidReceive(probeMatches: self.probeMatches, devices: self.devices)
//                }
//
//            } else {
//                print("InSocket listening to another port: ", inSocket.socket.localPort())
//            }
//        }
//    }
//
//    func buildProbe(with messageID: String, type: String = "") -> Data? {
//        if type != "" {
//            let probe = """
//            <?xml version="1.0" encoding="UTF-8"?>
//            <e:Envelope xmlns:e="http://www.w3.org/2003/05/soap-envelope"
//            xmlns:w="http://schemas.xmlsoap.org/ws/2004/08/addressing"
//            xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery"
//            xmlns:dn="http://www.onvif.org/ver10/network/wsdl">
//            <e:Header>
//            <w:MessageID>uuid:\(messageID)</w:MessageID>
//            <w:To e:mustUnderstand="true">urn:schemas-xmlsoap-org:ws:2005:04:discovery</w:To>
//            <w:Action
//            a:mustUnderstand="true">http://schemas.xmlsoap.org/ws/2005/04/discovery/Pr
//            obe</w:Action>
//            </e:Header>
//            <e:Body>
//            <d:Probe>
//            <d:Types>dn:\(type)</d:Types>
//            </d:Probe>
//            </e:Body>
//            </e:Envelope>
//            """
//
//            let data = probe.data(using: .utf8)
//            return data
//        }
//
//        let probe = """
//        <?xml version="1.0" encoding="UTF-8"?>
//        <e:Envelope xmlns:e="http://www.w3.org/2003/05/soap-envelope"
//        xmlns:w="http://schemas.xmlsoap.org/ws/2004/08/addressing"
//        xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery"
//        xmlns:dn="http://www.onvif.org/ver10/network/wsdl">
//        <e:Header>
//        <w:MessageID>uuid:\(messageID)</w:MessageID>
//        <w:To e:mustUnderstand="true">urn:schemas-xmlsoap-org:ws:2005:04:discovery</w:To>
//        <w:Action
//        a:mustUnderstand="true">http://schemas.xmlsoap.org/ws/2005/04/discovery/Pr
//        obe</w:Action>
//        </e:Header>
//        <e:Body>
//        <d:Probe>
//        </d:Probe>
//        </e:Body>
//        </e:Envelope>
//        """
//
//        let data = probe.data(using: .utf8)
//        return data
//    }
//
//    func close() {
//        self.outSocket.close()
//        self.inSocket.close()
//        self.isConnected = false
//    }
//}
//
//extension Data {
//
//    public var sha1: String {
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
//        self.withUnsafeBytes { bytes in
//            _ = CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
//        }
//        return Data(digest).base64EncodedString()
//
//    }
//
//}
//
//
//extension String {
//    //: ### Base64 encoding a string
//    func base64Encoded() -> String? {
//        if let data = self.data(using: .utf8) {
//            return data.base64EncodedString()
//        }
//        return nil
//    }
//
//    //: ### Base64 decoding a string
//    func base64Decoded() -> String? {
//        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
//            return String(data: data, encoding: .utf8)
//        }
//        return nil
//    }
//}
