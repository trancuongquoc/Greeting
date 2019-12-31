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
        btn.titleLabel?.text = "Send Probe"
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .purple
        btn.titleLabel?.textAlignment = .left
        btn.addTarget(self, action: #selector(handleBtn), for: .touchUpInside)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @objc func handleBtn() {
        let op = SendProbeOperation()
        op.fire()
    }
}

