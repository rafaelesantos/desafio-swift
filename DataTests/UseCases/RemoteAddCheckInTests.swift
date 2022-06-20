//
//  RemoteAddCheckInTests.swift
//  DataTests
//
//  Created by Rafael Escaleira on 17/06/22.
//

import XCTest
import Domain
import Data

class RemoteAddCheckInTests: XCTestCase {
    func testAddShouldCallHttpClientWithCorrectUrl() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addCheckInModel: makeAddCheckInModel()) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }

    func testAddShouldCallHttpClientWithCorrectData() {
        let (sut, httpClientSpy) = makeSut()
        sut.add(addCheckInModel: makeAddCheckInModel()) { _ in }
        XCTAssertEqual(httpClientSpy.data, makeAddCheckInModel().toData())
    }

    func testAddShouldCompleteWithErrorIfClientCompletesWithError() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }

    func testAddShouldCompleteWithAccountIfClientCompletesWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let model = makeValidChackInModel()
        expect(sut, completeWith: .success(makeValidChackInModel()), when: {
            httpClientSpy.completeWithData(model.toData()!)
        })
    }

    func testAddShouldNotCompleteIfSutHasBeenDeallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddCheckIn? = RemoteAddCheckIn(url: makeUrl(), httpClient: httpClientSpy)
        var result: AddCheckIn.Result?
        sut?.add(addCheckInModel: makeAddCheckInModel()) { result = $0 }
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteAddCheckInTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteAddCheckIn, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddCheckIn(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }

    func expect(_ sut: RemoteAddCheckIn, completeWith expectedResult: AddCheckIn.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        sut.add(addCheckInModel: makeAddCheckInModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
}
