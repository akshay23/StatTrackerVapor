import FluentProvider

final class Player: Model {
    
    let storage = Storage()
    
    let firstName: String
    let lastName: String
    let position: String
    let age: Int
    let jerseyNumber: Int
    let yearsPro: Int
    let teamID: Identifier?
    
    struct Properties {
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let position = "position"
        static let age = "age"
        static let jerseyNumber = "jerseyNumber"
        static let yearsPro = "yearsPro"
        static let teamID = "team_id"
    }
    
    init(firstName: String, lastName: String, position: String, age: Int, jerseyNumber: Int, yearsPro: Int, team: Team) {
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.age = age
        self.jerseyNumber = jerseyNumber
        self.yearsPro = yearsPro
        self.teamID = team.id
    }
    
    init(row: Row) throws {
        firstName = try row.get(Properties.firstName)
        lastName = try row.get(Properties.lastName)
        position = try row.get(Properties.position)
        age = try row.get(Properties.age)
        jerseyNumber = try row.get(Properties.jerseyNumber)
        yearsPro = try row.get(Properties.yearsPro)
        teamID = try row.get(Team.foreignIdKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.firstName, firstName)
        try row.set(Properties.lastName, lastName)
        try row.set(Properties.position, position)
        try row.set(Properties.age, age)
        try row.set(Properties.jerseyNumber, jerseyNumber)
        try row.set(Properties.yearsPro, yearsPro)
        try row.set(Team.foreignIdKey, teamID)
        return row
    }
}

extension Player {
    var team: Parent<Player, Team> {
        return parent(id: teamID)
    }
}

// Create the tables when app first runs
extension Player: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            // Create columns
            builder.id()
            builder.string(Properties.firstName)
            builder.string(Properties.lastName)
            builder.string(Properties.position)
            builder.int(Properties.age)
            builder.int(Properties.jerseyNumber)
            builder.int(Properties.yearsPro)
            builder.parent(Team.self)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Player: JSONConvertible {
    convenience init(json: JSON) throws {
        let teamID: Identifier = try json.get(Properties.teamID)
        guard let team = try Team.find(teamID) else {
            throw Abort.badRequest
        }
        
        try self.init(firstName: json.get(Properties.firstName),
                      lastName: json.get(Properties.lastName),
                      position: json.get(Properties.position),
                      age: json.get(Properties.age),
                      jerseyNumber: json.get(Properties.jerseyNumber),
                      yearsPro: json.get(Properties.yearsPro),
                      team: team)
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.firstName, firstName)
        try json.set(Properties.lastName, lastName)
        try json.set(Properties.age, age)
        try json.set(Properties.position, position)
        try json.set(Properties.yearsPro, yearsPro)
        try json.set(Properties.jerseyNumber, jerseyNumber)
        try json.set(Properties.teamID, teamID)
        return json
    }
}

// Since there is a JSON representation
extension Player: ResponseRepresentable {}

extension Player: SoftDeletable {}
