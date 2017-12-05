import FluentProvider

final class Stat: Model {
    
    let storage = Storage()
    
    let playerID: Identifier?
    let gameID: Identifier?
    let minutes: Int
    let points: Int
    let assists: Int
    let rebounds: Int
    let steals: Int
    let fouls: Int
    let fieldGoalsAttemped: Int
    let fieldGoalsMade: Int
    let freeThrowsAttemped: Int
    let freeThrowsMade: Int
    
    struct Properties {
        static let playerID = Player.foreignIdKey
        static let gameID = Game.foreignIdKey
        static let minutes = "minutes"
        static let points = "points"
        static let assists = "assists"
        static let rebounds = "rebounds"
        static let steals = "steals"
        static let fouls = "fouls"
        static let fieldGoalsAttemped = "fieldGoalsAttemped"
        static let fieldGoalsMade = "fieldGoalsMade"
        static let freeThrowsAttemped = "freeThrowsAttemped"
        static let freeThrowsMade = "freeThrowsMade"
    }
    
    init(player: Player, game: Game, minutes: Int, points: Int, assists: Int, rebounds: Int, steals: Int, fouls: Int,
         fieldGoalsAttemped: Int, fieldGoalsMade: Int, freeThrowsAttemped: Int, freeThrowsMade: Int) {
        playerID = player.id
        gameID = game.id
        self.minutes = minutes
        self.points = points
        self.assists = assists
        self.rebounds = rebounds
        self.steals = steals
        self.fouls = fouls
        self.fieldGoalsAttemped = fieldGoalsAttemped
        self.fieldGoalsMade = fieldGoalsMade
        self.freeThrowsAttemped = freeThrowsAttemped
        self.freeThrowsMade = freeThrowsMade
    }
    
    init(row: Row) throws {
        playerID = try row.get(Properties.playerID)
        gameID = try row.get(Properties.gameID)
        minutes = try row.get(Properties.minutes)
        points = try row.get(Properties.points)
        assists = try row.get(Properties.assists)
        rebounds = try row.get(Properties.rebounds)
        steals = try row.get(Properties.steals)
        fouls = try row.get(Properties.fouls)
        fieldGoalsAttemped = try row.get(Properties.freeThrowsAttemped)
        fieldGoalsMade = try row.get(Properties.freeThrowsMade)
        freeThrowsAttemped = try row.get(Properties.freeThrowsAttemped)
        freeThrowsMade = try row.get(Properties.freeThrowsMade)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.playerID, playerID)
        try row.set(Properties.gameID, gameID)
        try row.set(Properties.minutes, minutes)
        try row.set(Properties.points, points)
        try row.set(Properties.assists, assists)
        try row.set(Properties.rebounds, rebounds)
        try row.set(Properties.steals, steals)
        try row.set(Properties.fouls, fouls)
        try row.set(Properties.fieldGoalsAttemped, fieldGoalsAttemped)
        try row.set(Properties.fieldGoalsMade, fieldGoalsMade)
        try row.set(Properties.freeThrowsMade, freeThrowsMade)
        try row.set(Properties.freeThrowsAttemped, freeThrowsAttemped)
        return row
    }
}

extension Stat {
    var player: Parent<Stat, Player> {
        return parent(id: playerID)
    }
}

extension Stat: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.int(Properties.minutes)
            builder.int(Properties.points)
            builder.int(Properties.assists)
            builder.int(Properties.steals)
            builder.int(Properties.rebounds)
            builder.int(Properties.fouls)
            builder.int(Properties.fieldGoalsAttemped)
            builder.int(Properties.fieldGoalsMade)
            builder.int(Properties.freeThrowsAttemped)
            builder.int(Properties.freeThrowsMade)
            builder.int(Properties.gameID)
            builder.parent(Player.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Stat: JSONConvertible {
    convenience init(json: JSON) throws {
        let playerID: Identifier = try json.get(Properties.playerID)
        guard let player = try Player.find(playerID) else {
            throw Abort.badRequest
        }
        
        let gameID: Identifier = try json.get(Properties.gameID)
        guard let game = try Game.find(gameID) else {
            throw Abort.badRequest
        }
        
        try self.init(player: player,
                      game: game,
                      minutes: json.get(Properties.minutes),
                      points: json.get(Properties.points),
                      assists: json.get(Properties.assists),
                      rebounds: json.get(Properties.rebounds),
                      steals: json.get(Properties.steals),
                      fouls: json.get(Properties.fouls),
                      fieldGoalsAttemped: json.get(Properties.fieldGoalsAttemped),
                      fieldGoalsMade: json.get(Properties.fieldGoalsMade),
                      freeThrowsAttemped: json.get(Properties.freeThrowsAttemped),
                      freeThrowsMade: json.get(Properties.freeThrowsMade))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.points, points)
        try json.set(Properties.minutes, minutes)
        try json.set(Properties.assists, assists)
        try json.set(Properties.rebounds, rebounds)
        try json.set(Properties.steals, steals)
        try json.set(Properties.fouls, fouls)
        try json.set(Properties.fieldGoalsAttemped, fieldGoalsAttemped)
        try json.set(Properties.fieldGoalsMade, fieldGoalsMade)
        try json.set(Properties.freeThrowsAttemped, freeThrowsAttemped)
        try json.set(Properties.freeThrowsMade, freeThrowsMade)
        try json.set(Properties.playerID, playerID)
        try json.set(Properties.gameID, gameID)
        return json
    }
}

extension Stat: ResponseRepresentable {}

extension Stat: SoftDeletable {}
