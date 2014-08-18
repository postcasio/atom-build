AtomBuildView = require './atom-build-view'

module.exports =
  AtomBuildView: null

  activate: (state) ->
    @atomBuildView = new AtomBuildView(state.atomBuildViewState)

  deactivate: ->
    @atomBuildView.destroy()

  serialize: ->
    atomBuildViewState: @atomBuildView.serialize()
