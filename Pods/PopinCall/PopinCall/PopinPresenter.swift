//
//  PopinPresenter.swift
//  PopinCall
//
//  Created by Ashwin Nath on 17/11/22.
//

import Foundation

class PopinPresenter {
    private let popinInteractor: PopinInteractor
    
    init(popinInteractor: PopinInteractor) {
        self.popinInteractor = popinInteractor
    }
    
    
    func isUserRegistered() -> Bool {
        return Utilities.shared.getUserToken().count > 0;
    }
    
    func registerUser(seller_id: Int, onSucess sucess: @escaping () -> Void) {
        
        popinInteractor.registerUser(seller_id: seller_id, onSucess: {
            sucess();
        }, onFailure: {
        
        });
    }
    
    func startConnection(seller_id: Int) {
        popinInteractor.startConnection(seller_id: seller_id)
    }
    
}
