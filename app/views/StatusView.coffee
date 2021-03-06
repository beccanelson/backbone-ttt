$ = require('jquery')
_ = require('underscore')
Backbone = require('backbone')
messages = require('../../config/UIConfig').statusMessages

StatusView = Backbone.View.extend(
  el: '#status-container'

  initialize: ->
    @render()
    @listenTo @model, 'change', @showStatus

  render: ->
    compiler = @model.get('compiler')
    compiler.load("status", _.bind(((template)->
      compiler.appendToContainer("#status-container", template)
      @showStatus()), this))

  showStatus: ->
    text = @getStatusText(@model.get('status'))
    $("#status").html(text)

  getStatusText: (status) ->
    switch status
      when "tie" then messages.tie
      when "player1Wins" then messages.player1Wins
      when "player2Wins" then messages.player2Wins
      when "in progress" then @getInProgressText()

  getInProgressText: ->
    if @model.get('isXTurn')
      @model.player1TurnMessage
    else
      @model.player2TurnMessage
)

module.exports = StatusView
