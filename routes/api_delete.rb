# frozen_string_literal: true

module Api
  class Delete < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('app.log')
    Delete.define do
      on ':db/:key' do |db, key|
        if File.exist?("db/#{db}.pag")
          lock.with_write_lock do
            SDBM.open("db/#{db}") do |database|
              begin
                database.delete(key)
              rescue SDBMError
                lock.release_write_lock
                res.status = 500
              end
              lock.release_write_lock
              logger.info("DELETION AT #{key} WAS MADE SUCCESSFULLY")
              res.status = 204
            end
          end
        else
          logger.error("DATABASE #{db} DOES NOT EXIST")
          res.status = 500
        end
      end
    end
  end
end
