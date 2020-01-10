//
//  ViewController.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/26/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SendProbe", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(handleBtn), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var btn1: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Send Request", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(handleBtn1), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        btn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        btn.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        btn1.topAnchor.constraint(equalTo: self.btn.bottomAnchor, constant: 32).isActive = true
        btn1.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        btn1.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn1.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @objc func handleBtn() {
        Engine.shared.getDiscoveryComponent()?.scanOnvifDevices()
    }
    
    @objc func handleBtn1() {
//        if let device = Engine.shared.getDeviceComponent()?.devices.first {
//            Engine.shared.getDeviceComponent()?.getSystemDateAndTime(device: device)
//        }
        Engine.shared.getEventComponent()?.listenTo(with: EventName.http.did_update_device_profiles, event: Event(with: { (aaa) in
            print(Engine.shared.getDeviceComponent()?.devices.first!.profiles)
        }))
        if let device = Engine.shared.getDeviceComponent()?.devices.first {
            device.set(username: "admin", password: "vivasvnpt124")
            Engine.shared.getDeviceComponent()?.getProfiles(for: device)
        }
    }

}

