import FluentProvider

struct PlayersController {
    
    func addRoutes(to drop: Droplet) {
        let playerGroup = drop.grouped("api", "players")
        playerGroup.post("create", handler: createPlayer)
        playerGroup.get(handler: allPlayers)
        playerGroup.get(Team.parameter, handler: getPlayer)
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
}
