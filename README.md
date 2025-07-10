# minizip.zig

Before this project, I always resorted to spawning a child process using the
system's `zip` command. Then, I watched the Grok 4 announcement and decided to
put Grok to the Zig test.

Well, Grok 4 ...

- ... first showed me that [miniz](https://github.com/richgel999/miniz) is a great
candidate for integration with Zig
- then also provided an example that needed only minimal fiddling to get right (like, `MZ_FALSE` instead of `mz_false`).

I wanted basic zipping functionality where I would provide tuples of input and archive filenames - and this is the super-simple result!

I am impressed by Grok 4, and will keep this implementation. I'll soon integrate it into [fj - The Commandline Company](https://github.com/technologylab-ai/fj), for even more natively zipped travel expense records 🤣!
