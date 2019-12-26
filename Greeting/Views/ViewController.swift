//
//  ViewController.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/26/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Welcome to ViewController")
        getPersonData()
    }


    func getPersonData() {
        let op = GetPersonDataOperation()
        op.addSuccessEvent(event: Event(with: { (reply) in
            if let persons = reply as? [Person] {
                for person in persons {
                    print(person.name)
                }
                
                ViewComponent.shareInstance.showGreetingView(person: persons.first!)
            }
            
        }))
        
        op.addErrorEvent(event: Event(with: { (error) in
            if let err = error as? String {
                print(err)
            }
        }))
        
        op.fire()
    }
}

