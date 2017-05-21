# --------------------------------------------------
# DefaultView | A backbone view with some usefull functions/bindings
# --------------------------------------------------
class DefaultView extends Backbone.View

	constructor: ->

		# Create an object to store events
		@_DefaultView =

			# Keep track if at least one event has been set for this view
			set      : false

			# Store which socket events this view has added to socket.io
			socket   : []

			# Keep references to parent and children
			parent   : null
			children : []

			# Remove the reference to this view from the parent
			removeFromParent: ((view) =>

				return console.log "View to remove is not provided" if not view

				# Check if this view is foudn in the parent
				return console.log "View #{view} was not found in it's parent" if -1 is index = (children = @_DefaultView.parent._DefaultView.children).indexOf view

				# Remove the provided child view reference from this (parent) view
				children.splice index,1

			).bind this


		# --------------------------------------------------
		# Client-db handling
		# --------------------------------------------------
		if App.DB

			@db = {}

			# Pass along on events but add the devaul view id as group
			@db.on      = ((event, func) -> App.DB.on event, @cid, func).bind this
			@db.off     = ((event, func) -> App.DB.off event, @cid, func).bind this

			# Pass the complete call along
			@db.emit    = (-> App.DB.emit.apply App.DB, arguments).bind this
			@db.trigger = (-> App.DB.trigger.apply App.DB, arguments).bind this
			@db.find   = (-> App.DB.find.apply App.DB, arguments).bind this
			@db.insert = (-> App.DB.insert.apply App.DB, arguments).bind this
			@db.update = (-> App.DB.update.apply App.DB, arguments).bind this
			@db.delete = (-> App.DB.delete.apply App.DB, arguments).bind this

			# DB helpers
			@db.delta = (-> App.DB.delta.apply App.DB, arguments).bind this
			@db.start = (-> App.DB.start.apply App.DB, arguments).bind this

			# Referneces
			@db.data     = App.DB.data
			@db.schema   = App.DB.schema
			@db.events   = App.DB.events
			@db.groups   = App.DB.groups
			@db.options  = App.DB.options
			@db.settings = App.DB.settings


		# --------------------------------------------------
		# Default Eventhandling
		# --------------------------------------------------
		if not App.Vent

			# Notification
			msg = "DefaultView requires App.Vent to be the event emitter: MiniEventEmitter (https://github.com/hawkerboy7/mini-event-emitter)"

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

				# Remove all eventListeners of this view if no event is provided
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

		# Remove all children in reverse order so the index remains correct because the children also remove themselves from the children array
		child.quit() for child in @_DefaultView.children by -1

		# Also remove any remaining html
		@$el.empty()


	quit: =>

		# Remove all children
		@empty()

		# Remove all MiniEventEmitter eventListeners of this view if they exist
		@off null if App.Vent.groups[@cid]

		# Remove all client-db eventListeners of this view if they exist
		@db.off null if @db.groups[@cid]

		# Remove all socket listeners
		@socket?.off()

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
		@preventDefault e

		# Prevent the event from propagating (bubling up/notifying parent views)
		@stopPropagation e

		# Return false
		false


	preventDefault : (e) -> e.preventDefault()

	stopPropagation : (e) -> e.stopPropagation()

	hide: => @$el.removeClass "show-me"

	show: => @$el.addClass "show-me"

	leftClick : (e) -> e?.button is 0

	objLength : (obj) -> Object.keys(obj).length

	enterPressed : (e) -> (e?.which || e?.key) is 13



module.exports = DefaultView
