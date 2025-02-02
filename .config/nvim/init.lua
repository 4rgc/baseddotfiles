-- basic settings
require('vars')
-- bootstrap plugin manager
require('lazy_bootstrap')
-- load plugins
require('lazy').setup('plugins')
-- commands use plugins
require('commands')
-- mappings use plugins and custom commands
require('mappings')
-- autocmds use commands and plugins
require('autocmds')
-- things that have to go at the end
require('postconfig')

