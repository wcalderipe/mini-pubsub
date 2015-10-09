chai = require('chai')
should = chai.should()
expect = chai.expect
MiniPubSub = require('../lib/mini_pubsub')

describe '#constructor', ->
	it 'should create listeners object', ->
		channel = new MiniPubSub()
		expect(channel.listeners).to.not.be.a 'null'

describe '#subscribe', ->
	beforeEach ->
		@channel = new MiniPubSub()
		@channel.subscribe 'foo', ->
			return 'bar'

	it 'should push a new object in listeners array', ->
		expect(@channel.listeners['foo'].length).to.be.equal 1

	it 'should new listener\'s object have handler property', ->
		expect(@channel.listeners['foo'][0]).to.have.property 'handler'

	it 'should new listener\'s object have token property', ->
		expect(@channel.listeners['foo'][0]).to.have.property 'token'

	it 'should new listener\'s object have once property', ->
		expect(@channel.listeners['foo'][0]).to.have.property 'once'

	it 'should new listener\'s once property be false by default', ->
		expect(@channel.listeners['foo'][0].once).to.be.false

	it 'should return a token', ->
		channel = new MiniPubSub()
		token = channel.subscribe 'foo', ->
			return 'bar'

		expect(token).to.not.be.a 'null'

	it 'should push new listeners', ->
		@channel.subscribe 'foo', ->
			return 'baz'

		expect(@channel.listeners['foo'].length).to.be.equal 2

describe '#subscribeOnce', ->
	it 'should push a new listener with once property set as true', ->
		channel = new MiniPubSub()
		channel.subscribeOnce 'foo', ->
			return 'bar'

		expect(channel.listeners['foo'][0].once).to.be.true

	it 'should unsubscribe immediately after publish', ->
		channel = new MiniPubSub()
		channel.subscribeOnce 'foo', ->
			bar = 'bar'
		channel.publish 'foo'

		expect(channel.listeners['foo'].length).to.be.equal 0

describe '#publish', ->
	it 'should execute handlers of a event', (done) ->
		channel = new MiniPubSub()
		channel.subscribe 'foo', ->
			bar = 'bar'
			expect(bar).to.be.equal 'bar'
			done()
		channel.publish 'foo'

	it 'should inject params in handler function', (done) ->
		channel = new MiniPubSub()
		channel.subscribe 'foo', (params) ->
			expect(params.bar).to.be.equal 'bar'
			done()
		channel.publish 'foo', {bar: 'bar'}

describe '#unsubscribe', ->
	it 'should remove listener successfully', ->
		channel = new MiniPubSub()
		token = channel.subscribe 'foo', ->
			return 'bar'
		channel.unsubscribe token

		expect(channel.listeners['foo'].length).to.be.equal 0

describe '#unsubscribeAll', ->
	it 'should remove all listeners', ->
		channel = new MiniPubSub()
		channel.subscribe 'foo', ->
			return 'bar'
		channel.subscribe 'foo', ->
			return 'baz'

		channel.unsubscribeAll 'foo'

		expect(channel.listeners['foo'].length).to.be.equal 0

describe '#generateToken', ->
	it 'should remove hifens from uuid', ->
		channel = new MiniPubSub()
		token = channel.generateToken()

		expect(channel.generateToken().indexOf('-')).to.be.equal -1
