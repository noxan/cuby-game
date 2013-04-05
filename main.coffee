sys = require('sys')
http = require('http')
path = require('path')
url = require('url')
fs = require('fs')

errorResponse = (response, status, message) ->
    response.writeHeader status, {'Content/Type': 'text/plain'}
    response.end status + ' ' + message + '\n'


http.createServer((request, response) ->
    requestPath = url.parse(request.url).pathname
    fullPath = path.join(process.cwd(), requestPath)

    fs.exists fullPath, (exists) ->
        if not exists
            errorResponse response, 404, "Not found"
        else
            fs.readFile fullPath, 'binary', (error, file) ->
                if error
                    errorResponse response, 500, error
                else
                    response.writeHeader(200)
                    response.write(file, 'binary')
                    response.end()
).listen 8080


sys.puts "Running server on 8080"
