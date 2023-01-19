//
//  PopinInteractor.swift
//  PopinCall
//
//  Created by Ashwin Nath on 17/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class PopinInteractor {
    
    func registerUser(seller_id: Int, onSucess sucess: @escaping () -> Void, onFailure failure: @escaping () -> Void) {
        let parameters: Parameters = ["seller_id":seller_id,"is_mobile" : 1, "device": "iosSdk"];
        let urlString = serverURL + "/website/user/login";
        AF.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
            .responseDecodable(of: UserModel.self) { response in
                switch response.result {
                case .success(let userModel):
                    if (userModel.status == "1") {
                        Utilities.shared.saveUserToken(token: userModel.token)
                        Utilities.shared.saveChannel(channel: userModel.channel)
                        sucess()
                        return;
                    }
                    
                    failure();
                case .failure(let error):
                    print(error)
                    failure();
                }
            }
    }
    
    func startConnection(seller_id: Int) {
        let parameters: Parameters = ["seller_id":seller_id];
        let urlString = serverURL + "/user/connect";
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Utilities.shared.getUserToken(),
            "Accept": "application/json"
        ]
        AF.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .responseDecodable(of: StatusModel.self) { response in
                switch response.result {
                case .success(let statusModel):
                    debugPrint(statusModel)
                    
                case .failure(_):
                    debugPrint("fail")
                }
            }
    }
}

struct UserModel : Codable{
    let status: String;
    let token: String;
    let channel: String;
}
struct StatusModel : Codable{
    let status: Int;
}
