# frozen_string_literal: true

module Api
  # Store the key value pair given
  class StoreKeyValue < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('./log/app.log')
    StoreKeyValue.define do
      on ':db/:key&:value' do |db, key, value|
        if File.exist?("db/#{db}.pag")
          lock.with_write_lock do
            SDBM.open("db/#{db}") do |database|
              begin
                database.store(key, value)
              rescue SDBMError
                sdbm_error
              rescue IndexError
                index_error
              rescue StandardError
                standard_error
              end
              lock.release_write_lock
              logger.info("STORING #{key} = #{value} PASSED")
              res.status = 201
            end
          end
        else
          database_not_found
        end
      end
    end
  end
end
