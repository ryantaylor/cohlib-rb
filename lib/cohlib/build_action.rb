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
  #   PascalCase action type string. One of:
  #     - `"ConstructBuilding"`
  #     - `"TrainUnit"`
  #     - `"ResearchUpgrade"`
  #     - `"SelectBattlegroup"`
  #     - `"SelectBattlegroupAbility"`
  #     - `"UseBattlegroupAbility"`
  #     - `"AITakeover"`
  #   @return [String]
  #
  # @!method pbgid
  #   pbgid of the entity, ability, or upgrade involved.
  #   @return [Integer]
  #
  # @!method suspect_since
  #   Tick at which this building was marked suspect, or +nil+ if not suspect.
  #   @return [Integer, nil]
  #
  # @!method cancelled
  #   +true+ if this action was explicitly cancelled.
  #   @return [Boolean]
  #
  # @!method to_h
  #   Hash with +:tick+, +:action_type+, +:pbgid+, +:suspect_since+, and +:cancelled+ keys.
  #   @return [Hash]
  class BuildAction
  end
end
