'use strict'


# Throw if jQuery is not available
throw new Error 'jQuery is not currently available' unless jQuery?


# Register countdown as a jQuery plugin
jQuery.fn.countdown = require('./src/countdown').countdown
