import FluentProvider

final class Team: Model {
    
    let storage = Storage()
    
    let name: String
    let location: String
    let founded: Int
    let conference: String
    let division: String
    
    struct Properties {
        static let id = "id"
        static let name = "name"
        static let location = "location"
        static let founded = "founded"
        static let conference = "conference"
        static let division = "division"
    }
    
    init(name: String, location: String, founded: Int, conference: String, division: String) {
        self.name = name
        self.location = location
        self.founded = founded
        self.conference = conference
        self.division = division
    }
    
    init(row: Row) throws {
        name = try row.get(Properties.name)
        location = try row.get(Properties.location)
        founded = try row.get(Properties.founded)
        conference = try row.get(Properties.conference)
        division = try row.get(Properties.division)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Properties.name, name)
        try row.set(Properties.location, location)
        try row.set(Properties.founded, founded)
        try row.set(Properties.conference, conference)
        try row.set(Properties.division, division)
        return row
    }
}

extension Team {
    var players: Children<Team, Player> {
        return children()
    }
}

extension Team: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Properties.name)
            builder.string(Properties.location)
            builder.int(Properties.founded)
            builder.string(Properties.conference)
            builder.string(Properties.division)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Team: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Properties.name),
                      location: json.get(Properties.location),
                      founded: json.get(Properties.founded),
                      conference: json.get(Properties.conference),
                      division: json.get(Properties.division))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Properties.id, id)
        try json.set(Properties.name, name)
        try json.set(Properties.location, location)
        try json.set(Properties.founded, founded)
        try json.set(Properties.conference, conference)
        try json.set(Properties.division, division)
        return json
    }
}

extension Team: ResponseRepresentable {}
