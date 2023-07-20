//
//  HomeViewModelTests.swift
//  GameHouseTests
//
//  Created by Mert AKBAŞ on 18.07.2023.
//

import XCTest
@testable import GameHouse
@testable import GameHouseAPI

final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var view: MockHomeViewController!
      
    override func setUp() {
        super.setUp()
        view = MockHomeViewController()
        viewModel = HomeViewModel(service: VideoGameService())
        viewModel.delegate = view
    }

      
      override func tearDown() {
          view = nil
          viewModel = nil
          super.tearDown()
      }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.isInvokedSetupCollectionView)
        XCTAssertFalse(view.isInvokedSetupSearchBar)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(view.isInvokedSetupCollectionView)
        XCTAssertTrue(view.isInvokedSetupSearchBar)
    }

    func test_fetchAudiosOutput() {
        XCTAssertFalse(view.isInvokedHideLoading)
        XCTAssertEqual(viewModel.numberOfItems, 0)
        XCTAssertFalse(view.isInvokedReloadData)

        viewModel.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.view.isInvokedHideLoading)
            XCTAssertEqual(self.viewModel.numberOfItems, 20)
            XCTAssertTrue(self.view.isInvokedReloadData)
        }
       
    }
}

extension Game {
    static var response: Game {
        let bundle = Bundle(for: HomeViewModelTests.self)
        let path = bundle.path(forResource: "Games", ofType: "json")!
        let file = try! String(contentsOfFile: path)
        let data = file.data(using: .utf8)!
        let decoder = Decoders.dateDecoder
        let response = try! decoder.decode(Game.self, from: data)
        return response
    }
}
 
