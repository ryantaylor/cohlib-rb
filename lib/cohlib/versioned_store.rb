# frozen_string_literal: true

module CohLib
  # A version-aware store of CoH3 game data that backs build order extraction.
  #
  # The recommended usage is to create one instance via {.bundled} and reuse it
  # across all replay processing in the same process:
  #
  #   STORE = CohLib::VersionedStore.bundled
  #   replay = CohLib::Replay.from_bytes(File.binread('match.rec').bytes)
  #   build_order = STORE.extract_build_order(replay, 0, false)
  #
  # @!method self.bundled
  #   Load all historical game data compiled into the library. This decompresses
  #   and deserializes the embedded bundle, so the returned object should be
  #   cached and reused rather than constructed on every request.
  #   @return [VersionedStore]
  #
  # @!method extract_build_order(replay, player_index, include_cancelled)
  #   Extract the build order for one player from a parsed replay.
  #
  #   Game data is resolved using the replay's build version, with automatic
  #   fallback to the nearest known version.
  #   @param replay [Replay] a parsed replay
  #   @param player_index [Integer] zero-based index into {Replay#players}
  #   @param include_cancelled [Boolean] when +true+, cancelled actions are
  #     included in the returned {BuildOrder} with +cancelled: true+; when
  #     +false+ (the default behaviour), they are filtered out
  #   @return [BuildOrder]
  #   @raise [RuntimeError] if the player index is out of range
  class VersionedStore
  end
end
