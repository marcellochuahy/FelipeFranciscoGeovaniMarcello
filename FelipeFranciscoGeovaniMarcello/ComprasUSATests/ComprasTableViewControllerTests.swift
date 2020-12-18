//
//  ComprasTableViewControllerTests.swift
//  ComprasUSATests
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import XCTest
@testable import ComprasUSA

class ComprasTableViewControllerTests: XCTestCase {
	
	// MARK: - System Under Test
	var sut: ComprasTableViewController!

	// MARK: - Life cycle

    override func setUpWithError() throws {
		super.setUp()
		sut = ComprasTableViewController()
    }

    override func tearDownWithError() throws {
		sut = nil
		super.tearDown()
    }
	
	// MARK: - Tests
	
	func testTitle() {
		sut.viewDidLoad()
		XCTAssertEqual(sut.title, "Lista de Compras")
	}
	
	func testNumberOfSections_whenPurchasedProductsIsEmpty() {
		let numberOfSections = sut.numberOfSections(in: sut.tableView!)
		XCTAssertEqual(numberOfSections, 0)
	}
	
	func testBackgroundView_whenPurchasedProductsIsEmpty() {
		let _ = sut.numberOfSections(in: sut.tableView!)
		XCTAssertEqual(sut.tableView.backgroundView, sut.label)
	}

	func testNumberOfSectionsIsOne_whenPurchasedProductsIsNotEmpty() {
		appendNewPurchasedProduct()
		let numberOfSections = sut.numberOfSections(in: sut.tableView!)
		XCTAssertEqual(numberOfSections, 1)
	}
	
	func testBackgroundViewIsNil_whenPurchasedProductsIsNotEmpty() {
		appendNewPurchasedProduct()
		let _ = sut.numberOfSections(in: sut.tableView!)
		XCTAssertNil(sut.tableView.backgroundView)
	}
	
	func testNumberOfRowsInSectionZeroIsOne_whenPurchasedProductsIsOne() {
		appendNewPurchasedProduct()
		let numberOfRowsInSectionZero = sut.tableView(sut.tableView!, numberOfRowsInSection: 0)
		XCTAssertEqual(numberOfRowsInSectionZero, 1)
	}
	
	func testNumberOfRowsInSectionZeroIsTwo_whenPurchasedProductsIsTwo() {
		appendNewPurchasedProduct()
		appendNewPurchasedProduct()
		let numberOfRowsInSectionZero = sut.tableView(sut.tableView!, numberOfRowsInSection: 0)
		XCTAssertEqual(numberOfRowsInSectionZero, 2)
	}

}
// MARK: - Handler methods

extension ComprasTableViewControllerTests {
	
	func appendNewPurchasedProduct() {
		let purchasedProduct = PurchasedProduct(productName: "iPhone 12", imageName: "iPhone_12", priceInDollars: 999.99)
		sut.purchasedProducts.append(purchasedProduct)
	}
	
}



/*


// MARK: - Tests
// Test name: test SUT _ whenSomethingThatNeedToHappenToStartTheTest _ SUTStateAfterWhenPhaseHappens
func <#testName#>() {
	
	/// given ( set up any aditional values if needed )
	let <#parameterName#> = <#parameterValue#>
	
	/// when ( execute the code being tested )
	let actualResult = sut.<#methodToBeTested#>(<#parameterName#>)
	
	/// then ( assert the expected result with a message that prints if the test fails )
	let expectedResult = "<#expectedResult: String#>"
	XCTAssertEqual(actualResult,
				   expectedResult,
				   "Result should be \"\(expectedResult)\" but actually is \"\(actualResult)\"")
}

}

/*

Organization
============

Test Target
⌊ Cases
⌊ Group 1
⌊ Test Class 1.1
⌊ Test Class 1.2
⌊ Group 2
⌊ Test Class 2.1
⌊ Test Class 2.2
⌊ Mocks
⌊ Helper Classes
⌊ Helper Extensions

Assert functions in XCTest:
===========================

Equality
--------
XCTAssertEqual
XCTAssertNotEqual

Truthiness
----------
XCTAssertTrue
XCTAssertFalse

Nullability
-----------
XCTAssertNil
XCTAssertNotNil

Comparison
----------
XCTAssertLessThan
XCTAssertGreaterThan
XCTAssertLessThanOrEqual
XCTAssertGreaterThanOrEqual

Erroring
--------
XCTAssertThrowsError
XCTAssertNoThrow

*/


*/
