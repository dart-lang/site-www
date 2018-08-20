The first example needs a connection from the outside to trigger the error.
I added example1b.dart to show what actually happens: the error shuts down
the broadcast stream, but the actual requests are still coming in (showing
that the socket wasn't shut down, and we have a resource leak).
