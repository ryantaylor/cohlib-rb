# frozen_string_literal: true

require_relative 'cohlib/version'
require_relative 'cohlib/cohlib'

require_relative 'cohlib/replay'
require_relative 'cohlib/player'
require_relative 'cohlib/message'
require_relative 'cohlib/build_action'
require_relative 'cohlib/build_order'
require_relative 'cohlib/versioned_store'

# Company of Heroes 3 data parsing powered by the cohlib Rust library.
#
# == Quick start
#
#   # Load bundled game data once (cache this object)
#   store = CohLib::VersionedStore.bundled
#
#   # Parse a replay
#   replay = CohLib::Replay.from_bytes(File.binread('match.rec').bytes)
#   puts replay.version        # => 10612
#   puts replay.players.count  # => 2
#
#   # Extract a build order for player 0
#   build_order = store.extract_build_order(replay, 0)
#   build_order.actions.each { |a| puts "#{a.tick}: #{a.action_type} #{a.pbgid}" }
module CohLib
end
