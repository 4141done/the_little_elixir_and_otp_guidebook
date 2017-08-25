# Notes

## Calling Erlang methods
Example with ```httpc```
```
:inets.start #erlang functions are prefixed with a colon and invoked with a dot vs erlang (random:uniform(123) becomes :random.uniform(123))
:ssl.start
{:ok, {status, headers, body}} = :httpc.request 'https://www.reddit.com'
IO.puts body
```

## Erlang observer
Get information about the VM
```
:observer.start
```