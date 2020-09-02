# frozen_string_literal: true

require 'cuba/test'
require_relative '../app'

scope do
  test 'get root' do
    get '/'
    assert last_response.ok?
    assert_equal last_response.body,
                 '{"status":200,"Program_name":"SDBM HTTP API","License":"AGPL-3.0-or-later","Author":"Derek Viera"}'
    assert_equal 200, last_response.status
  end
end

scope do
  setup do
    Dir.mkdir('db') unless File.exist?('db')
    SDBM.open('db/test') do |db|
      db['hello'] = 'world'
    end
  end

  test 'retrieve database' do
    get '/api/v1/retrieve_db/test'
    assert last_response.ok?
    assert_equal last_response.status, 200
    assert_equal last_response.body, '{"status":200,"database":"test","data":{"hello":"world"}}'
  end
  FileUtils.rm_rf('db')
end

scope do
  setup do
    Dir.mkdir('db') unless File.exist?('db')
    SDBM.open('db/test') do |db|
      db['hello'] = 'world'
    end
  end

  test 'delete where key' do
    delete '/api/v1/delete_where_key/test/hello'
    assert_equal last_response.status, 204
  end
  FileUtils.rm_rf('db')
end

scope do
  setup do
    Dir.mkdir('db') unless File.exist?('db')
    SDBM.open('db/test') do |db|
      db['hello'] = 'world'
    end
  end

  test 'retrieve value where key' do
    get 'api/v1/retrieve_value_where_key/test/hello'
    assert last_response.ok?
    assert_equal last_response.status, 200
    assert_equal last_response.body, '{"status":200,"database":"test","data":[{"key":"hello","value":"world"}]}'
  end
  test 'index error retrieve value where key' do
    get 'api/v1/retrieve_value_where_key/test/world'
    assert_equal last_response.status, 500
    assert_equal last_response.body, '{"status":500,"error":"INDEX ERROR COULD NOT READ DATABASE"}'
  end
  FileUtils.rm_rf('db')
end

scope do
  Dir.mkdir('db') unless File.exist?('db')
  SDBM.open('db/test') do |db|
    db['hello'] = 'world'
  end

  test 'store key value pair' do
    post 'api/v1/store_key_value/test/key&value'
    assert_equal last_response.status, 201
  end
  FileUtils.rm_rf('db')
end
