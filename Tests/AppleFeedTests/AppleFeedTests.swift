import XCTest
@testable import AppleFeed

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class AppleFeedTests: XCTestCase {
    
    func testFetchFeed() {
        let expectationFetchFeed = expectation(description: "Fetch Feed")
        
        var feedResult: FeedResult? = nil
        
        _ = AppleFeed.shared.fetchFeed(
                country: .unitedStates,
                mediaType: .appleMusic,
                feedType: .topAlbums
            )
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                    expectationFetchFeed.fulfill()
                },
                receiveValue: { feedResult = $0 }
            )
        
        waitForExpectations(timeout: 5)
        
        XCTAssertNotNil(feedResult)
        guard let feedResultUnwrapped = feedResult else {
            return
        }
        
        XCTAssertEqual(feedResultUnwrapped.feed.results.count, 100)
    }
    
    func testFetchImage() {
        var feedResult: FeedResult? = nil
        
        do {
            let expectationFetchFeed = expectation(description: "Fetch Feed")
            
            _ = AppleFeed.shared.fetchFeed(
                    country: .unitedStates,
                    mediaType: .appleMusic,
                    feedType: .topAlbums
                )
                .sink(
                    receiveCompletion: {
                        switch $0 {
                        case .finished:
                            break
                        case .failure(let error):
                            XCTFail(error.localizedDescription)
                        }
                        expectationFetchFeed.fulfill()
                    },
                    receiveValue: { feedResult = $0 }
                )
            
            waitForExpectations(timeout: 5)
        }
        
        XCTAssertNotNil(feedResult)
        guard let feedResultUnwrapped = feedResult else {
            return
        }
        
        XCTAssertEqual(feedResultUnwrapped.feed.results.count, 100)
        
        let album = feedResultUnwrapped.feed.results[0]
        guard let url = URL(string: album.artworkUrl100) else {
            XCTFail("\(album.artworkUrl100) is not a valid URL")
            return
        }
        
        let expectationFetchImage = expectation(description: "Fetch Image")
        
        var image: Image? = nil
        
        _ = AppleFeed.shared.fetchImage(url: url)
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case .finished:
                        break
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    }
                    expectationFetchImage.fulfill()
                },
                receiveValue: { image = $0 }
            )
        
        waitForExpectations(timeout: 5)
        
        XCTAssertNotNil(image)
    }

    static var allTests = [
        ("testFetchFeed", testFetchFeed),
    ]
}
