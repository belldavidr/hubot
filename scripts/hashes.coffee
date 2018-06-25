# Description:
#  Queries the hashes.org api (v2) for plaintext, given a hash
#
# Dependencies
#  None
#
# Configuration:
#  HASHES_API_KEY from hashes.org (user account required)
#
# Commands:
#  hubot *hash check `hash`* - queries hashes.org to see if `hash` has already been cracked
#
# Author:
#   belldavidr

token = process.env.HASHES_API_KEY

module.exports = (robot) ->
  robot.respond /hash (?:check) (.*)/i, (res) ->
    hash = res.match[1]
    url = "https://hashes.org/api.php?key=#{token}&query=#{hash}"
    robot.http(url).get() (err, response, body) ->
      if err
        res.send ":disappointed: Encountered an error while searching hashes: #{err}"
        return
      else
        if response.statusCode == 200
          body = JSON.parse(body)
          if body.result is 'null'
            res.send ":disappointed: Hash not found.  Ask @dave to crack it? :smiling_imp:"
            return
          else
            res.send ":exclamation: Cracked!  Hash: `#{hash}` plaintext: `#{result}`"
            return