import FluentProvider

struct TeamsController {
    
    func addRoutes(to drop: Droplet) {
        let teamGroup = drop.grouped("api", "teams")
        teamGroup.post("create", handler: createTeam)
        teamGroup.get(handler: allTeams)
        teamGroup.get(Team.parameter, handler: getTeam)
        teamGroup.delete(Team.parameter, handler: deleteTeam)
        teamGroup.delete(handler: deleteAllTeams)
        teamGroup.get(Team.parameter, "players", handler: getPlayers)
    }
    
    func createTeam(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        let team = try Team(json: json)
        try team.save()
        return team
    }
    
    func allTeams(_ req: Request) throws -> ResponseRepresentable {
        let teams = try Team.all()
        return try teams.makeJSON()
    }
    
    func deleteTeam(_ req: Request) throws -> ResponseRepresentable {
        let team = try req.parameters.next(Team.self)
        try team.delete()
        return try Team.all().makeJSON()
    }
    
    func deleteAllTeams(_ req: Request) throws -> ResponseRepresentable {
        let teams = try Team.all()
        for team in teams {
            try team.delete()
        }
        
        return try Team.all().makeJSON()
    }
    
    func getTeam(_ req: Request) throws -> ResponseRepresentable {
        let team = try req.parameters.next(Team.self)
        return team
    }
    
    func getPlayers(_ req: Request) throws -> ResponseRepresentable {
        let team = try req.parameters.next(Team.self)
        return try team.players.all().makeJSON()
    }
}
