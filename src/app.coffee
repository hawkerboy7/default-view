# --------------------------------------------------
# DefaultView | A backbone view with some usefull functions/bindings
# --------------------------------------------------
class DefaultView extends Backbone.View

	constructor: ->

		# Create an object to store events
		@_DefaultView =
			socket   : []
			children : []

		# Create faster reference to the socket connection
		DefaultView.prototype.socket = @__socket()

		# Run Backbone's constructor
		super


	# --------------------------------------------------
	# Socket Eventhandling
	# --------------------------------------------------
	__socket: ->

		socket =
			on: (eventName, func) =>

				# Store eventName
				@_DefaultView.socket.push [ eventName, func ]

				# Set event listener
				App.Socket.on eventName, func

			once: (eventName, func) =>

				# Store eventName
				@_DefaultView.socket.push [ eventName, func ]

				# Set event listener
				App.Socket.once eventName, func

			off: (eventName, func) =>

				# If eventName is provided turn it off
				return App.Socket.off eventName, func if eventName

				# Remove all event listeners of this view if no eventName is provided
				App.Socket.off event[0], event[1] for event in @_DefaultView.socket

			emit: =>

				# Send along the emit event
				App.Socket.emit.apply App.Socket, arguments


	# --------------------------------------------------
	# MiniEventEmitter Eventhandling
	# --------------------------------------------------
	on: (eventName, func) ->

		# Pass along on event + provide the view's id to create a unique group for each view
		App.Vent.on eventName, @cid, func


	off: (eventName, func) ->

		# Pass along off event + provide the view's id so only event's bound to this unique view are removed
		App.Vent.off eventName, @cid, func


	emit: ->

		# Pass along event which will be send to all groups within the event
		App.Vent.emit.apply App.Vent, arguments


	# --------------------------------------------------
	# DefaultView Backbone View logics
	# --------------------------------------------------
	append: (view) ->

		# Track the child view
		@_DefaultView.children.push view

		# Append the child view's element
		@$el.append view.el


	prepend: (view) ->

		# Track the child view
		@_DefaultView.children.push view

		# Prepend the child view's element
		@$el.prepend view.el


	empty: =>

		# Remove all children
		child.quit() for child in @_DefaultView.children


	quit: =>

		# Remove all children
		@empty()

		# Remove all event listeners
		@off()

		# Remove all socket listeners
		@socket.off()

		# Remove this DOM element
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



module.exports = DefaultView