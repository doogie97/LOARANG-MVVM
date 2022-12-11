//
//  LOARANG_MVVMTests.swift
//  LOARANG-MVVMTests
//
//  Created by 최최성균 on 2022/12/11.
//

import XCTest
@testable import LOARANG_MVVM

final class LOARANG_MVVMTests: XCTestCase {
    func test_Requset호출시_News정보를_잘_가져오는지() {
        //given
        let promise = expectation(description: "News를 잘 가져오는지")
        let networkManager = NetworkManager()
        let api = NewsAPIModel()
        
        //when
        networkManager.request(api, resultType: [News].self) { result in
            switch result {
                //then
            case .success(let news):
                //2022년 12월11일 기준 첫 번째 이벤트
                XCTAssertEqual(news[safe: 0]?.title, "2022 3rd 네리아의 드레스룸")
            case .failure(let error):
                print(error)
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
}
