//
//  HomeViewModelTests.swift
//  GameHouseTests
//
//  Created by Mert AKBAŞ on 18.07.2023.
//

import XCTest
@testable import GameHouseAPI

final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var viewController: MockHomeViewController!
      
      override func setUp() {
          super.setUp()
          viewController = .init()
          viewModel = HomeViewModel(service: VideoGameService())
      }
      
      override func tearDown() {
          viewController = nil
          viewModel = nil
          super.tearDown()
      }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(viewController.isInvokedSetupCollectionView)
        XCTAssertFalse(viewController.isInvokedSetupSearchBar)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(viewController.isInvokedSetupCollectionView)
        XCTAssertTrue(viewController.isInvokedSetupSearchBar)
    }

}
