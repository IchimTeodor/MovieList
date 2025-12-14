// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class MovieDetailInfoQuery: GraphQLQuery {
  public static let operationName: String = "MovieDetailInfo"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query MovieDetailInfo($id: Int, $type: MediaType = ANIME) { Media(id: $id, type: $type) { __typename id title { __typename romaji english } description averageScore meanScore genres duration bannerImage countryOfOrigin isFavourite isAdult trailer { __typename id site } } }"#
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
      MovieDetailInfoQuery.Data.self
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
        .field("title", Title?.self),
        .field("description", String?.self),
        .field("averageScore", Int?.self),
        .field("meanScore", Int?.self),
        .field("genres", [String?]?.self),
        .field("duration", Int?.self),
        .field("bannerImage", String?.self),
        .field("countryOfOrigin", MovieBrowserAPI.CountryCode?.self),
        .field("isFavourite", Bool.self),
        .field("isAdult", Bool?.self),
        .field("trailer", Trailer?.self),
      ] }
      public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        MovieDetailInfoQuery.Data.Media.self
      ] }

      /// The id of the media
      public var id: Int { __data["id"] }
      /// The official titles of the media in various languages
      public var title: Title? { __data["title"] }
      /// Short description of the media's story and characters
      public var description: String? { __data["description"] }
      /// A weighted average score of all the user's scores of the media
      public var averageScore: Int? { __data["averageScore"] }
      /// Mean score of all the user's scores of the media
      public var meanScore: Int? { __data["meanScore"] }
      /// The genres of the media
      public var genres: [String?]? { __data["genres"] }
      /// The general length of each anime episode in minutes
      public var duration: Int? { __data["duration"] }
      /// The banner image of the media
      public var bannerImage: String? { __data["bannerImage"] }
      /// Where the media was created. (ISO 3166-1 alpha-2)
      public var countryOfOrigin: MovieBrowserAPI.CountryCode? { __data["countryOfOrigin"] }
      /// If the media is marked as favourite by the current authenticated user
      public var isFavourite: Bool { __data["isFavourite"] }
      /// If the media is intended only for 18+ adult audiences
      public var isAdult: Bool? { __data["isAdult"] }
      /// Media trailer or advertisement
      public var trailer: Trailer? { __data["trailer"] }

      /// Media.Title
      ///
      /// Parent Type: `MediaTitle`
      public struct Title: MovieBrowserAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.MediaTitle }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("romaji", String?.self),
          .field("english", String?.self),
        ] }
        public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MovieDetailInfoQuery.Data.Media.Title.self
        ] }

        /// The romanization of the native language title
        public var romaji: String? { __data["romaji"] }
        /// The official english title
        public var english: String? { __data["english"] }
      }

      /// Media.Trailer
      ///
      /// Parent Type: `MediaTrailer`
      public struct Trailer: MovieBrowserAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.MediaTrailer }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", String?.self),
          .field("site", String?.self),
        ] }
        public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          MovieDetailInfoQuery.Data.Media.Trailer.self
        ] }

        /// The trailer video id
        public var id: String? { __data["id"] }
        /// The site the video is hosted by (Currently either youtube or dailymotion)
        public var site: String? { __data["site"] }
      }
    }
  }
}
