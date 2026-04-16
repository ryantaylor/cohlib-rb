# frozen_string_literal: true

module CohLib
  # A single action in a player's build order.
  #
  # @!method tick
  #   Game tick of the action. Divide by 8 for seconds.
  #   @return [Integer]
  #
  # @!method index
  #   Command index within the tick, used for ordering tied actions.
  #   @return [Integer]
  #
  # @!method action_type
  #   Snake-case action type string. One of:
  #     - `"construct_building"`
  #     - `"train_unit"`
  #     - `"research_upgrade"`
  #     - `"select_battlegroup"`
  #     - `"select_battlegroup_ability"`
  #     - `"use_battlegroup_ability"`
  #     - `"ai_takeover"`
  #   @return [String]
  #
  # @!method pbgid
  #   pbgid of the entity, ability, or upgrade involved.
  #   @return [Integer]
  #
  # @!method suspect
  #   +true+ if this building may have been cancelled before use.
  #   @return [Boolean]
  #
  # @!method cancelled
  #   +true+ if this action was explicitly cancelled.
  #   @return [Boolean]
  #
  # @!method to_h
  #   Hash with +:tick+, +:action_type+, +:pbgid+, and +:suspect+ keys.
  #   @return [Hash]
  class BuildAction
  end
end
