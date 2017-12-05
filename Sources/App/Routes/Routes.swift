import Vapor

extension Droplet {
    func setupRoutes() throws {
        let teamController = TeamsController()
        teamController.addRoutes(to: self)
        
        let playerController = PlayersController()
        playerController.addRoutes(to: self)
        
        let gamesController = GamesController()
        gamesController.addRoutes(to: self)
    }
}
