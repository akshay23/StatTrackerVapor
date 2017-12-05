import FluentProvider

struct PlayersController {
    
    func addRoutes(to drop: Droplet) {
        let playerGroup = drop.grouped("api", "players")
        playerGroup.post("create", handler: createPlayer)
        playerGroup.get(handler: allPlayers)
        playerGroup.get(Player.parameter, handler: getPlayer)
        playerGroup.delete(handler: deleteAllPlayers)
        playerGroup.get(Player.parameter, "team", handler: getPlayerTeam)
    }
    
    func createPlayer(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        let player = try Player(json: json)
        try player.save()
        return player
    }
    
    func allPlayers(_ req: Request) throws -> ResponseRepresentable {
        let players = try Player.all()
        return try players.makeJSON()
    }
    
    func getPlayer(_ req: Request) throws -> ResponseRepresentable {
        let player = try req.parameters.next(Player.self)
        return player
    }
    
    func deleteAllPlayers(_ req: Request) throws -> ResponseRepresentable {
        let players = try Player.all()
        for player in players {
            try player.delete()
        }
        
        return try Player.all().makeJSON()
    }
    
    func getPlayerTeam(_ req: Request) throws -> ResponseRepresentable {
        let player = try req.parameters.next(Player.self)
        guard let team = try player.team.get() else {
            throw Abort.notFound
        }
        return team
    }
}
