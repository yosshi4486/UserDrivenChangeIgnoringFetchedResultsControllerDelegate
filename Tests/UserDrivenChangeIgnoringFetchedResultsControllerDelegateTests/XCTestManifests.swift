import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UserDrivenChangeIgnoringFetchedResultsControllerDelegateTests.allTests),
    ]
}
#endif
