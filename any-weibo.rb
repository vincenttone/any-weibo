#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/gvbo.rb'
g = GVbo.new File.dirname(__FILE__) +'/data/token.yml'
g.run
