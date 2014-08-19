fs = require 'fs'
BuildProcess = require './build-process'

class Builder
	config: null

	constructor: (@path) ->
		@config = JSON.parse fs.readFileSync path

	build: (buildView) ->
		cmd = @config.cmd

		new BuildProcess
			command: cmd[0]
			args: cmd.slice 1
			options:
				cwd: atom.project.getPath()

	getScope: -> @config.scope

module.exports = Builder
