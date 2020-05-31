# frozen_string_literal: true

module Api
  class RetrieveDB < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('app.log')
    RetrieveDB.define do
      on ':db' do |db|
        if lock.acquire_read_lock == true
          lock.with_read_lock do
            SDBM.open("db/#{db}", 0o444) do |database|
              hashed_database = database.to_hash
              res.json JSON.dump(hashed_database)
            rescue SDBMError
              lock.release_read_lock
              logger.error('SDBM ERROR COULD NOT READ DATABASE')
              res.status = 500
            end
          end
          lock.release_read_lock
          res.status = 200
        end
      end
    end
  end
end
