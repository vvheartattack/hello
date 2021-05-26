//
//  File.swift
//  
//
//  Created by Mika on 2021/5/18.
//

import Foundation
import Fluent
import Vapor

final class User: Model, Content {
    // Name of the table or collection.
    static let schema = "user"

    // Unique identifier for this User
    @ID(key: .id)
    var id: UUID?

    // The User's name.
    @Field(key: "name")
    var name: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "nickname")
    var nickname: String?

    // Creates a new, empty User.
    init() { }

    // Creates a new user with all properties set.
    init(id: UUID? = nil, name: String, password: String, nickname: String? = nil) {
        self.id = id
        self.name = name
        self.password = password
        self.nickname = nickname
    }
}

// An example migration.
struct UserTableMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        // Make a change to the database.
        database.schema("user")
                    .id()
                    .field("name", .string)
                    .unique(on: "name")
                    .field("password", .string)
                    .field("nickname", .string)
                    .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        // Undo the change made in `prepare`, if possible.
        database.schema("user").delete()
    }
}
