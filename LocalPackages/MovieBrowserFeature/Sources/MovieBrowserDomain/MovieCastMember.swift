import Foundation

package struct MovieCastMember: Identifiable, Hashable {
    package let id: Int
    package let name: String
    package let role: String?
    package let imageURL: URL?
    package let voiceActor: String?

    package init(
        id: Int,
        name: String,
        role: String?,
        imageURL: URL?,
        voiceActor: String?
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.imageURL = imageURL
        self.voiceActor = voiceActor
    }
}
