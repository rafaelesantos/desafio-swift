//
//  NetworkAdapterTests.swift
//  NetworkAdapterTests
//
//  Created by Rafael Escaleira on 13/06/22.
//

import XCTest

class NetworkAdapter {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(to url: URL) {
        session.dataTask(with: url).resume()
    }
}

class NetworkAdapterTests: XCTestCase {
    func testGetShouldMakeRequestWithValidUrlAndMethod() {
        let url = makeUrl()
        let sut = makeSut()
        sut.get(to: url)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension NetworkAdapterTests {
    func makeSut() -> NetworkAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = URLSession(configuration: configuration)
        return NetworkAdapter(session: session)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?

    static func observeRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }

    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }

    override open func stopLoading() {}
}
