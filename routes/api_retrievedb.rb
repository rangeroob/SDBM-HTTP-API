# frozen_string_literal: true

module Api
  # Retrieve Database
  class RetrieveDB < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('./log/app.log')
    RetrieveDB.define do
      on ':db' do |db|
        if File.exist?("db/#{db}.pag")
          if lock.acquire_read_lock == true
            lock.with_read_lock do
              SDBM.open("db/#{db}", 0o444) do |database|
                hashed_database = database.to_hash
                res.json JSON.dump({
                                     status: 200,
                                     database: db.to_s,
                                     data: hashed_database
                                   })
                logger.info("SUCCESSFULLY RETRIEVED DATABASE #{db}")
              rescue SDBMError
                lock.release_read_lock
                sdbm_error
              rescue IndexError
                index_error
              rescue StandardError
                standard_error
              end
              lock.release_read_lock
              res.status = 200
            end
          else
            database_not_found
          end
        end
      end
    end
  end
end
