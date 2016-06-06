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

	# --------------------------------------------------
	# Socket Eventhandling
	# --------------------------------------------------
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

	# --------------------------------------------------
	# MiniEventEmitter Eventhandling
	# --------------------------------------------------
	on: (eventName, func) ->

		# Store eventName
		@_default.events.push [ eventName, func ]

		# Set event listener
		App.Vent.on eventName, func


	off: (eventName, func) ->

		# If eventName is provided turn it off
		return App.Vent.off eventName, func if eventName

		# Remove all event listeners of this view if no eventName is provided
		App.Vent.off event[0], event[1] for event in @_default.events


	emit: ->

		# Emit event
		App.Vent.emit.apply App.Vent, arguments


	# --------------------------------------------------
	# DefaultView Backbone View logics
	# --------------------------------------------------
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


	empty: =>

		# Remove all children
		child.quit() for child in @_default.children


	quit: =>

		# Remove all children
		@empty()

		# Remove all event listeners
		@off()

		# Remove all socket listeners
		@socket.off()

		# Remove element
		@remove()


	# --------------------------------------------------
	# Shortcuts
	# --------------------------------------------------
	block : (e) ->

		# Prevent the default event
		e.preventDefault()

		# Prevent the event from propagating (bubling up/notifying parent views)
		e.stopPropagation()


	hide: => @$el.removeClass 'show-me'

	show: => @$el.addClass 'show-me'

	leftClick : (e) -> e?.button is 0

	objLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> return if e and (e.which || e.key) is 13 then true else false



module.exports = Default