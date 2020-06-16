# frozen_string_literal: true

# SDBM HTTP API
# Copyright (C) 2020 Derek Viera
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require 'concurrent-ruby'
require 'cuba'
require 'json'
require 'sdbm'
require 'securerandom'
require 'logger'
require './routes/api_insert'
require './routes/api_retrievedb'
require './routes/api_delete'
require './version'

logger = Logger.new('app.log')

Cuba.use Rack::CommonLogger, logger

Cuba.define do
  on get do
    on root do
      data = JSON.dump({ first_name: 'Hello', last_name: 'World' })
      res.json data
    end
    on "api/v#{API_VERSION}" do
      on 'retrieve' do
        run Api::RetrieveDB
      end
    end
  end
  on post do
    on "api/v#{API_VERSION}" do
      on 'insert' do
        run Api::Insert
      end
    end
  end
  on delete do
    on "api/v#{API_VERSION}" do
      on 'delete' do
        run Api::Delete
      end
    end
  end
end
