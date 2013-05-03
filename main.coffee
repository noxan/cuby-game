express = require('express')

coffee = require 'coffee-script'

path = require('path')
url = require('url')
fs = require('fs')


app = express()


app.get '/:script.js', (req, res) ->
  res.header 'Content-Type', 'application/x-javascript'
  coffeeScript = fs.readFileSync "#{__dirname}/coffee/#{req.params.script}.coffee", "ascii"
  res.send coffee.compile coffeeScript

app.use(express.static('public'))


app.listen(8080)
console.log "Running server on 8080"
