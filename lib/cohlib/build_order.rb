# frozen_string_literal: true

module CohLib
  # The complete build order for a single player, extracted from a replay.
  # Obtained via {VersionedStore#extract_build_order}.
  #
  # @!method actions
  #   Chronologically ordered list of build actions.
  #   @return [Array<BuildAction>]
  class BuildOrder
  end
end
