# frozen_string_literal: true

module CohLib
  # A player in a parsed CoH3 replay.
  #
  # @!method name
  #   Display name at time of recording.
  #   @return [String]
  #
  # @!method human?
  #   +true+ if the player is human (not AI).
  #   @return [Boolean]
  #
  # @!method faction
  #   Faction string: one of `"americans"`, `"british_africa"`, `"germans"`,
  #   `"afrika_korps"`.
  #   @return [String]
  #
  # @!method team
  #   Team index (0 or 1).
  #   @return [Integer]
  #
  # @!method battlegroup
  #   pbgid of the selected battlegroup, or +nil+ if none was chosen.
  #   @return [Integer, nil]
  #
  # @!method battlegroup_selected_at
  #   Tick at which the battlegroup was selected, or +nil+.
  #   @return [Integer, nil]
  #
  # @!method ai_takeover_at
  #   Tick at which AI took over for this player, or +nil+ if they never dropped.
  #   @return [Integer, nil]
  #
  # @!method steam_id
  #   Steam ID (64-bit), or +nil+ for AI players.
  #   @return [Integer, nil]
  #
  # @!method profile_id
  #   Relic profile ID, or +nil+ for AI players.
  #   @return [Integer, nil]
  #
  # @!method messages
  #   Chat messages sent by this player, in chronological order.
  #   @return [Array<Message>]
  class Player
  end
end
