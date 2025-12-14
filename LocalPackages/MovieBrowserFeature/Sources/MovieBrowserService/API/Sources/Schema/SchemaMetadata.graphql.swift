// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == MovieBrowserAPI.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == MovieBrowserAPI.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == MovieBrowserAPI.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == MovieBrowserAPI.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Character": return MovieBrowserAPI.Objects.Character
    case "CharacterConnection": return MovieBrowserAPI.Objects.CharacterConnection
    case "CharacterEdge": return MovieBrowserAPI.Objects.CharacterEdge
    case "CharacterImage": return MovieBrowserAPI.Objects.CharacterImage
    case "CharacterName": return MovieBrowserAPI.Objects.CharacterName
    case "FuzzyDate": return MovieBrowserAPI.Objects.FuzzyDate
    case "Media": return MovieBrowserAPI.Objects.Media
    case "MediaCoverImage": return MovieBrowserAPI.Objects.MediaCoverImage
    case "MediaTitle": return MovieBrowserAPI.Objects.MediaTitle
    case "MediaTrailer": return MovieBrowserAPI.Objects.MediaTrailer
    case "Page": return MovieBrowserAPI.Objects.Page
    case "PageInfo": return MovieBrowserAPI.Objects.PageInfo
    case "Query": return MovieBrowserAPI.Objects.Query
    case "Staff": return MovieBrowserAPI.Objects.Staff
    case "StaffName": return MovieBrowserAPI.Objects.StaffName
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
