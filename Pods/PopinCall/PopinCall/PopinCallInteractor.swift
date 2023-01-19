//
//  PopinCallInteractor.swift
//  PopinCall
//
//  Created by Ashwin Nath on 15/11/22.
//

import Foundation


import Alamofire
import SwiftyJSON


struct TalkModel : Codable{
    let id: Int?;
    let token: String?;
    let room: String?;
    let status: Int;
}

class PopinCallInteractor {
    
    func getAccessToken(seller_id: Int, onSucess sucess: @escaping (_ talkModel:  TalkModel) -> Void, onFailure failure: @escaping () -> Void) {
        let parameters: Parameters = ["seller_id":seller_id];
        let urlString = serverURL + "/user/call";
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Utilities.shared.getUserToken(),
            "Accept": "application/json"
        ]
        AF.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .responseDecodable(of: TalkModel.self) { response in
                switch response.result {
                case .success(let talkModel):
                    sucess(talkModel);
                    break;
                case .failure(let error):
                    print(error)
                    failure();
                }
            }
    }
    
    
    
    func endOngoingCall(call_id: Int, onSucess sucess: @escaping () -> Void, onFailure failure: @escaping () -> Void) {
        let parameters: Parameters = ["call_id":call_id];
        let urlString = serverURL + "/user/call/end";
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Utilities.shared.getUserToken(),
            "Accept": "application/json"
        ]
        AF.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .responseDecodable(of: StatusModel.self) { response in
                switch response.result {
                case .success(_):
                    sucess();
                    break;
                case .failure(_):
                    failure();
                    debugPrint("fail")
                }
            }
    }
    
}
