# --------------------------------------------------
# Default backbone view
# --------------------------------------------------
class Default extends Backbone.View

	constructor: ->

		# Create an object to store events
		@_default =
			events   : []
			socket   : []
			children : []

		# Create faster reference to the socket connection
		Default.prototype.socket = @__socket()

		# Run Backbone's constructor
		super


	__socket: ->

		socket =
			on: (eventName, func) =>

				# Store eventName
				@_default.socket.push [ eventName, func ]

				# Set event listener
				App.Socket.on eventName, func

			once: (eventName, func) =>

				# Store eventName
				@_default.socket.push [ eventName, func ]

				# Set event listener
				App.Socket.once eventName, func

			off: (eventName, func) =>

				# If eventName is provided turn it off
				return App.Socket.off eventName, func if eventName

				# Remove all event listeners of this view if no eventName is provided
				App.Socket.off event[0], event[1] for event in @_default.socket

			emit: =>

				# Send along the emit event
				App.Socket.emit.apply App.Socket, arguments


	on: (eventName, func) ->

		# Store eventName
		@_default.events.push [ eventName, func ]

		# Set event listener
		App.Vent.on eventName, func


	once: (eventName, func) ->

		# Store eventName
		@_default.events.push [ eventName, func ]

		# Set event listener
		App.Vent.once eventName, func


	off: (eventName, func) ->

		# If eventName is provided turn it off
		return App.Vent.off eventName, func if eventName

		# Remove all event listeners of this view if no eventName is provided
		App.Vent.off event[0], event[1] for event in @_default.events


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

	trigger: -> App.Vent.trigger.apply App.Vent, arguments

	leftClick : (e) -> e?.button is 0

	objectLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> (e.which || e.key) is 13 if e



module.exports = Default