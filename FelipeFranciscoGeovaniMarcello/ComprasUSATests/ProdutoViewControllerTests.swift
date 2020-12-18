//
//  ProdutoViewControllerTests.swift
//  ComprasUSATests
//
//  Created by Marcello Chuahy on 17/12/20.
//  Copyright © 2020 Applause Codes. All rights reserved.
//

import XCTest
@testable import ComprasUSA

class ProdutoViewControllerTests: XCTestCase {
	
	// MARK: - System Under Test
	var sut: ProdutoViewController!
	
	// MARK: - Life cycle
	
	override func setUpWithError() throws {
		super.setUp()
		sut = ProdutoViewController()
	}
	
	override func tearDownWithError() throws {
		sut = nil
		super.tearDown()
	}
	
	// MARK: - Tests
	
	func testTitle() {
		sut.viewDidLoad()
		XCTAssertEqual(sut.title, "Cadastrar Produto")
	}
	
	
	
}
// MARK: - Handler methods

extension ProdutoViewControllerTests {
	

	
}
