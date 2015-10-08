_ = require 'lodash'
uuid = require 'uuid'

class MiniPubSub
	constructor: ->
		@listeners = {}

	subscribe: (event, handler, once = false) ->
		unless @listeners[event]
			@listeners[event] = []

		listener =
			handler: handler,
			token: this.generateToken(),
			once: once

		@listeners[event].push(listener)

		return listener.token

	subscribeOnce: (event, handler) ->
		return this.subscribe(event, handler, true)

	unsubscribe: (token) ->
		_.forEach @listeners, (listener) ->
			_.remove listener, (handler) ->
				if handler.token == token
					return true

	unsubscribeAll: (event) ->
		@listeners[event] = []

	publish: (event, params) ->
		self = this

		unless @listeners[event]
			return false

		params = params || {}

		_.forEach @listeners[event], (listener) ->
			listener.handler(params)
			if listener.once
				self.unsubscribe(listener.token)

	generateToken: ->
		return uuid.v1().replace(/\-/g, '')

module.exports = MiniPubSub
