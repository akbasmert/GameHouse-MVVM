//
//  FavoriViewModelTests.swift
//  GameHouseTests
//
//  Created by Mert AKBAŞ on 21.07.2023.
//

import XCTest
@testable import GameHouse
@testable import GameHouseAPI

final class FavoriViewModelTests: XCTestCase {

    var viewModel: FavoriteViewModel!
    var view: MockFavoriteViewController!
      
    override func setUp() {
        super.setUp()
        view = MockFavoriteViewController()
        viewModel = FavoriteViewModel(service: VideoGameService())
        viewModel.delegate = view
    }

    override func tearDown() {
        view = nil
        viewModel = nil
        super.tearDown()
    }
        
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.isInvokedSetupTableView)
        
        viewModel.viewDidLoad()
        
        XCTAssertTrue(view.isInvokedSetupTableView)
        
    }
    
    func test_fetchFilteredGames() {
        XCTAssertFalse(view.isInvokedHideLoading)
        XCTAssertFalse(view.isInvokedReloadData)
        
        viewModel.saveFilteredGameVideos()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.view.isInvokedHideLoading)
            XCTAssertTrue(self.view.isInvokedReloadData)
        }
    }
}
