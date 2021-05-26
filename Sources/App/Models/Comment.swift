//
//  File.swift
//  
//
//  Created by Mika on 2021/5/20.
//

import Foundation
import Fluent
import Vapor

final class Comment: Model, Content {
    static let schema = "comment"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "user_name")
    var userName: String
    
    @Field(key: "comment_content")
    var commentContent: String
    
    @Field(key: "create_time")
    var createTime: Date?
    
    @Field(key: "track_id")
    var podcastTrackID: Int
    
    @Field(key: "guid")
    var episodeID: String
    
    init() {
    
    }
    
    init(id: UUID? = nil, userName: String, commentContent: String, createTime: Date? = nil, podcastTrackID: Int, episodeID: String) {
            self.id = id
            self.userName = userName
            self.commentContent = commentContent
            self.createTime = createTime ?? Date()
            self.podcastTrackID = podcastTrackID
            self.episodeID = episodeID
    }
}

struct CommentMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Make a change to the database.
        database.schema("comment")
                    .id()
                    .field("user_name", .string)
                    .field("comment_content", .string)
                    .field("create_time", .datetime)
                    .field("track_id", .int)
                    .field("guid", .string)
                    .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        // Undo the change made in `prepare`, if possible.
        database.schema("comment").delete()
    }
}
