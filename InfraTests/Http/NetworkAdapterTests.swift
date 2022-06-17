//
//  NetworkAdapterTests.swift
//  InfraTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest
import Data
import Infra

class NetworkAdapterTests: XCTestCase {
    func testGetShouldMakeRequestWithValidUrlAndMethod() {
        let url = makeUrl()
        testGetRequestFor(url: url) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
        }
    }
    
    func testPostShouldMakeRequestWithValidUrlAndMethod() {
        let url = makeUrl()
        testPostRequestFor(url: url) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
        }
    }
    
    func testGetShouldCompleteWithErrorWhenRequestCompletesWithError() {
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: makeError()))
    }
    
    func testGetShouldCompleteWithErrorOnAllInvalidCases() {
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: makeValidData(), response: nil, error: nil))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: makeHttpResponse(), error: makeError()))
        expectResult(.failure(.noConnectivity), when: (data: nil, response: nil, error: nil))
    }
    
    func testGetShouldCompleteWithDataWhenRequestCompletesWith200() {
        expectResult(.success(makeValidData()), when: (data: makeValidData(), response: makeHttpResponse(), error: nil))
    }
    
    func testGetShouldCompleteWithNoDataWhenRequestCompletesWith204() {
        expectResult(.success(nil), when: (data: nil, response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeEmptyData(), response: makeHttpResponse(statusCode: 204), error: nil))
        expectResult(.success(nil), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 204), error: nil))
    }
    
    func testGetShouldCompleteWithErrorWhenRequestCompletesWithNon200() {
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 400), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 450), error: nil))
        expectResult(.failure(.badRequest), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 499), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 500), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 550), error: nil))
        expectResult(.failure(.serverError), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 599), error: nil))
        expectResult(.failure(.unauthorized), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 401), error: nil))
        expectResult(.failure(.forbidden), when: (data: makeValidData(), response: makeHttpResponse(statusCode: 403), error: nil))
    }
}

extension NetworkAdapterTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> NetworkAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = NetworkAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testGetRequestFor(url: URL = makeUrl(), action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.get(to: url) { _ in exp.fulfill() }
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func testPostRequestFor(url: URL = makeUrl(), action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.post(to: url, with: Data()) { _ in exp.fulfill() }
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expectResult(_ expectedResult: Result<Data?, HttpError>, when stub: (data: Data?, response: HTTPURLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) {
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.get(to: makeUrl()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)): XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
