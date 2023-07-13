//
//  FindAcronymViewControllerTests.swift
//  FindAcronymMeaningTests
//
//  Created by TCS on 13/07/2023.
//

import XCTest
@testable import FindAcronymMeaning

final class FindAcronymViewControllerTests: XCTestCase {

    var findAcronymViewModel : FindAcronymViewModelProtcol = FindAcronymViewModel()
    var findAcoronymViewController : FindAcronymViewController = FindAcronymViewController.instantiate()!
    
    
    override func setUp() {
        super.setUp()
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        findAcoronymViewController.findAcronymViewModel = self.findAcronymViewModel
        findAcoronymViewController.loadViewIfNeeded()
    }

    func testNumberOfRows() {
            let expectation = XCTestExpectation(description: "Wait for rows assigned to tableview ")
            self.findAcoronymViewController.findAcronymViewModel.getListOfAcronymMeaning(searchString: "Laptop") { result in
                DispatchQueue.main.async {
                    guard let tV = self.findAcoronymViewController.tableView, let tvDatasource = tV.dataSource else { XCTFail("FindAcronymViewController is nil"); return }
                    XCTAssertEqual(tvDatasource.tableView(tV, numberOfRowsInSection: 0), 3)
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: 5)
        }
        
        
        func testCellForTableView() {
            let expectation = XCTestExpectation(description: "Wait for cell created in tableview")
            self.findAcoronymViewController.findAcronymViewModel.getListOfAcronymMeaning(searchString: "Laptop") { result in
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 0, section: 0)
                    guard let tV = self.findAcoronymViewController.tableView,
                          let cell = self.findAcoronymViewController.tableView(tV, cellForRowAt: indexPath) as? ProductTableViewCell else {
                        XCTFail("Expected \(ProductTableViewCell.self)")
                        return
                    }
                    XCTAssertNotNil(cell)
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: 5)
        }

        
        func testCellDataForTableView() {
            let expectation = XCTestExpectation(description: "Wait for cell data created in tableview")
            self.findAcoronymViewController.findAcronymViewModel.getListOfAcronymMeaning(searchString: "Laptop") { result in
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 0, section: 0)
                    guard let tV = self.findAcoronymViewController.tableView,
                          let cell = self.findAcoronymViewController.tableView(tV, cellForRowAt: indexPath) as? ProductTableViewCell else {
                        XCTFail("Expected \(ProductTableViewCell.self)")
                        return
                    }
                    XCTAssertEqual(cell.title.text, "Samsung Galaxy Book")
                    XCTAssertEqual(cell.price.text, "1499")
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: 5)
        }
}
