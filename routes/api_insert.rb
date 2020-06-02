# frozen_string_literal: true

module Api
  class Insert < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('app.log')
    Insert.define do
      on 'insert/:db/:key&:value' do |db, key, value|
        if File.exist?("db/#{db}.pag")
          lock.with_write_lock do
            SDBM.open("db/#{db}") do |database|
              begin
                database[key.to_s] = value.to_s
              rescue SDBMError
                lock.release_write_lock
                logger.error("INSERTION FOR #{key} = #{value} WAS MADE UNSUCCESSFULLY")
                res.status = 500
              end
              lock.release_write_lock
              logger.info("INSERTION FOR #{key} = #{value} WAS MADE SUCCESSFULLY")
              res.status = 201
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
