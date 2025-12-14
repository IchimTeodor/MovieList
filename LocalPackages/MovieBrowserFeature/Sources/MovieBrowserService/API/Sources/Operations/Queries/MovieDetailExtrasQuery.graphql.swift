// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MovieDetailExtrasQuery: GraphQLQuery {
  public static let operationName: String = "MovieDetailExtras"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MovieDetailExtras($id: Int, $type: MediaType = ANIME) { Media(id: $id, type: $type) { __typename id characters(perPage: 8, sort: [ROLE, RELEVANCE, ID]) { __typename edges { __typename role node { __typename id name { __typename full } image { __typename large } } voiceActors(language: JAPANESE, sort: [RELEVANCE, ID]) { __typename name { __typename full } } } } } }"#
    ))

  public var id: GraphQLNullable<Int>
  public var type: GraphQLNullable<GraphQLEnum<MediaType>>

  public init(
    id: GraphQLNullable<Int>,
    type: GraphQLNullable<GraphQLEnum<MediaType>> = .init(.anime)
  ) {
    self.id = id
    self.type = type
  }

  public var __variables: Variables? { [
    "id": id,
    "type": type
  ] }

  public struct Data: MovieBrowserAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Media", Media?.self, arguments: [
        "id": .variable("id"),
        "type": .variable("type")
      ]),
    ] }
    public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      MovieDetailExtrasQuery.Data.self
    ] }

    /// Media query
    public var media: Media? { __data["Media"] }

    /// Media
    ///
    /// Parent Type: `Media`
    public struct Media: MovieBrowserAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Media }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", Int.self),
        .field("characters", Characters?.self, arguments: [
          "perPage": 8,
          "sort": ["ROLE", "RELEVANCE", "ID"]
        ]),
      ] }
      public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MovieDetailExtrasQuery.Data.Media.self
      ] }

      /// The id of the media
      public var id: Int { __data["id"] }
      /// The characters in the media
      public var characters: Characters? { __data["characters"] }

      /// Media.Characters
      ///
      /// Parent Type: `CharacterConnection`
      public struct Characters: MovieBrowserAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.CharacterConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge?]?.self),
        ] }
        public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MovieDetailExtrasQuery.Data.Media.Characters.self
        ] }

        public var edges: [Edge?]? { __data["edges"] }

        /// Media.Characters.Edge
        ///
        /// Parent Type: `CharacterEdge`
        public struct Edge: MovieBrowserAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.CharacterEdge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("role", GraphQLEnum<MovieBrowserAPI.CharacterRole>?.self),
            .field("node", Node?.self),
            .field("voiceActors", [VoiceActor?]?.self, arguments: [
              "language": "JAPANESE",
              "sort": ["RELEVANCE", "ID"]
            ]),
          ] }
          public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            MovieDetailExtrasQuery.Data.Media.Characters.Edge.self
          ] }

          /// The characters role in the media
          public var role: GraphQLEnum<MovieBrowserAPI.CharacterRole>? { __data["role"] }
          public var node: Node? { __data["node"] }
          /// The voice actors of the character
          public var voiceActors: [VoiceActor?]? { __data["voiceActors"] }

          /// Media.Characters.Edge.Node
          ///
          /// Parent Type: `Character`
          public struct Node: MovieBrowserAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Character }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", Int.self),
              .field("name", Name?.self),
              .field("image", Image?.self),
            ] }
            public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MovieDetailExtrasQuery.Data.Media.Characters.Edge.Node.self
            ] }

            /// The id of the character
            public var id: Int { __data["id"] }
            /// The names of the character
            public var name: Name? { __data["name"] }
            /// Character images
            public var image: Image? { __data["image"] }

            /// Media.Characters.Edge.Node.Name
            ///
            /// Parent Type: `CharacterName`
            public struct Name: MovieBrowserAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.CharacterName }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("full", String?.self),
              ] }
              public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MovieDetailExtrasQuery.Data.Media.Characters.Edge.Node.Name.self
              ] }

              /// The character's first and last name
              public var full: String? { __data["full"] }
            }

            /// Media.Characters.Edge.Node.Image
            ///
            /// Parent Type: `CharacterImage`
            public struct Image: MovieBrowserAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.CharacterImage }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("large", String?.self),
              ] }
              public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MovieDetailExtrasQuery.Data.Media.Characters.Edge.Node.Image.self
              ] }

              /// The character's image of media at its largest size
              public var large: String? { __data["large"] }
            }
          }

          /// Media.Characters.Edge.VoiceActor
          ///
          /// Parent Type: `Staff`
          public struct VoiceActor: MovieBrowserAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Staff }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", Name?.self),
            ] }
            public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              MovieDetailExtrasQuery.Data.Media.Characters.Edge.VoiceActor.self
            ] }

            /// The names of the staff member
            public var name: Name? { __data["name"] }

            /// Media.Characters.Edge.VoiceActor.Name
            ///
            /// Parent Type: `StaffName`
            public struct Name: MovieBrowserAPI.SelectionSet {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.StaffName }
              public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("full", String?.self),
              ] }
              public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                MovieDetailExtrasQuery.Data.Media.Characters.Edge.VoiceActor.Name.self
              ] }

              /// The person's first and last name
              public var full: String? { __data["full"] }
            }
          }
        }
      }
    }
  }
}
