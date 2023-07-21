//
//  MockFavoriteViewController.swift
//  GameHouseTests
//
//  Created by Mert AKBAŞ on 21.07.2023.
//

import Foundation
import Foundation
@testable import GameHouse

final class MockFavoriteViewController: FavoriteViewModelDelegate {
    
    var isInvokedSetupTableView = false
    var invokedSetupTableViewCount = 0
    
    func setupTableView() {
         isInvokedSetupTableView = true
         invokedSetupTableViewCount += 1
    }
    
    var isInvokedShowLoading = false
    var invokedShowLoadingCount = 0
    
    func showLoadingView() {
        isInvokedShowLoading = true
        invokedShowLoadingCount += 1
    }
    
    var isInvokedHideLoading = false
    var invokedHideLoadingCount = 0
    
    func hideLoadingView() {
        isInvokedHideLoading = true
        invokedHideLoadingCount += 1
    }
    
    var isInvokedReloadData = false
    var invokedReloadDataCount = 0
    
    func reloadData() {
        isInvokedReloadData = true
        invokedReloadDataCount += 1
    }
}
