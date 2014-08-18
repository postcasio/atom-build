fs = require 'fs'
{BufferedProcess} = require 'atom'
{Emitter} = require 'emissary'
_ = require 'underscore'

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

class BuildProcess
	Emitter.includeInto this
	constructor: (options) ->
		new BufferedProcess _.extend options,
			stdout: (data) => @emit 'stdout', data
			stderr: (data) => @emit 'stderr', data
			exit: (code) => @emit 'exit', code

module.exports = Builder
