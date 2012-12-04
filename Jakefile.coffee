'use strict'

# Dependencies
colors = require 'colors'
{exec} = require 'child_process'
path = require 'path'
watch = require 'node-watch'


# Paths
paths =
  npmbin:    './node_modules/.bin'
  script:
    bootstrap: './script/main.coffee'
    minified:  './script/main.min.js'
    src:       './script/src'


# Currently processing
processing =
  minify: false


# Default
desc 'Default task'
task 'default', ['minify']


# CI build
desc 'Continously integrate'
task 'ci', ->


# Minify
desc 'Minify client library'
task 'minify', ['minify:script']
namespace 'minify', ->

  desc 'Minify JavaScript'
  task 'script', (callback) ->
    cmd = "#{paths.npmbin}/browserify #{paths.script.bootstrap} | #{paths.npmbin}/uglifyjs --lift-vars -o #{paths.script.minified}"
    log 'Minifying client side JavaScript...', 'task'
    run [cmd], 'Minified successfully', {printStderr:true, breakOnError:true}, callback
  , async:true


# Watch
desc 'Watch client library for changes'
task 'watch', ['watch:script']
namespace 'watch', ->

  desc 'Watch JavaScript'
  task 'script', ->
    log 'Watching JavaScript...', 'task'
    watchPaths [paths.script.src, paths.script.bootstrap], /\.coffee$/, (file) ->
      unless processing.minify
        log ''
        log "Change discovered in #{file}", 'notice'
        processing.minify = true
        jake.Task['minify:script'].invoke ->
          processing.minify = false
  , async:true


# Run a command
#
# @param [Array] commands
# @param [String] successMsg
# @param [Object] options
# @param [Function] callback
run = (commands, successMsg, options, callback) ->
  callback ?= -> complete()
  exec commands, (error, stdout, stderr) ->
    unless error?
      log stdout if stdout
      log successMsg, 'success' if successMsg?
    else
      log stderr if stderr
    callback error, stdout, stderr
  , options


# Write to the log
#
# @param [String] message
# @param [String] level
log = (message, level) ->
  prefix = '[jake] '
  console.log switch level
    when 'task' then prefix + message.cyan
    when 'success' then prefix + message.green
    when 'notice' then prefix + message.yellow
    when 'error' then prefix + message.red
    else message

# Watch paths for changes
#
# @param [Array] paths
# @param [Regex] pattern
# @param [Function] callback
watchPaths = (paths, pattern, callback) ->
  for path in paths
    watch path, (file) ->
      callback file if pattern.test file
