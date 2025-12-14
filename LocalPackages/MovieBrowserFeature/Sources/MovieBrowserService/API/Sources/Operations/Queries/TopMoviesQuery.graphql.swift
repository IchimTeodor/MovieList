// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class TopMoviesQuery: GraphQLQuery {
  public static let operationName: String = "TopMovies"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query TopMovies($page: Int, $perPage: Int, $format: MediaFormat = MOVIE) { Page(page: $page, perPage: $perPage) { __typename pageInfo { __typename currentPage hasNextPage } media(format: $format, sort: SCORE_DESC) { __typename id title { __typename romaji english } averageScore genres coverImage { __typename extraLarge large } isFavourite format startDate { __typename year } endDate { __typename year } } } }"#
    ))

  public var page: GraphQLNullable<Int>
  public var perPage: GraphQLNullable<Int>
  public var format: GraphQLNullable<GraphQLEnum<MediaFormat>>

  public init(
    page: GraphQLNullable<Int>,
    perPage: GraphQLNullable<Int>,
    format: GraphQLNullable<GraphQLEnum<MediaFormat>> = .init(.movie)
  ) {
    self.page = page
    self.perPage = perPage
    self.format = format
  }

  public var __variables: Variables? { [
    "page": page,
    "perPage": perPage,
    "format": format
  ] }

  public struct Data: MovieBrowserAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("Page", Page?.self, arguments: [
        "page": .variable("page"),
        "perPage": .variable("perPage")
      ]),
    ] }
    public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      TopMoviesQuery.Data.self
    ] }

    public var page: Page? { __data["Page"] }

    /// Page
    ///
    /// Parent Type: `Page`
    public struct Page: MovieBrowserAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Page }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("pageInfo", PageInfo?.self),
        .field("media", [Medium?]?.self, arguments: [
          "format": .variable("format"),
          "sort": "SCORE_DESC"
        ]),
      ] }
      public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        TopMoviesQuery.Data.Page.self
      ] }

      /// The pagination information
      public var pageInfo: PageInfo? { __data["pageInfo"] }
      public var media: [Medium?]? { __data["media"] }

      /// Page.PageInfo
      ///
      /// Parent Type: `PageInfo`
      public struct PageInfo: MovieBrowserAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.PageInfo }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("currentPage", Int?.self),
          .field("hasNextPage", Bool?.self),
        ] }
        public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          TopMoviesQuery.Data.Page.PageInfo.self
        ] }

        /// The current page
        public var currentPage: Int? { __data["currentPage"] }
        /// If there is another page
        public var hasNextPage: Bool? { __data["hasNextPage"] }
      }

      /// Page.Medium
      ///
      /// Parent Type: `Media`
      public struct Medium: MovieBrowserAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.Media }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int.self),
          .field("title", Title?.self),
          .field("averageScore", Int?.self),
          .field("genres", [String?]?.self),
          .field("coverImage", CoverImage?.self),
          .field("isFavourite", Bool.self),
          .field("format", GraphQLEnum<MovieBrowserAPI.MediaFormat>?.self),
          .field("startDate", StartDate?.self),
          .field("endDate", EndDate?.self),
        ] }
        public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          TopMoviesQuery.Data.Page.Medium.self
        ] }

        /// The id of the media
        public var id: Int { __data["id"] }
        /// The official titles of the media in various languages
        public var title: Title? { __data["title"] }
        /// A weighted average score of all the user's scores of the media
        public var averageScore: Int? { __data["averageScore"] }
        /// The genres of the media
        public var genres: [String?]? { __data["genres"] }
        /// The cover images of the media
        public var coverImage: CoverImage? { __data["coverImage"] }
        /// If the media is marked as favourite by the current authenticated user
        public var isFavourite: Bool { __data["isFavourite"] }
        /// The format the media was released in
        public var format: GraphQLEnum<MovieBrowserAPI.MediaFormat>? { __data["format"] }
        /// The first official release date of the media
        public var startDate: StartDate? { __data["startDate"] }
        /// The last official release date of the media
        public var endDate: EndDate? { __data["endDate"] }

        /// Page.Medium.Title
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
            TopMoviesQuery.Data.Page.Medium.Title.self
          ] }

          /// The romanization of the native language title
          public var romaji: String? { __data["romaji"] }
          /// The official english title
          public var english: String? { __data["english"] }
        }

        /// Page.Medium.CoverImage
        ///
        /// Parent Type: `MediaCoverImage`
        public struct CoverImage: MovieBrowserAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.MediaCoverImage }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("extraLarge", String?.self),
            .field("large", String?.self),
          ] }
          public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            TopMoviesQuery.Data.Page.Medium.CoverImage.self
          ] }

          /// The cover image url of the media at its largest size. If this size isn't available, large will be provided instead.
          public var extraLarge: String? { __data["extraLarge"] }
          /// The cover image url of the media at a large size
          public var large: String? { __data["large"] }
        }

        /// Page.Medium.StartDate
        ///
        /// Parent Type: `FuzzyDate`
        public struct StartDate: MovieBrowserAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.FuzzyDate }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("year", Int?.self),
          ] }
          public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            TopMoviesQuery.Data.Page.Medium.StartDate.self
          ] }

          /// Numeric Year (2017)
          public var year: Int? { __data["year"] }
        }

        /// Page.Medium.EndDate
        ///
        /// Parent Type: `FuzzyDate`
        public struct EndDate: MovieBrowserAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { MovieBrowserAPI.Objects.FuzzyDate }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("year", Int?.self),
          ] }
          public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            TopMoviesQuery.Data.Page.Medium.EndDate.self
          ] }

          /// Numeric Year (2017)
          public var year: Int? { __data["year"] }
        }
      }
    }
  }
}
