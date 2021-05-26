import Vapor
import Fluent
import FluentMySQLDriver



// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.mysql(hostname: "81.68.87.237", username: "root", password: "jiangMj@1", database: "podcast", tlsConfiguration: .none), as: .mysql)
    
    app.migrations.add(MyMigration())
//    app.migrations.add(UserTableMigration())
    app.migrations.add(CommentMigration())


    // register routes
    try routes(app)
}
