//
//  CharacterListViewModelTests.swift
//  GraphQL-LLM
//
//  Created by Saud Waqar on 16/09/2025.
//

import List
import XCTest
@testable import GraphQL_LLM

@MainActor
class CharacterListViewModelTests: XCTestCase {
    var viewModel: CharacterListViewModel!
    var mockNetworkService: MockNetworkService!
    var mockAIService: MockAIService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockAIService = MockAIService()
        viewModel = CharacterListViewModel(
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
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadCharactersSuccess() async {
        let mockCharacters = [
            CharactersListQuery.Data.Characters.Result.mock(
                id: "1",
                name: "Rick Sanchez",
                image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            ),
            CharactersListQuery.Data.Characters.Result.mock(
                id: "2",
                name: "Morty Smith",
                image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"
            )
        ]
        mockNetworkService.mockCharactersList = mockCharacters
        
        await viewModel.loadCharacters()
        
        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertEqual(viewModel.characters[0].id, "1")
        XCTAssertEqual(viewModel.characters[0].name, "Rick Sanchez")
        XCTAssertEqual(viewModel.characters[1].id, "2")
        XCTAssertEqual(viewModel.characters[1].name, "Morty Smith")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockNetworkService.fetchCharactersListCallCount, 1)
    }
    
    func testLoadCharactersError() async {
        mockNetworkService.shouldThrowError = true
        
        await viewModel.loadCharacters()
        
        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch data")
        XCTAssertEqual(mockNetworkService.fetchCharactersListCallCount, 1)
    }
    
    func testLoadCharactersLoading() async {
        viewModel.isLoading = false
        
        await viewModel.loadCharacters()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadCharactersClearsError() async {
        viewModel.errorMessage = "Previous error"
        mockNetworkService.mockCharactersList = []
        
        await viewModel.loadCharacters()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.characters.isEmpty)
    }
    
    func testLoadCharactersClearsPreviousData() async {
        let initialCharacters = [
            CharactersListQuery.Data.Characters.Result.mock(id: "old1", name: "Old Character")
        ]
        viewModel.characters = initialCharacters
        
        let newMockCharacters = [
            CharactersListQuery.Data.Characters.Result.mock(id: "new1", name: "New Character 1"),
            CharactersListQuery.Data.Characters.Result.mock(id: "new2", name: "New Character 2")
        ]
        mockNetworkService.mockCharactersList = newMockCharacters
        
        await viewModel.loadCharacters()
        
        XCTAssertEqual(viewModel.characters.count, 2)
        XCTAssertEqual(viewModel.characters[0].id, "new1")
        XCTAssertEqual(viewModel.characters[1].id, "new2")
    }
}

// MARK: - Test Utilities

extension XCTestCase {
    @MainActor
    func waitForAsyncOperation() async {
        try? await Task.sleep(nanoseconds: 100_000_000)
    }
}

private extension CharactersListQuery.Data.Characters.Result {
    static func mock(
        id: String = "1",
        name: String = "Rick Sanchez",
        image: String = "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
    ) -> CharactersListQuery.Data.Characters.Result {
        let data: [String: AnyHashable] = [
            "__typename": "Character",
            "id": id,
            "name": name,
            "image": image
        ]
        
        let dataDict = DataDict(
            data: data,
            fulfilledFragments: Set([ObjectIdentifier(CharactersListQuery.Data.Characters.Result.self)])
        )
        return CharactersListQuery.Data.Characters.Result(_dataDict: dataDict)
    }
}
