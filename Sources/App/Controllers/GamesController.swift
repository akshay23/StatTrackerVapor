import FluentProvider

struct GamesController {
    
    func addRoutes(to drop: Droplet) {
        let gameGroup = drop.grouped("api", "games")
        gameGroup.post("create", handler: createGame)
        gameGroup.get(handler: allGames)
        gameGroup.get(Game.parameter, handler: getGame)
        gameGroup.delete(handler: deleteAllGames)
        gameGroup.get(Game.parameter, "hometeam", handler: getHomeTeam)
        gameGroup.get(Game.parameter, "awayteam", handler: getAwayTeam)
    }
    
    func createGame(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        let game = try Game(json: json)
        try game.save()
        return game
    }
    
    func allGames(_ req: Request) throws -> ResponseRepresentable {
        let games = try Game.all()
        return try games.makeJSON()
    }
    
    func getGame(_ req: Request) throws -> ResponseRepresentable {
        let game = try req.parameters.next(Game.self)
        return game
    }
    
    func deleteAllGames(_ req: Request) throws -> ResponseRepresentable {
        let games = try Game.all()
        for game in games {
            try game.delete()
        }
        
        return try Game.all().makeJSON()
    }
    
    func getHomeTeam(_ req: Request) throws -> ResponseRepresentable {
        let game = try req.parameters.next(Game.self)
        guard let team = try game.homeTeam.get() else {
            throw Abort.notFound
        }
        return team
    }
    
    func getAwayTeam(_ req: Request) throws -> ResponseRepresentable {
        let game = try req.parameters.next(Game.self)
        guard let team = try game.awayTeam.get() else {
            throw Abort.notFound
        }
        return team
    }
}
