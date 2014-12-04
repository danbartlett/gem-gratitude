# gem-gratitude

Give back to the gems you depend on! gem-gratitude will scan your Gemfile and find any open issues for you help out on.

Ensure you run gem-gratitude.rb in a directory which has a Gemfile and has been `bundle install`ed.

`ruby gem-gratitude.rb`

Then open up `giveback.html` to view all issues you can help with.

# Dependencies

Requires httparty and redcarpet.

`gem install httparty`
`gem install redcarpet`

# Todo

* Bundle into gem
* Display issue labels along with preview
* Figure out GitHub urls for non GH [:homepage]'s
* Exclusion list

# Ideas

* Run as webserver that parses all Gemfiles in a Workspace (containing multiple projects)
* Embed as a link in any project README that says "help out with issues on dependencies for this project"

# Thanks

Hat tip to @andrew and [24pullrequests](http://24pullrequests.com/) for the idea.