# frozen_string_literal: true

module Api
  # Delete key-value pair where key is located
  class DeleteWhereKey < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('./log/app.log')
    DeleteWhereKey.define do
      on ':db/:key' do |db, key|
        if File.exist?("db/#{db}.pag")
          lock.with_write_lock do
            SDBM.open("db/#{db}") do |database|
              begin
                database.delete(key)
              rescue SDBMError
                sdbm_error
              rescue IndexError
                index_error
              rescue StandardError
                standard_error
              end
              lock.release_write_lock
              logger.info("DELETION AT #{key} PASSED")
              res.status = 204
            end
          end
        else
          database_not_found
        end
      end
    end
  end
end
