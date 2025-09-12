// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetCharacterDetailQuery: GraphQLQuery {
  public static let operationName: String = "GetCharacterDetail"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetCharacterDetail($id: ID!) { character(id: $id) { __typename id name status species gender image created } }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: List.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { List.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("character", Character?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Get a specific character by ID
    public var character: Character? { __data["character"] }

    /// Character
    ///
    /// Parent Type: `Character`
    public struct Character: List.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { List.Objects.Character }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", List.ID?.self),
        .field("name", String?.self),
        .field("status", String?.self),
        .field("species", String?.self),
        .field("gender", String?.self),
        .field("image", String?.self),
        .field("created", String?.self),
      ] }

      /// The id of the character.
      public var id: List.ID? { __data["id"] }
      /// The name of the character.
      public var name: String? { __data["name"] }
      /// The status of the character ('Alive', 'Dead' or 'unknown').
      public var status: String? { __data["status"] }
      /// The species of the character.
      public var species: String? { __data["species"] }
      /// The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
      public var gender: String? { __data["gender"] }
      /// Link to the character's image.
      /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
      public var image: String? { __data["image"] }
      /// Time at which the character was created in the database.
      public var created: String? { __data["created"] }
    }
  }
}
