//
//  ViewController.swift
//  PopinDemo
//
//  Created by Ashwin Nath on 18/01/23.
//

import UIKit
import PopinCall

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func popinClick(_ sender: Any) {
        statusLabel.text = "Connecting... Please wait";
        Popin.shared.connect(token: 11506, popinDelegate: self);
    }
    
}
extension ViewController : PopinCallDelegate {
    func onConnectionEstablished() {
        self.navigationController?.pushViewController(PopinCallViewController(), animated: true)
    }
    
    func onAllExpertsBusy() {
        statusLabel.text = "All Experts are busy. Try again Later.";
    }
    
    func onCallConnected() {
        print("CALL_CONNEC");
       
        
    }
    
    func onCallDisconnected() {
        print("CALL_DISCONN");
    }
    
    func onCallFail() {
        print("CALL_FAIL");
    }
}


