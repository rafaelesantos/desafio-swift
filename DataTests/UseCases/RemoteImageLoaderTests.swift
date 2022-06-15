//
//  RemoteImageLoaderTests.swift
//  DataTests
//
//  Created by Rafael Escaleira on 14/06/22.
//

import XCTest
import Data
import Domain

class RemoteImageLoaderTests: XCTestCase {
    func testImageLoaderShouldCallHttpClientWithCorrectUrl() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSut()
        _ = sut.loadImage(with: url) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func testImageLoaderShouldCompleteWithErrorIfClientCompletesWithError() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func testImageLoaderShouldCompleteWithEventsIfClientCompletesWithValidData() {
        let (sut, httpClientSpy) = makeSut()
        let expectedImage = makeImageModel()
        expect(sut, completeWith: .success(expectedImage), when: {
            httpClientSpy.completeWithData(expectedImage)
        })
    }
    
    func testImageLoaderShouldCompleteWithEventsIfClientCompletesWithInvalidData() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(Data())
        })
    }
    
    func testImageLoaderShouldNotCompleteIfSutHasBeenDeallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteImageLoader? = RemoteImageLoader(httpClient: httpClientSpy)
        var result: ImageLoader.Result?
        _ = sut?.loadImage(with: makeUrl()) { result = $0 }
        sut = nil
        httpClientSpy.completeWithError(.noConnectivity)
        XCTAssertNil(result)
    }
}

extension RemoteImageLoaderTests {
    func makeSut(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteImageLoader, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteImageLoader(httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
        return (sut, httpClientSpy)
    }
    
    func expect(_ sut: RemoteImageLoader, completeWith expectedResult: ImageLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        _ = sut.loadImage(with: makeUrl()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedEvents), .success(let receivedEvents)): XCTAssertEqual(expectedEvents, receivedEvents, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
}
