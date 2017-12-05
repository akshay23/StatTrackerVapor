import FluentProvider

final class Game: Model {
    
    let storage = Storage()
    
    let homeTeamID: Identifier?
    let homeTeamScore: Int
    let awayTeamID: Identifier?
    let awayTeamScore: Int
    let crowdSize: Int
    let arenaName: String
    
    struct Properties {
        static let homeTeamID = "homeTeamID"
        static let homeTeamScore = "homeTeamScore"
        static let awayTeamID = "awayTeamID"
        static let awayTeamScore = "awayTeamScore"
        static let crowdSize = "crowdSize"
        static let arenaName = "arenaName"
    }
    
    init(homeTeam: Team, homeTeamScore: Int, awayTeam: Team, awayTeamScore: Int, crowdSize: Int, arenaName: String) {
        homeTeamID = homeTeam.id
        awayTeamID = awayTeam.id
        self.homeTeamScore = homeTeamScore
        self.awayTeamScore = awayTeamScore
        self.crowdSize = crowdSize
        self.arenaName = arenaName
    }
    
    init(row: Row) throws {
        homeTeamID = try row.get(Properties.homeTeamID)
        homeTeamScore = try row.get(Properties.homeTeamScore)
        awayTeamID = try row.get(Properties.awayTeamID)
        awayTeamScore = try row.get(Properties.awayTeamScore)
        crowdSize = try row.get(Properties.crowdSize)
        arenaName = try row.get(Properties.arenaName)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.homeTeamID, homeTeamID)
        try row.set(Properties.homeTeamScore, homeTeamScore)
        try row.set(Properties.awayTeamID, awayTeamID)
        try row.set(Properties.awayTeamScore, awayTeamScore)
        try row.set(Properties.crowdSize, crowdSize)
        try row.set(Properties.arenaName, arenaName)
        return row
    }
}

extension Game {
    var homeTeam: Parent<Game, Team> {
        return parent(id: homeTeamID)
    }
    
    var awayTeam: Parent<Game, Team> {
        return parent(id: awayTeamID)
    }
}

extension Game: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Properties.homeTeamID)
            builder.int(Properties.homeTeamScore)
            builder.string(Properties.awayTeamID)
            builder.int(Properties.awayTeamScore)
            builder.int(Properties.crowdSize)
            builder.string(Properties.arenaName)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Game: JSONConvertible {
    convenience init(json: JSON) throws {
        let hTeamID: Identifier = try json.get(Properties.homeTeamID)
        guard let homeTeam = try Team.find(hTeamID) else {
            throw Abort.badRequest
        }
        
        let aTeamID: Identifier = try json.get(Properties.awayTeamID)
        guard let awayTeam = try Team.find(aTeamID) else {
            throw Abort.badRequest
        }
        
        try self.init(homeTeam: homeTeam,
                      homeTeamScore: json.get(Properties.homeTeamScore),
                      awayTeam: awayTeam,
                      awayTeamScore: json.get(Properties.awayTeamScore),
                      crowdSize: json.get(Properties.crowdSize),
                      arenaName: json.get(Properties.arenaName))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.homeTeamID, homeTeamID)
        try json.set(Properties.homeTeamScore, homeTeamScore)
        try json.set(Properties.awayTeamID, awayTeamID)
        try json.set(Properties.awayTeamScore, awayTeamScore)
        try json.set(Properties.crowdSize, crowdSize)
        try json.set(Properties.arenaName, arenaName)
        return json
    }
}

extension Game: ResponseRepresentable {}

extension Game: SoftDeletable {}
