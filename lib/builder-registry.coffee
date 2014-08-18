glob = require 'glob'
Builder = require './builder'
path = require 'path'

class BuilderRegistry
	constructor: (@searchPaths) ->
		@builders = []

		for searchPath in searchPaths
			files = glob.sync path.join(searchPath, '**', '*.{atom,sublime}-build')
			@loadBuilder file for file in files


	loadBuilder: (path) ->
		@builders.push new Builder(path)

	findBuilder: (editor) ->
		for builder in @builders
			return builder if builder.getScope() == editor.getGrammar().scopeName
		return null

module.exports = BuilderRegistry
