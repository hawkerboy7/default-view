# --------------------------------------------------
# DefaultView | A backbone view with some usefull functions/bindings
# --------------------------------------------------
class DefaultView extends Backbone.View

	constructor: ->

		# Create an object to store events
		@_DefaultView =
			parent   : null
			socket   : []
			children : []
			removeFromParent: ((view) =>

				return console.log "View to remove is not provided" if not view

				# Check if this view is foudn in the parent
				return console.log "View #{view} was not found in it's parent" if -1 is index = (children = @_DefaultView.parent._DefaultView.children).indexOf view

				# Remove the provided child view reference from this (parent) view
				children.splice index,1

			).bind this

		# --------------------------------------------------
		# Default Eventhandling
		# --------------------------------------------------
		if not App.Vent

			# Notification
			msg = "DefaultView requires a variable App.Vent to be an event emitter (preferably MiniEventEmitter)"

			# As warning if possible
			return console.warn msg if console.warn

			# As normal message
			console.log msg


		# --------------------------------------------------
		# Socket Eventhandling
		# --------------------------------------------------
		if App.Socket

			@socket = {}

			@socket.on = ((event, func) =>

				# Store event
				@_DefaultView.socket.push [event, func]

				# Set event listener
				App.Socket.on event, func

			).bind this

			@socket.off = ((event, func) =>

				# If event is provided turn it off
				return App.Socket.off event, func if event

				# Remove all event listeners of this view if no event is provided
				App.Socket.off events[0], events[1] for events in @_DefaultView.socket

				# Empty the array
				@_DefaultView.socket = []

			).bind this

			# Send along the emit event
			@socket.emit = (-> App.Socket.emit.apply App.Socket, arguments).bind this

			@socket.once = ((event, func) ->

				# Store event
				@_DefaultView.socket.push [event, func]

				# Set event listener
				App.Socket.once event, func

			).bind this

		# --------------------------------------------------
		# WebWorker Eventhandling
		# --------------------------------------------------
		if App.Worker

			@worker = {}

			# Pass along on event + provide the view's id to create a unique group for each view
			@worker.on = ((event, func) -> App.Worker.on event, @cid, func).bind this

			# Pass along off event + provide the view's id so only event's bound to this unique view are removed
			@worker.off = ((event, func) -> App.Worker.off event, @cid, func).bind this

			# Pass along event which will be send to all groups within the event
			@worker.emit = (-> App.Worker.emit.apply App.Worker, arguments).bind this

		# Run Backbone's constructor
		super


	# --------------------------------------------------
	# MiniEventEmitter Eventhandling
	# --------------------------------------------------
	on: (event, func) ->

		# Pass along on event + provide the view's id to create a unique group for each view
		App.Vent.on event, @cid, func


	off: (event, func) ->

		# Pass along off event + provide the view's id so only event's bound to this unique view are removed
		App.Vent.off event, @cid, func


	emit: ->

		# Pass along event which will be send to all groups within the event
		App.Vent.emit.apply App.Vent, arguments


	# --------------------------------------------------
	# DefaultView Backbone View logics
	# --------------------------------------------------
	append: (view) ->

		# Remove from previous parent reference list
		view._DefaultView.removeFromParent view if view._DefaultView.parent

		# Set the views parent to be me
		view._DefaultView.parent = this

		# Track the child view
		@_DefaultView.children.push view

		# Append the child view's element
		@$el.append view.el


	prepend: (view) ->

		# Remove from previous parent reference list
		view._DefaultView.removeFromParent view if view._DefaultView.parent

		# Set the views parent to be me
		view._DefaultView.parent = this

		# Track the child view
		@_DefaultView.children.push view

		# Prepend the child view's element
		@$el.prepend view.el


	empty: =>

		# Remove all children
		child.quit() for child in @_DefaultView.children by -1

		# Also remove any remaining html
		@$el.empty()


	quit: =>

		# Remove all children
		@empty()

		# Remove all MiniEventEmitter event listeners
		@off()

		# Remove all socket listeners
		@socket?.off()

		# Remove all worker listeners
		@worker?.off()

		# Get this view's index within the view's parent
		index = (children = @_DefaultView.parent._DefaultView.children).indexOf this

		# Remove this view as child from this view's parent
		children.splice index, 1

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


	hide: => @$el.removeClass "show-me"

	show: => @$el.addClass "show-me"

	leftClick : (e) -> e?.button is 0

	objLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> (e?.which || e?.key) is 13



module.exports = DefaultView
