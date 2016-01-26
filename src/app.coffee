# --------------------------------------------------
# Default backbone view
# --------------------------------------------------
class Default extends Backbone.View


	constructor: ->

		# Create an object to store events
		@_default =
			events: []

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

		if eventName

			# If eventName is provided turn it off
			return Vent.off eventName, func

		# Remove all event listeners of this view if no eventName is provided
		for event in @_default.events

			# Remove event listener
			Vent.off event[0], event[1]


	block : (e) ->
		e.preventDefault()
		e.stopPropagation()


	hide: => @$el.removeClass 'show-me'

	show: => @$el.addClass 'show-me'

	quit: => @off(); @remove()

	trigger: -> Vent.trigger.apply Vent, arguments

	leftClick : (e) -> e?.button is 0

	objectLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> (e.which || e.key) is 13 if e



module.exports = Default