'use strict'


# Define controls
controls =
  countdown: require('./src/countdown').countdown


# Throw if jQuery is not available
throw new Error 'jQuery is not currently available' unless jQuery?


# Register controls as jQuery plugins
for name, control of controls
  jQuery.fn[name] = control
