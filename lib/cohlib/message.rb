# frozen_string_literal: true

module CohLib
  # A chat message sent by a player during a match.
  #
  # @!method tick
  #   Tick at which the message was sent. Divide by 8 for seconds.
  #   @return [Integer]
  #
  # @!method message
  #   Message text.
  #   @return [String]
  #
  # @!method to_h
  #   Hash representation with +:tick+ and +:message+ keys.
  #   @return [Hash]
  class Message
  end
end
