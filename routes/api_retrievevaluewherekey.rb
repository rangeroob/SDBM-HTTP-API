# frozen_string_literal: true

module Api
  # Retrieve the value when given the key
  class RetrieveValueWhereKey < Cuba
    lock = Concurrent::ReadWriteLock.new
    logger = Logger.new('./log/app.log')
    RetrieveValueWhereKey.define do
      on ':db/:key' do |db, key|
        if File.exist?("db/#{db}.pag")
          SDBM.open("db/#{db}") do |database|
            value = database.fetch(key)
            res.json JSON.dump({
                                 status: 200,
                                 database: db.to_s,
                                 data: [
                                   key: key,
                                   value: value
                                 ]
                               })
            logger.info("SUCCESSFULLY RETRIEVED KEY-VALUE PAIR FROM #{db}")
          rescue SDBMError
            lock.release_read_lock
            sdbm_error
          rescue IndexError
            index_error
          rescue StandardError
            standard_error
          end
        else
          database_not_found
        end
      end
    end
  end
end
