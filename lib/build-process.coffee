{Emitter} = require 'emissary'
_ = require 'underscore'
{BufferedProcess} = require 'atom'

class BuildProcess
	Emitter.includeInto this
	constructor: (options) ->
		new BufferedProcess _.extend options,
			stdout: (data) => @emit 'stdout', data
			stderr: (data) => @emit 'stderr', data
			exit: (code) => @emit 'exit', code

module.exports = BuildProcess
