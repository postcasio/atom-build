glob = require 'glob'
Builder = require './builder'
path = require 'path'

class BuilderRegistry
	constructor: (@searchPaths) ->
		@builders = []

		for searchPath in searchPaths
			files = glob.sync path.join(searchPath, '**', '*.{atom,sublime}-build')
			@load file for file in files


	load: (path) ->
		@builders.push new Builder(path)

	find: (editor) ->
		for builder in @builders
			return builder if builder.getScope() == editor.getGrammar().scopeName
		return null

module.exports = BuilderRegistry
