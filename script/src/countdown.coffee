'use strict'


# Valid types
types =
  years: (date) -> date.getFullYear() - 1970
  months: (date) -> date.getMonth()
  days: (date) -> date.getDate() - 1
  hours: (date) -> date.getHours()
  minutes: (date) -> date.getMinutes()
  seconds: (date) -> date.getSeconds()
  milliseconds: (date) -> date.getMilliseconds()


# Countdown control
class Countdown

  # @param [jQuery] element
  # @param [String] type
  constructor: (@element, @type) ->
    throw new Error "Invalid countdown type \"#{@type}\"" unless types[@type]?
    @label  = @element.find '[data-label]'
    @value  = @element.find '[data-value]'
    @labels = @label.data 'label'

  # On update
  #
  # @param [Date] diff
  onUpdate: (diff) =>
    value = types[@type] diff
    unless value is @current
      @updateLabel value
      @updateValue value
      @current = value

  # Update the label
  #
  # @param [Number] value
  updateLabel: (value) =>
    if value is 1
      @label.text @labels[0]
    else
      @label.text @labels[1]

  # Update the value
  #
  # @param [Number] value
  updateValue: (value) =>
    @value.text value


# Countdown creator
#
# @param [Date] date
countdown = (date) ->
  controls = []

  @each ->
    element = jQuery @
    type = element.data 'countdown'
    controls.push new Countdown element, type

  interval = 36
  notify controls, date, interval
  setInterval =>
    notify controls, date, interval
  , interval


# Notify the controls of an update
#
# @param [Array] controls
# @param [Date] date
# @param [Number] interval
notify = (controls, date, interval) ->
  now = new Date()
  diff = date - now
  diff = null if diff < 0
  diff = new Date diff
  for control in controls
    control.onUpdate diff


# Exports
module.exports = {countdown}
