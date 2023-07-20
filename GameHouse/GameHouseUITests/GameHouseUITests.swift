//
//  GameHouseUITests.swift
//  GameHouseUITests
//
//  Created by Mert AKBAŞ on 13.07.2023.
//

import XCTest

final class GameHouseUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("******** UITest ********")
    }
    
    func test_navigate_home_to_detail_view_controller() {
        app.launch()
        sleep(1)
        
        XCTAssertTrue(app.isSearchBarDisplayed)
        XCTAssertTrue(app.isCollectionViewDisplayed)
        
        app.searchBar.tap()
        app.searchBar.typeText("Tom")
        app.keyboards.buttons["Ara"].tap()
       
        let firstCell = app.collectionView.cells.element(boundBy: 0)
        firstCell.tap()
   
        sleep(1)
        
        XCTAssertTrue(app.isDetailTitleDisplayed)
        XCTAssertTrue(app.isDetailMetacriticDisplayed)
        XCTAssertTrue(app.isDetailDescriptionDisplayed)
        XCTAssertTrue(app.isDetailImageViewDisplayed)
        XCTAssertTrue(app.isDetailReleaseDateDisplayed)
    }
}


extension XCUIApplication {
    
    var searchBar: XCUIElement! {
        otherElements["searchBar"]
    }
 
    var collectionView: XCUIElement! {
        collectionViews["collectionView"]
    }
    
    var detailImageView: XCUIElement! {
        images.matching(identifier: "detailImageView").element
    }
    
    var detailTitle: XCUIElement! {
        staticTexts.matching(identifier: "detailTitle").element
    }
    
    var detailReleaseDate: XCUIElement! {
        staticTexts.matching(identifier: "detailReleaseDate").element
    }
    
    var detailMetacritic: XCUIElement! {
        staticTexts.matching(identifier: "detailMetacritic").element
    }
    
    var detailDescription: XCUIElement! {
        staticTexts.matching(identifier: "detailDescription").element
    }
    
    var isSearchBarDisplayed: Bool {
        searchBar.exists
    }
    
    var isCollectionViewDisplayed: Bool {
        collectionView.exists
    }
    
    var isDetailImageViewDisplayed: Bool {
        detailImageView.exists
    }
    
    var isDetailTitleDisplayed: Bool {
        detailTitle.exists
    }
    
    var isDetailReleaseDateDisplayed: Bool {
        detailReleaseDate.exists
    }
    
    var isDetailMetacriticDisplayed: Bool {
        detailMetacritic.exists
    }
    
    var isDetailDescriptionDisplayed: Bool {
        detailDescription.exists
    }
}

