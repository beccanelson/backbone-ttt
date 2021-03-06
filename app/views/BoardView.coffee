Backbone = require('backbone')
$ = require('jquery')
classes = require('../../config/UIConfig').classes

BoardView = Backbone.View.extend(
  el: '#board-container'
  events:
    'click .spot': 'move'

  initialize: ->
    @render()
    @listenTo @model, 'change', @update

  render: ->
    compiler = @model.get('compiler')
    compiler.load("board", (template)->
      compiler.appendToContainer("#board-container", template)
      $(".spot").height $(".spot").width())

  move: (e) ->
    spotClicked = $(e.currentTarget)
    if spotClicked.hasClass classes.enabled
      @disableAllSpots()
      @model.makeMove spotClicked.attr('id')

  update: ->
    @showBoard()
    if @model.isOver()
      @disableAllSpots()
    else
      @enableEmptySpots()

  showBoard: ->
    for i in [0...9]
      marker = @model.get('board')[i]
      $('#' + i).html @getMarkerHTML(marker)

  getMarkerHTML: (marker) ->
    htmlclass = if marker == 'X' then classes.x else classes.o
    "<span class=#{htmlclass}>#{marker}</span>"

  applyToAllSpots: (functionToApply) ->
    for i in [0...9]
      $spot = $('#' + i)
      functionToApply($spot, i)

  enableAllSpots: ->
    @applyToAllSpots ($spot) ->
      unless $spot.hasClass classes.enabled
        $spot.addClass classes.enabled

  disableAllSpots: ->
    @applyToAllSpots ($spot) ->
      if $spot.hasClass classes.enabled
        $spot.removeClass classes.enabled

  enableEmptySpots: ->
    board = @model.get('board')
    @applyToAllSpots ($spot, i) ->
      if board[i] == ""
        $spot.addClass classes.enabled
)

module.exports = BoardView
