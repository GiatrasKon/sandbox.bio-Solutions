# Identify filter: is applied to a JSON document, returns all of its input, used for pretty-printing
echo '{"key1": {"key2":"value1"}}' | jq '.'

#=========================================================FILTER DATA=========================================================

#-------------------------------------------------------Select Elements-------------------------------------------------------

# Using jq to filter the data returned by the GitHub repository API. The data we get back by default looks like this:
curl "https://api.github.com/repos/stedolan/jq" > repo.json; cat repo.json

# jq lets us treat the JSON document as an object and select elements inside of it.
# Here is how we filter the JSON document to select the value of the 'name' key:
jq '.name' repo.json

# Similarly, for selecting the value of the owner key:
jq '.owner' repo.json

# We can drill in as far as we want like this:
jq '.owner.login' repo.json

# Object Identifier-Index:
# jq lets us select elements in a JSON document like it's a JavaScript object. Just start with . (for the whole document) 
# and drill down to the value we want. It ends up looking something like this:
jq '.key.subkey.subsubkey'

#--------------------------------------------------------Select Arrays--------------------------------------------------------

# If we curl the GitHub Issues API, we will get back an array of issues:
curl "https://api.github.com/repos/stedolan/jq/issues?per_page=5" > issues.json; cat issues.json

# To get a specific element in the array, we give jq an index:
jq '.[4]' issues.json

# Array Indexing in jq:
# Array indexing has some helpful convenience syntax. We can select ranges:
echo "[1,2,3,4,5]" | jq '.[2:4]'
# We can select one sided ranges:
echo "[1,2,3,4,5]" | jq '.[2:]'
# Also, we can use negatives to select from the end:
echo "[1,2,3,4,5]" | jq '.[-2:]'

# We can use the array index with the object index:
jq '.[4].title' issues.json

# And we can use [] to get all the elements in the array. For example, here is how we would get the titles of the issues 
# returned by the API request:
jq '.[].title' issues.json

# Array-Index:
# jq lets us select the whole array [], a specific element [3], or ranges [2:5] and combine these with the object index 
# if needed. It ends up looking something like this:
jq '.key[].subkey[2]'

# Removing Quotes From JQ Output:
# The -r option in jq gives us raw strings if we need that.
echo '["1","2","3"]' | jq -r '.[]'
# The -j option (for join) can combine together our output.
echo '["1","2","3"," "]' | jq -j '.[]'

#-------------------------------------------------Putting Elements in an Array------------------------------------------------

# Once we start using the array index to select elements, we have a new problem. The data returned won't be a valid JSON 
# document. In the example above, the issue titles were new line delimited:
jq '.[].title' issues.json

# In fact, whenever we ask jq to return an unwrapped collection of elements, it prints them each on a new line. 
# We can see this by explicitly asking jq to ignore its input and instead return two numbers:
echo '""' | jq '1,2'

# We can resolve this the same way we would turn the text 1,2 into an array in JavaScript: By wrapping it in an 
# array constructor [ ... ].
echo '""' | jq '[1,2]'

# Similarly, to put a generated collection of results into a JSON array, we wrap it in an array constructor [ ... ].
# Our GitHub issue title filter (.[].title) then becomes [ .[].title ] like this:
jq '[ .[].title ]' issues.json
# Now we have a valid JSON document.

# Array Constructors:
# If our jq query returns more than one element, they will be returned newline delimited.
echo '[{"a":"b"},{"a":"c"}]' | jq '.[].a'
# To turn these values into a JSON array, what we do is similar to creating an array in JavaScript: We wrap the values 
# in an array constructor ([...]). It ends up looking something like this:
echo '[{"a":"b"},{"a":"c"}]' | jq '[ .[].a ]'

#-----------------------------------------------------Select Multiple Fields--------------------------------------------------

# The GitHub issues API has a lot of details we don't care about. We want to select multiple fields from the returned JSON 
# document and leave the rest behind. The easiest way to do this is using ',' to specify multiple filters:
jq ' .[].title, .[].number' issues.json

# But this is returning the results of one selection after the other. To change the ordering, we can factor out the array 
# selector:
jq '.[] | .title, .number' issues.json

# This refactoring uses a pipe (|) and runs our object selectors (.title and .number) on each array element. 
# If we wrap the query in the array constructor we get this:
jq '[ .[] | .title, .number ]' issues.json

# But this still isn't the JSON document we need. To get these values into a proper JSON object, we need an object 
# constructor {...}.

#-------------------------------------------------Putting Elements Into an Object---------------------------------------------

# Let's look at some simple examples before showing how our GitHub query can use an object constructor.
# We have an array that contains a name (["Adam", "Gordon", "Bell"]), and we want to turn it into a JSON object like this:
{ "first": "Adam", "last": "Bell" }

# We can select the elements we need using array indexing like this:
echo '["Adam", "Gordon", "Bell"]' | jq -r '.[0], .[2]'

# To wrap those values into the shape we need, we can replace the values with the array indexes that return them:
echo '["Adam", "Gordon", "Bell"]' | jq '{"first":.[0], "last":.[2]}'

# This syntax is the same syntax for creating an object in a JSON document. The only difference is we can use the object 
# and array queries we've built up as the values.

# Returning to our GitHub API problem, to wrap the number and the title up into an array we use the object constructor 
# like this:
jq '[ .[] | { title: .title, number: .number}]' issues.json

# Object Constructors:
# To put the elements we've selected back into a JSON document, we can wrap them in an object constructor { ... }.
# If we were building up a JSON object out of several selectors, it would end up looking something like this:
jq '{ "key1": <<jq filter>>, "key2": <<jq filter>> }'
# Which is the same syntax for an object in a JSON document, except with jq we can use filters as values.

#=======================================================SUMMARIZE DATA========================================================

#----------------------------------------------------Sorting and Counting-----------------------------------------------------

# The next problem we have is that we want to summarize some of this JSON data. Each issue returned by GitHub has a 
# collection of labels:
jq '{ title: .title, number: .number, labels: .labels }' issue.json

# If we want those labels in alphabetical order we can use the built in sort function. It works like this:
echo '["3","2","1"]' | jq 'sort'

# This is similar to how we would sort an array in JavaScript:
const l = ["3","2","1"]; l.sort();

# Other built-ins that mirror JavaScript functionality are available, like length, reverse, and tostring and they can all 
# be used in a similar way:
echo '["3","2","1"]' | jq 'reverse'
echo '["3","2","1"]' | jq 'length'

# If we can combine these built-ins with the selectors we've built up so far, we'll have solved our label sorting problem. 

# Array-Index:
# jq has many built-in functions. There are probably too many to remember but the built-ins tend to mirror JavaScript 
# functions, so give those a try before heading to the jq manual, and you might get lucky.

#------------------------------------------------------Pipes and Filters------------------------------------------------------

# jq is a filter in the UNIX command line sense. we pipe (|) a JSON document to it, and it filters it and outputs it to 
# standard out. We could easily use this feature to chain together jq invocations like this:
echo '{"title":"JQ Select"}' | jq '.title' | jq 'length'

# This is a wordy, though simple, way to determine the length of a string in a JSON document. We can use this same idea to 
# combine various jq built-in functions with the features we've shown so far. But there is an easier way, though. 
# We can use pipes inside of jq and conceptually they work just like shell pipes:
echo '{"title": "JQ Select"}' | jq '.title | length'

# Here are some more examples:
.title | length # will return the length of the title
.number | tostring # will return the issue number as a string
.[] | .key # will return the values of key 'key' in the array (this is equivalent to this .[].key)

# This means that sorting our labels array is simple. We can just change .labels to .labels | sort:
jq '{ title: .title, number: .number, labels: .labels | sort }' issue.json

# And if we want just a label count that is easy as well:
jq '{ title: .title, number: .number, labels: .labels | length }' issue.json

# Pipes and Filters:
# Everything in jq is a filter that we can combine with pipes (|). This mimics the behavior of a UNIX shell.
# We can use the pipes and the jq built-ins to build complicated transformations from simple operations.
# It ends up looking something like this:
jq '.key1.subkey2[] | sort'
jq '.key2.subkey | length'
jq '.key3 | floor | tostring | length'

#-------------------------------------------------------Maps and Selects------------------------------------------------------

# The issues list we were looking at has many low-quality issues in it. Let's say we want to grab all the items that are 
# labeled. This would let us skip all the drive-by fix-your-problem issues. Unfortunately, it's impossible to do this with the 
# GitHub API unless we specify all the possible labels in our query. However, we can easily do this query on the command line 
# by filtering our results with jq. However, to do so, we're going to need a couple more jq functions.
# Our query so far looks like this:
jq '[ .[] | { title: .title, number: .number, labels: .labels | length } ]' issues.json

# The first thing we can do is simplify it using map.
jq 'map({ title: .title, number: .number, labels: .labels | length })' issues.json

# map(...) lets us unwrap an array, apply a filter and then rewrap the results back into an array. We can think of it as a 
# shorthand for [ .[] | ... ]. We can combine that with a select statement that looks like this:
map(select(.labels > 0))

# select is a built-in function that takes a boolean expression and only returns elements that match. It's similar to the 
# WHERE clause in a SQL statement or array filter in JavaScript. Putting this all together looks like this:
jq 'map({ title: .title, number: .number, labels: .labels | length }) | map(select(.labels > 0))' issues.json

# This uses three object indexes, two maps, two pipes, a length function, and a select predicate.
# It's all just composing together filters until we get the result we need.

#=========================================================IN REVIEW===========================================================

# jq lets us select elements by starting with a . and accessing keys and arrays like it's a JavaScript Object (which it is). 
# This feature uses the Object and Array index of a JSON document that jq creates and look like this:
jq '.key[0].subkey[2:3].subsubkey'

# jq programs can contain object constructors {...} and array constructors [...]. We use these when we want to wrap back up 
# something we've pulled out of a JSON document using the above indexes:
jq '[{ key1: .key1, key2: .key2 }]'

# jq contains built-in functions (length, sort, select, map) and pipes (|), and we can compose these together just like we 
# can combine pipes and filters at the command line:
jq 'map({ order-of-magitude: .items | length | tostring | length })