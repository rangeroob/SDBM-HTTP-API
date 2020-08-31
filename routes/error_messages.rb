# frozen_string_literal: true

def sdbm_error
  logger = Logger.new('./log/app.log')
  logger.error('SDBM ERROR COULD NOT READ DATABASE')
  res.status = 500
  res.json JSON.dump({
                       status: 500,
                       error: 'SDBM ERROR COULD NOT READ DATABASE'
                     })
end

def index_error
  logger = Logger.new('./log/app.log')
  logger.error('INDEX ERROR COULD NOT READ DATABASE')
  res.status = 500
  res.json JSON.dump({
                       status: 500,
                       error: 'INDEX ERROR COULD NOT READ DATABASE'
                     })
end

def standard_error
  logger = Logger.new('./log/app.log')
  logger.error('STANDARD ERROR COULD NOT READ DATABASE')
  res.status = 500
  res.json JSON.dump({
                       status: 500,
                       error: 'STANDARD ERROR COULD NOT READ DATABASE'
                     })
end

def database_not_found
  logger = Logger.new('./log/app.log')
  logger.error('DATABASE NOT FOUND')
  res.status = 404
  res.json JSON.dump({
                       status: 404,
                       error: 'DATABASE NOT FOUND'
                     })
end
