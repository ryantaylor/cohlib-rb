# frozen_string_literal: true

module CohLib
  # A parsed CoH3 replay file. Constructed via {.from_bytes}; all fields are
  # read-only and populated at parse time.
  #
  # @!method self.from_bytes(bytes)
  #   Parse raw replay bytes and return a {Replay}.
  #   @param bytes [Array<Integer>] byte array of a `.rec` file
  #   @return [Replay]
  #   @raise [RuntimeError] on parse failure
  #
  # @!method version
  #   Build version encoded in the replay header (e.g. 10612).
  #   @return [Integer]
  #
  # @!method timestamp
  #   Recording timestamp string as it appears in the replay (UTF-16 origin).
  #   @return [String]
  #
  # @!method game_type
  #   Game type: one of `"skirmish"`, `"multiplayer"`, `"automatch"`, `"custom"`.
  #   @return [String]
  #
  # @!method matchhistory_id
  #   Relic matchhistory ID, or +nil+ for skirmish games.
  #   @return [Integer, nil]
  #
  # @!method mod_uuid
  #   UUID of the active mod (all-zeros for the base game).
  #   @return [String]
  #
  # @!method map_filename
  #   Scenario filename stored in the replay.
  #   @return [String]
  #
  # @!method map_localized_name_id
  #   Localization key for the map name.
  #   @return [String]
  #
  # @!method map_localized_description_id
  #   Localization key for the map description.
  #   @return [String]
  #
  # @!method length
  #   Total tick count. Divide by 8 for duration in seconds.
  #   @return [Integer]
  #
  # @!method players
  #   All players in this match.
  #   @return [Array<Player>]
  class Replay
  end
end
