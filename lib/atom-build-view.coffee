{View} = require 'atom'
BuilderRegistry = require './builder-registry'
path = require 'path'
Convert = require 'ansi-to-html'
ansi = new Convert

module.exports =
class AtomBuildView extends View
  @content: ->
    @div class: 'atom-build tool-panel panel-bottom', =>
      @div class: 'panel-body', =>
        @ul class: 'panel inset-panel bordered', outlet: 'output'

  registry: null

  initialize: (serializeState) ->
    @registry = new BuilderRegistry [path.join(__dirname, '..', 'builders'), atom.project?.getPath()]

    atom.workspaceView.command "atom-build:build", => @build()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  afterAttach: ->
    @output.css
      'font-family': atom.config.get('editor.fontFamily')
      'font-size': atom.config.get('editor.fontSize')
      'line-height': atom.config.get('editor.lineHeight')
    @fgColor = @output.css('color')

  build: ->
    atom.workspaceView.prependToBottom(this)
    if builder = @registry.findBuilder(atom.workspace.getActiveEditor())
      @output.append "<li>Using build file #{builder.path}</li>"
      proc = builder.build(this)
      proc.on 'stdout', (message) =>
        message = ansi.toHtml(message).replace('color:#FFF', 'color:' + @fgColor)
        @output.append "<li>#{message}</li>"
      proc.on 'stderr', (message) =>
        message = ansi.toHtml(message).replace('color:#FFF', 'color:' + @fgColor)
        @output.append "<li class=\"error\">#{message}</li>"
      proc.on 'exit', (code) =>
        if code isnt 0
            @output.append "<li class=\"exit error\">Exited with code #{code}</li>"
        else
            @output.append "<li class=\"exit success\">Exited with code #{code}</li>"

    else
      console.log 'no builder found'
