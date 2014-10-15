export EDITOR=vim

source ~/.aliases/bundler.sh
source ~/.aliases/git.sh
source ~/.aliases/system.sh
source ~/.aliases/vim.sh

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh

# Allow overriding system default tools.
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/share/npm/bin:$PATH"

# Include homebrew installed c header file when compiling.
export C_INCLUDE_PATH="/usr/local/include"

# Adjust the ruby memory profile for faster startup times.
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000
