eco = require "eco"
fs  = require "fs"

Home = require './controllers/home'
Collections = require './controllers/collections'
Games = require './controllers/games'
Settings = require './controllers/settings'

Spine.Controller.prototype.view = (path, data) ->
  template = fs.readFileSync __dirname + "/views/#{path}.eco", "utf-8"
  eco.render template, data

class App extends Spine.Stack
  className: 'stack root'

  events:
    'click .settings-button': 'toggleSettings'

  controllers:
    home: Home
    collections: Collections
    games: Games
    settings: Settings

  default: 'home'

  activeController: ->
    for controller in @manager.controllers
      if controller.isActive()
        return controller
        break

  showHome: ->
    console.log('showing home')

    @home.update()
    @home.active()

  showCollection: ->
    console.log('showing collections')

    @collections.update()
    @home.active()

  toggleSettings: ->
    if @settings.isActive()
      @showHome()
    else
      @settings.active()

  showGames: (collection) ->
    @games.collection = collection
    @games.update()
    @games.active()

  keydown: (e) ->
    @activeController().keyboardNav(e)

module.exports = App
