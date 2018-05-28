# git-recover
CLI to recover discarded changes from git on macOS


# ![](http://159.203.107.53/Example.gif "Logo Title Text 1")


One day you're doing your usual git commands and all of a sudden you accidently discard all of your local changes and there's no way to recover all the progress you just made 👎. [George Marmaridis](https://stackoverflow.com/users/1391932/george-marmaridis) came up with a clever solution to the problem [here](https://stackoverflow.com/a/29675597/5905822) where you use TextEdit to browse all of the local versions of your file.  I dug a little deeper and discovered that TextEdit uses the `NSFileVersion` API to browse all the local versions of a given file.  Instead of having to manually open each file in your in TextEdit, git-recover will view all versions of every file in your repo to revert them back to the version you specify.

**This tool will not recover files that were deleted or created locally before your changes were discarded**
# Arguments

`-d` directory to evaluate

`-t` time to revert your directory back to (in format `MM/dd/yyyy hh:mm a` ie: 5/15/2018 5:10 pm)

 
