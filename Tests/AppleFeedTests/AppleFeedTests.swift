import XCTest
@testable import AppleFeed

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

    static var allTests = [
        ("testFetchFeed", testFetchFeed),
    ]
}
