fs = require 'fs'
path = require 'path'
BuildProcess = require './build-process'

variablePlaceholderRegex = /\$\{([a-z_]+)\:(.*?)\}/i
variableRegexRegex = /\$\{([a-z_]+)\/(.*?)\/(.*?)\/\}/i
variableRegex = /\$([a-z_]+)/i

class Builder
	config: null

	constructor: (@path) ->
		@config = JSON.parse fs.readFileSync path

	expand: (str, variables) ->
		changed = true
		previous = null
		while str isnt previous
			previous = str
			str = @expandStep str, variables

		str

	expandStep: (str, variables) ->
		str = str.replace variablePlaceholderRegex, (match, variable, placeholder) -> variables[variable] ? placeholder
		str = str.replace variableRegexRegex, (match, variable, search, replace) -> (variables[variable] ? '').replace(new RegExp(search), replace)
		str = str.replace variableRegex, (match, variable) -> variables[variable] ? ''

	variables: ->
		editor = atom.workspace.getActiveEditor()

		filePath = editor.getPath()
		projectPath = atom.project.getPath()

		file_path: path.dirname filePath
		file: filePath
		file_name: path.basename filePath
		file_extension: path.extname filePath
		file_base_name: path.basename filePath, path.extname filePath
		packages: atom.packages.getPackageDirPaths()[0]
		project: projectPath
		project_path: projectPath
		project_name: path.basename projectPath
		project_extension: ''
		project_basename: path.basename projectPath

	build: (buildView) ->
		vars = @variables()

		cmd = @config.cmd.map (arg) => @expand arg, vars

		new BuildProcess
			command: cmd[0]
			args: cmd.slice 1
			options:
				cwd: atom.project.getPath()

	getScope: -> @config.scope

module.exports = Builder
