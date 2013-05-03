express = require('express')

coffee = require 'coffee-script'

path = require('path')
url = require('url')
fs = require('fs')


app = express()


app.get '/:script.js', (req, res) ->
  res.header 'Content-Type', 'application/x-javascript'
  cs = fs.readFileSync "#{__dirname}/coffee/#{req.params.script}.coffee", "ascii"
  js = coffee.compile cs
  res.send js

app.use(express.static('public'))


app.listen(8080)
console.log "Running server on 8080"
