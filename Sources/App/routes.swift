import Vapor
import Fluent

struct Greeting: Content {
    var hi: String?
}

struct Login: Content {
    var name: String
    var password: String
}

struct Parameter: Content {
    var podcastTrackID: Int
    var episodeID: String
}


func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("hi", ":name") { req -> String in
        let name = req.parameters.get("name")!
        return "hi,\(name)!"
    }
    
    app.get("hey") { req -> String in
        let greeting = try req.query.decode(Greeting.self)
        return "hey,\(greeting.hi ?? "Empty")"
    }
    
    app.post("greeting") { req -> String in
        let greeting = try req.content.decode(Greeting.self)
        print(greeting.hi!)
        return "hi,\(greeting.hi!)!"
    }
    
    app.get("galaxies") { req in
        Galaxy.query(on: req.db).all()
    }
    
    app.post("galaxies") { req -> EventLoopFuture<Galaxy> in
        let galaxy = try req.content.decode(Galaxy.self)
        return galaxy.create(on: req.db)
            .map { galaxy }
    }

    app.post("login") { req -> EventLoopFuture<ResultEntity<Bool>> in
            // 从 content 中解析出用户发送的 user 对象
            let userFromParameter = try req.content.decode(User.self)
            
            return User.query(on: req.db)
                .filter(\.$name == userFromParameter.name)
                .first() // EventLoopFuture<User?>
                .flatMap { (userFromDb: User?) -> EventLoopFuture<ResultEntity<Bool>> in
                    if let userFromDb = userFromDb {
                        // 该用户名已注册过，走登录逻辑
                        if userFromDb.password == userFromParameter.password {
                            // 密码正确
                            return req.eventLoop.makeSucceededFuture(ResultEntity.success(data: true))
                        } else {
                            return req.eventLoop.makeSucceededFuture(ResultEntity.success(message: "wrong password", data: false))
                        }
                    } else {
                        // 没注册过
                        return userFromParameter.create(on: req.db)
                            .map {
                                return ResultEntity.success(data: true)
                            }
                    }
                }
    }
    
    app.get("comment") { req -> EventLoopFuture<ResultEntity<[Comment]>> in
            struct Parameter: Content {
                var podcastTrackID: Int
                var episodeID: String
            }
            let parameter = try req.query.decode(Parameter.self)
            return Comment.query(on: req.db)
                .filter(\.$episodeID == parameter.episodeID)
                .filter(\.$podcastTrackID == parameter.podcastTrackID)
                .all()
                .map {
                    ResultEntity.success(data: $0)
                }
            
        }
    
    app.post("comment") { req -> EventLoopFuture<ResultEntity<Comment>> in
            let commentFromParameter = try req.content.decode(Comment.self)
            commentFromParameter.createTime = Date()
            return commentFromParameter.create(on: req.db).map {
                return ResultEntity.success(data: commentFromParameter)
            }
    }
     
    
}
