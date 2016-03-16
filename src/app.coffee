# --------------------------------------------------
# NPM
# --------------------------------------------------
window.$ = require 'jquery'
_        = require 'lodash'
Backbone = require 'backbone'

# Create a (e)Vent object if not defined yet
window.Vent = _.extends {}, Backbone.Events if not window.Vent



# --------------------------------------------------
# Default backbone view
# --------------------------------------------------
class Default extends Backbone.View

	constructor: ->

		# Create an object to store events
		@_default =
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

		# Track the child view
		@_default.children.push view

		# Append the child view's element
		@$el.append view.el


	prepend: (view) ->

		# Track the child view
		@_default.children.push view

		# Prepend the child view's element
		@$el.prepend view.el


	block : (e) ->

		# Prevent the default event
		e.preventDefault()

		# Prevent the event from propagating (bubling up/notifying parent views)
		e.stopPropagation()


	quit: =>

		# Remove all children
		@empty()

		# Remove all event listeners
		@off()

		# Remove element
		@remove()


	empty: =>

		# Remove all children
		child.quit() for child in @_default.children


	hide: => @$el.removeClass 'show-me'

	show: => @$el.addClass 'show-me'

	trigger: -> Vent.trigger.apply Vent, arguments

	leftClick : (e) -> e?.button is 0

	objectLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> (e.which || e.key) is 13 if e



module.exports = Default