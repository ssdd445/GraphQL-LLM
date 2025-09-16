//
//  CharacterDetailViewModelTests.swift
//  GraphQL-LLMTests
//
//  Created by Saud Waqar on 16/09/2025.
//

import List
import XCTest
@testable import GraphQL_LLM


@MainActor
class CharacterDetailViewModelTests: XCTestCase {
    var viewModel: CharacterDetailViewModel!
    var mockNetworkService: MockNetworkService!
    var mockAIService: MockAIService!
    let testCharacterID = "test-character-id"
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockAIService = MockAIService()
        viewModel = CharacterDetailViewModel(
            characterID: testCharacterID,
            networkService: mockNetworkService,
            aiService: mockAIService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockAIService = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNil(viewModel.character)
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadCharacterDetailSuccess() async {
        let mockCharacterData: [String: AnyHashable] = [
            "__typename": "Character",
            "id": testCharacterID,
            "name": "Rick Sanchez"
        ]
        let dataDict = DataDict(
            data: mockCharacterData,
            fulfilledFragments: Set([ObjectIdentifier(GetCharacterDetailQuery.Data.Character.self)])
        )
        
        let mockCharacter = GetCharacterDetailQuery.Data.Character(_dataDict: dataDict)
        mockNetworkService.mockCharacterDetail = mockCharacter
        
        await viewModel.loadCharacterDetail()
        
        XCTAssertNotNil(viewModel.character)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockNetworkService.fetchCharacterDetailCallCount, 1)
        XCTAssertEqual(mockNetworkService.lastCharacterID, testCharacterID)
        
        XCTAssertEqual(viewModel.character?.id, testCharacterID)
        XCTAssertEqual(viewModel.character?.name, "Rick Sanchez")
    }
    
    func testLoadCharacterDetailError() async {
        mockNetworkService.shouldThrowError = true
        
        await viewModel.loadCharacterDetail()
        
        XCTAssertNil(viewModel.character)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch data")
        XCTAssertEqual(mockNetworkService.fetchCharacterDetailCallCount, 1)
    }
    
    func testLoadCharacterDetailClearsError() async {
        viewModel.errorMessage = "Previous error"
        let mockCharacter = GetCharacterDetailQuery.Data.Character.mock()
        mockNetworkService.mockCharacterDetail = mockCharacter
        
        await viewModel.loadCharacterDetail()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.character)
    }
    
    func testMultipleLoadCalls() async {
        let mockCharacter = GetCharacterDetailQuery.Data.Character.mock()
        mockNetworkService.mockCharacterDetail = mockCharacter
        
        await viewModel.loadCharacterDetail()
        await viewModel.loadCharacterDetail()
        
        XCTAssertEqual(mockNetworkService.fetchCharacterDetailCallCount, 2)
        XCTAssertFalse(viewModel.isLoading)
    }
}

private extension GetCharacterDetailQuery.Data.Character {
    static func mock(
        id: String = "1",
        name: String = "Rick Sanchez"
    ) -> GetCharacterDetailQuery.Data.Character {
        let data: [String: AnyHashable] = [
            "__typename": "Character",
            "id": id,
            "name": name
        ]
        
        let dataDict = DataDict(
            data: data,
            fulfilledFragments: Set([ObjectIdentifier(GetCharacterDetailQuery.Data.Character.self)])
        )
        
        return GetCharacterDetailQuery.Data.Character(_dataDict: dataDict)
    }
    
    func promptDescription() -> String {
        return "Character: \(self.name ?? "Unknown")"
    }
}
