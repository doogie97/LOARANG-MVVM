//
//  NetworkManager.swift
//  LOARANG-MVVM
//
//  Created by 최최성균 on 2022/12/11.
//

import Foundation
import Alamofire

protocol NetworkManagerable {
    func request<T: Decodable>(_ requestable: Requestable, resultType: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

struct NetworkManager: NetworkManagerable {
    func request<T: Decodable>(_ requestable: Requestable, resultType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        requestable.request.responseDecodable(of: T.self) { result in
            DispatchQueue.main.async {
                guard result.error == nil else {
                    completion(.failure(APIError.transportError))
                    return
                }

                guard let response = result.response else {
                    completion(.failure(APIError.responseError))
                    return
                }

                guard (200...299).contains(response.statusCode) else {
                    print(response.statusCode)
                    completion(.failure(APIError.statusCodeError))
                    return
                }

                guard let value = result.value else {
                    completion(.failure(APIError.dataError))
                    return
                }
                
                completion(.success(value))
            }
        }
    }
}
