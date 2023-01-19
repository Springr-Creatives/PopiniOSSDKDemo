//
//  Popin.swift
//  PopinCall
//
//  Created by Ashwin Nath on 15/11/22.
//

import Foundation


let serverURL = "https://widget01.popin.to/api/v1";

open class Popin : PopinPusherDelegate {
    
    public static let shared = Popin()
    
    private var delegate : PopinCallDelegate?
    
    private init() {}
    
    private  let popinPresenter = PopinPresenter(popinInteractor: PopinInteractor())
    
    private  let popinPusher = PopinPusher()
    
    private var startCall : Bool = false;
    
    private var sellerToken : Int = 0;
        
    public  func connect(token: Int, popinDelegate: PopinCallDelegate) {
        self.delegate = popinDelegate;
        Utilities.shared.saveSeller(seller_id: token);
        if (!self.popinPresenter.isUserRegistered()) {
            print("REGISTER_USER");
            popinPresenter.registerUser(seller_id: token, onSucess: {
                self.connectPusher(seller_id: token)
            })
        } else {
            self.connectPusher(seller_id: token)
        }
    }
    
    public  func connectPusher(seller_id: Int) {
        startCall = true;
        sellerToken = seller_id;
        popinPusher.delegate = self;
        popinPusher.connect()
      //  startConnect(seller_id: seller_id)
        
       
    }
    
    public func getAvailableSchedules() {
        
    }
    
    public func setScheduledCall(scheduleTime: String) {
        
    }
    
    public func setRating(rating: Int) {
        
    }
    
    
    
    public func onPusherConnected() {
        print("PUSHER CONNECTED");
        if (startCall && sellerToken > 0) {
            if (Utilities.shared.isConnected()) {
                print("AGENT_ALEADY CONNECTED");
                self.delegate?.onConnectionEstablished()
                return;
            }
            print("ATTEMPT AGENT CONNECT");
            popinPresenter.startConnection(seller_id: sellerToken);
        }
    }
    
    public func onAgentConnected() {
        self.delegate?.onConnectionEstablished()
    }
    
    public func onAllExpertsBusy() {
        self.delegate?.onAllExpertsBusy()
    }
    
    public func onCallConnected() {
        
    }
    
    public func onCallDisconnected() {
        
    }
    
    public func onCallFail() {
        
    }
}

