//
//  PopinCallDelegate.swift
//  PopinCall
//
//  Created by Ashwin Nath on 15/11/22.
//

import Foundation

public protocol PopinCallDelegate {
    func onConnectionEstablished();
    func onAllExpertsBusy();
    func onCallConnected();
    func onCallDisconnected();
    func onCallFail();
}
