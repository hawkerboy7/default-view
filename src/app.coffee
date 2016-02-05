# --------------------------------------------------
# NPM
# --------------------------------------------------
window.$ = require 'jquery'
_        = require 'lodash'
Backbone = require 'backbone'

# Create a (e)Vent object if not defined yet
window.Vent = _.extends {}, Backbone.Events if not window.Vent

# Unique id for each default view
i = 0



# --------------------------------------------------
# Default backbone view
# --------------------------------------------------
class Default extends Backbone.View


	constructor: ->

		# Increment
		i++

		# Create an object to store events
		@_default =
			id       : i
			events   : []
			children : []

		# Run Backbone's constructor
		super


	on: (eventName, func) ->

		# Store eventName
		@_default.events.push [ eventName, func ]

		# Set event listener
		Vent.on eventName, func


	once: (eventName, func) ->

		# Store eventName
		@_default.events.push [ eventName, func ]

		# Set event listener
		Vent.once eventName, func


	off: (eventName, func) ->

		# If eventName is provided turn it off
		return Vent.off eventName, func if eventName

		# Remove all event listeners of this view if no eventName is provided
		Vent.off event[0], event[1] for event in @_default.events


	append: (view) ->

		@_default.children.push view

		@$el.append view.el


	preppend: (view) ->

		@_default.children.push view

		@$el.prepend view.el


	block : (e) ->
		e.preventDefault()
		e.stopPropagation()


	quit: =>

		# Remove all children
		child.quit() for child in @_default.children

		# Remove all event listeners
		@off()

		# Remove element
		@remove()


	hide: => @$el.removeClass 'show-me'

	show: => @$el.addClass 'show-me'

	trigger: -> Vent.trigger.apply Vent, arguments

	leftClick : (e) -> e?.button is 0

	objectLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> (e.which || e.key) is 13 if e



module.exports = Default