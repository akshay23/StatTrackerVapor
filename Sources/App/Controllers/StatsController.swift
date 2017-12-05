import FluentProvider

struct StatsController {
    
    func addRoutes(to drop: Droplet) {
        let statGroup = drop.grouped("api", "stats")
        statGroup.post("create", handler: createStat)
        statGroup.get(handler: allStats)
        statGroup.get(Stat.parameter, handler: getStat)
        statGroup.delete(handler: deleteAllStats)
        statGroup.get(Stat.parameter, "player", handler: getStatPlayer)
    }
    
    func createStat(_ req: Request) throws -> ResponseRepresentable {
        guard let json = req.json else {
            throw Abort.badRequest
        }
        
        let stat = try Stat(json: json)
        try stat.save()
        return stat
    }
    
    func allStats(_ req: Request) throws -> ResponseRepresentable {
        let stats = try Stat.all()
        return try stats.makeJSON()
    }
    
    func getStat(_ req: Request) throws -> ResponseRepresentable {
        let stat = try req.parameters.next(Stat.self)
        return stat
    }
    
    func deleteAllStats(_ req: Request) throws -> ResponseRepresentable {
        let stats = try Stat.all()
        for stat in stats {
            try stat.delete()
        }
        
        return try Stat.all().makeJSON()
    }
    
    func getStatPlayer(_ req: Request) throws -> ResponseRepresentable {
        let stat = try req.parameters.next(Stat.self)
        guard let player = try stat.player.get() else {
            throw Abort.notFound
        }
        return player
    }
}
